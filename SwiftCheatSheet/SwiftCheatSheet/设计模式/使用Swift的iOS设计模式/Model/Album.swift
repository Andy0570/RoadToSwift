//
//  Album.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/17.
//

import Foundation

struct Album: Codable {
    let title: String
    let artist: String
    let genre: String
    let coverUrl: String
    let year: String
}

extension Album: CustomStringConvertible {
    var description: String {
        return "title: \(title)" +
          " artist: \(artist)" +
          " genre: \(genre)" +
          " coverUrl: \(coverUrl)" +
          " year: \(year)"
    }
}

// MARK: 装饰模式
// 动态地向对象添加行为和职责而无需修改其中代码。它是子类化的替代方案，通过用另一个对象包装它来修改类的行为。

typealias AlbumData = (title: String, value: String)

// 在扩展中将 Model 属性转换为 Array 数组。其中，每一个元素都是一个元组对象
extension Album {
    var tableRepresentation: [AlbumData] {
        return [
            ("Artist", artist),
            ("Album", title),
            ("Genre", genre),
            ("Year", year)
        ]
    }
}
