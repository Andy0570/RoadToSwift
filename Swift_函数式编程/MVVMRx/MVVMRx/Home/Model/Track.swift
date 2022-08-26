//
//  Track.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import Foundation

struct Track: Codable {
    let id, name, trackArtWork, trackAlbum: String
    let artist: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case trackArtWork = "track_art_work"
        case trackAlbum = "track_album"
        case artist
    }
}

extension Track {
    init?(data: Data) {
        do {
            let track = try JSONDecoder().decode(Track.self, from: data)
            self = track
        } catch {
            print(error)
            return nil
        }
    }
}
