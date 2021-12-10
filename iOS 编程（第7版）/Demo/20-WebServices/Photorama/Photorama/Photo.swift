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
