import Foundation

import RxSwift
import RxCocoa

import Alamofire
import Unbox

typealias AccessToken = String

struct TwitterAccount {
    static private var key: String = "placeholder"
    static private var secret: String = "placeholder"
    static var isLocal: Bool {
        return key == "placeholder"
    }

    private struct Token: Unboxable {
        let tokenString: String
        init(unboxer: Unboxer) throws {
            guard try unboxer.unbox(key: "token_type") == "bearer" else {
                throw Errors.invalidResponse
            }
            tokenString = try unboxer.unbox(key: "access_token")
        }
    }

    // logged or not
    enum AccountStatus {
        case unavailable
        case authorized(AccessToken)
    }

    enum Errors: Error {
        case unableToGetToken, invalidResponse
    }

    // MARK: - Properties

    // MARK: - Getting the current twitter account
    private func oAuth2Token(completion: @escaping (String?)->Void) -> DataRequest {
        let parameters: Parameters = ["grant_type": "client_credentials"]

        //var headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"]
        var headers: HTTPHeaders = [
            .authorization(username: TwitterAccount.key, password: TwitterAccount.secret),
            .accept("application/x-www-form-urlencoded;charset=UTF-8")
        ]

        //    return AF.request("https://api.twitter.com/oauth2/token", method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseDecodable { response in
        //      guard response.error == nil, let data = response.data, let token: Token = try? unbox(data: data) else {
        //        completion(nil)
        //        return
        //      }
        //      completion(token.tokenString)
        //    }

        return AF.request("https://api.twitter.com/oauth2/token",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody,
                          headers: headers
        ).responseJSON { response in
            guard response.error == nil, let data = response.data, let token: Token = try? unbox(data: data) else {
                completion(nil)
                return
            }
            completion(token.tokenString)
        }
    }

    var `default`: Driver<AccountStatus> {
        return TwitterAccount.isLocal ? localAccount : remoteAccount
    }

    private var localAccount: Driver<AccountStatus> {
        return Observable.create({ observer in
            observer.onNext(.authorized("localtoken"))
            return Disposables.create()
        })
        .asDriver(onErrorJustReturn: .unavailable)
    }

    private var remoteAccount: Driver<AccountStatus> {
        return Observable.create({ observer in
            var request: DataRequest?

            if let storedToken = UserDefaults.standard.string(forKey: "token") {
                observer.onNext(.authorized(storedToken))
            } else {
                request = self.oAuth2Token { token in
                    guard let token = token else {
                        observer.onNext(.unavailable)
                        return
                    }
                    UserDefaults.standard.set(token, forKey: "token")
                    observer.onNext(.authorized(token))
                }
            }

            return Disposables.create {
                request?.cancel()
            }
        })
        .asDriver(onErrorJustReturn: .unavailable)
    }
}
