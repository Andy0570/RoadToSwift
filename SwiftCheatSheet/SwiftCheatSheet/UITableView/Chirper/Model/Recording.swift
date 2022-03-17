//
//  Recording.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import Foundation

struct Recording: Codable {
    let id: String // xeno-canto 上录音的目录号
    let genus: String // 物种的通用名称
    let species: String // 物种的具体名称
    let friendlyName: String // 物种的英文名称
    let country: String // 录音的国家
    let fileURL: URL // 音频文件的 URL
    let date: String // 录制的日期

    enum CodingKeys: String, CodingKey {
        case id
        case genus = "gen"
        case species = "sp"
        case friendlyName = "en"
        case country = "cnt"
        case date
        case fileURL = "file"
    }
}
