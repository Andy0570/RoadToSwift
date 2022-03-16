//
//  Photo.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

import Foundation

struct Photos: Codable {
    let photos: [Photo]
}

/// 照片
struct Photo: Codable {
    let id: Int
    let name: String
    let description: String?
    // swiftlint:disable identifier_name
    let created_at: Date
    let image_url: String
    let for_sale: Bool
    let camera: String?
    // swiftlint:enable identifier_name
}
