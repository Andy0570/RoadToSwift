//
//  Album.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import Foundation

struct Album: Codable {
    let id, name, albumArtWork, artist: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case albumArtWork = "album_art_work"
        case artist
    }
}

// MARK: Convenience initializers

extension Album {
    init?(data: Data) {
        guard let album = try? JSONDecoder().decode(Album.self, from: data) else {
            return nil
        }

        self = album
    }
}
