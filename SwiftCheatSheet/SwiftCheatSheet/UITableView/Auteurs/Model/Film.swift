//
//  Film.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/14.
//

import Foundation

struct Film: Codable {
    let title: String
    let year: String
    let poster: String
    let plot: String
    var isExpanded: Bool

    // 自定义 init 方法，设置 isExpanded 为 false
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        poster = try container.decode(String.self, forKey: .poster)
        plot = try container.decode(String.self, forKey: .plot)

        isExpanded = false
    }
}
