//
//  TrackRenderable.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/23.
//

import Foundation

protocol TrackRenderableType {
    var title: String { get }
    var bottomText: String { get }
}

struct TrackRenderable: TrackRenderableType {
    let title: String
    let bottomText: String

    init(title: String, bottomText: String) {
        self.title = title
        self.bottomText = bottomText
    }

    init(track: Track) {
        self.title = track.name
        self.bottomText = "\(track.artist) · \(track.album))"
    }
}
