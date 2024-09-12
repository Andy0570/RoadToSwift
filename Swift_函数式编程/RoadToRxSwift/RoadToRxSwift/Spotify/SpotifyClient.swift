//
//  SpotifyClient.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/23.
//

import Foundation
import SwiftyJSON
import RxSwift

/**
 <https://developer.spotify.com/documentation/web-api>

 // 发起查询之前，首先要通过 client_id 和 client_secret 获取 Bearer Token，再通过 Token 发起查询
 curl -X POST "https://accounts.spotify.com/api/token" \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -d "grant_type=client_credentials&client_id=004b7614d4b54960aba7c6e5c4db0bfc&client_secret=8ca759f19fa441dba8126092e15fd4e9"

 curl --request GET \
   --url 'https://api.spotify.com/v1/search?q=remaster%2520track%3ADoxy%2520artist%3AMiles%2520Davis&type=track' \
   --header 'Authorization: Bearer 1POdFZRZbvb...qqillRxMr2z'

 */
class SpotifyClient {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func search(query: String, callback: @escaping ([Track]) -> Void) -> URLSessionDataTask {
        let encodedQuery = encode(query: query) ?? ""
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer BQDVhqw9V42kFtl20MYnnHfe7QNWyJ0hA86wO9b3W8d5umEz0_PEJz2AS3PcnymH3SASamltgNq011rXpdneXkKGZ3D-swcLISsUTTLXJeH7oJC7aZs", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            let tracks = data.flatMap {
                do {
                    let json = try JSON(data: $0)
                    return json
                } catch {
                    return []
                }
            }.map(self.parseTracks) ?? []
            callback(tracks)
        }
        task.resume()
        return task
    }

    private func encode(query: String) -> String? {
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.insert(charactersIn: " ")
        return query.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)?
            .replacingOccurrences(of: " ", with: "+")
    }

    private func parseTracks(json: JSON) -> [Track] {
        return Track.tracks(json: json["tracks"]["items"].array)
    }
}

extension SpotifyClient: ReactiveCompatible {}

extension Reactive where Base: SpotifyClient {
    func search(query: String) -> Observable<[Track]> {
        return Observable.create { observer in
            let request = self.base.search(query: query) { tracks in
                observer.onNext(tracks)
            }
            return Disposables.create {
                request.cancel()
            }
        }.observe(on: MainScheduler.instance)
    }
}
