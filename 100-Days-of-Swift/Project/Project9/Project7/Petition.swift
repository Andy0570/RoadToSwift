//
//  Petition.swift
//  Project7
//
//  Created by Qilin Hu on 2021/12/28.
//

import Foundation

// 遵守 Codable 协议的“请愿书"结构体
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
