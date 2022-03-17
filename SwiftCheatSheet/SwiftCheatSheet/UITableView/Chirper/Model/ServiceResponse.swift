//
//  ServiceResponse.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import Foundation

struct ServiceResponse: Codable {
    let numRecordings: String // 为此查询找到的记录总数
    let numSpecies: String // 为此查询找到的物种总数
    let page: Int // 正在显示的结果页面的页码
    let numPages: Int // 此查询可用的总页数
    let recordings: [Recording] // 录音对象数组
}
