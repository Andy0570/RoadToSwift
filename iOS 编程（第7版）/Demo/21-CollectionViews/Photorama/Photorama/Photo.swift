//
//  Photo.swift
//  Photorama
//
//  Created by Qilin Hu on 2021/12/9.
//

import Foundation

class Photo: Codable {
    let title: String
    let remoteURL: URL?
    let photoID: String
    let dateTaken: Date
    
    // 创建一个遵守 CodingKey 协议的枚举类型，映射属性 <-> json 参数
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
}

// MARK: - Equatable Delegate

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        // 判断两个 Photo 实例的 photoID 属性值是否相等
        return lhs.photoID == rhs.photoID
    }
}
