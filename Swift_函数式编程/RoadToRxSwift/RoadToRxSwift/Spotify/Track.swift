//
//  Track.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/23.
//

import Foundation
import SwiftyJSON

struct Track {
    let name: String
    let artist: String
    let album: String

    init(name: String, artist: String, album: String) {
        self.name = name
        self.artist = artist
        self.album = album
    }

    init?(json: JSON) {
        guard let name = json["name"].string, 
                let artist = json["artists"].array?.first?["name"].string,
              let album = json["album"]["name"].string else {
            return nil
        }
        self.name = name
        self.artist = artist
        self.album = album
    }

    static func tracks(json: [JSON]?) -> [Track] {
        return json?.compactMap(Track.init) ?? []
    }
}
