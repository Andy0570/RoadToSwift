import Foundation

import RxSwift
import RxCocoa

import Alamofire

typealias JSONObject = [String: Any]
typealias ListIdentifier = (username: String, slug: String)

protocol TwitterAPIProtocol {
    static func timeline(of username: String) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]>
    static func timeline(of list: ListIdentifier) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]>
    static func members(of list: ListIdentifier) -> (AccessToken) -> Observable<[JSONObject]>
}

struct TwitterAPI: TwitterAPIProtocol {

    // MARK: - API Addresses
    fileprivate enum Address: String {
        case timeline = "statuses/user_timeline.json"
        case listFeed = "lists/statuses.json"
        case listMembers = "lists/members.json"

        private var baseURL: String {
            return "https://api.twitter.com/1.1/"
        }
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }

    // MARK: - API errors
    enum Errors: Error {
        case requestFailed
    }

    // MARK: - API Endpoint Requests
    static func timeline(of username: String) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {
        return { account, cursor in
            return request(account, address: TwitterAPI.Address.timeline, parameters: ["screen_name": username, "contributor_details": "false", "count": "100", "include_rts": "true"])
        }
    }

    static func timeline(of list: ListIdentifier) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {
        return { account, cursor in
            var params = ["owner_screen_name": list.username, "slug": list.slug]
            if cursor != TimelineCursor.none {
                params["max_id"]   = String(cursor.maxId)
                params["since_id"] = String(cursor.sinceId)
            }
            return request(
                account, address: TwitterAPI.Address.listFeed,
                parameters: params)
        }
    }

    static func members(of list: ListIdentifier) -> (AccessToken) -> Observable<[JSONObject]> {
        return { account in
            let params = ["owner_screen_name": list.username,
                          "slug": list.slug,
                          "skip_status": "1",
                          "include_entities": "false",
                          "count": "100"]
            let response: Observable<JSONObject> = request(
                account, address: TwitterAPI.Address.listMembers,
                parameters: params)

            return response
                .map { result in
                    guard let users = result["users"] as? [JSONObject] else {return []}
                    return users
                }
        }
    }

    // MARK: - generic request to send an SLRequest
    static private func request<T: Any>(_ token: AccessToken, address: Address, parameters: [String: String] = [:]) -> Observable<T> {
        return Observable.create { observer in
            var comps = URLComponents(string: address.url.absoluteString)!
            comps.queryItems = parameters.sorted{ $0.0 < $1.0 }.map(URLQueryItem.init)
            let url = try! comps.asURL()

            guard !TwitterAccount.isLocal else {
                if let cachedFileURL = Bundle.main.url(forResource: url.safeLocalRepresentation.lastPathComponent, withExtension: nil),
                    let data = try? Data(contentsOf: cachedFileURL), let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? T) as T??), let result = json {
                    observer.onNext(result)
                }
                observer.onCompleted()
                return Disposables.create()
            }

            let request = AF.request(url.absoluteString,
                                    method: .get,
                                    parameters: Parameters(),
                                    encoding: URLEncoding.httpBody,
                                    headers: ["Authorization": "Bearer \(token)"])

            request.responseJSON { response in
                guard response.error == nil, let data = response.data,
                      let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? T) as T??), let result = json else {
                    observer.onError(Errors.requestFailed)
                    return
                }

                observer.onNext(result)
                observer.onCompleted()
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension String {
    var safeFileNameRepresentation: String {
        return replacingOccurrences(of: "?", with: "-")
            .replacingOccurrences(of: "&", with: "-")
            .replacingOccurrences(of: "=", with: "-")
    }
}

extension URL {
    var safeLocalRepresentation: URL {
        return URL(string: absoluteString.safeFileNameRepresentation)!
    }
}
