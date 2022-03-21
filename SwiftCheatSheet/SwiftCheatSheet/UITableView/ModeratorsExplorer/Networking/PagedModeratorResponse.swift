//
//  PagedModeratorResponse.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

/// 分页查询 Moderator 数据，返回 JSON 模型
struct PagedModeratorResponse: Decodable {
    let moderators: [Moderator]
    let total: Int
    let hasMore: Bool
    let page: Int

    enum CodingKeys: String, CodingKey {
        case moderators = "items"
        case hasMore = "has_more"
        case total
        case page
    }
}
