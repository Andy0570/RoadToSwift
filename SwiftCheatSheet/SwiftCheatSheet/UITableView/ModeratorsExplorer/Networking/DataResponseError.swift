//
//  DataResponseError.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

// 网络请求错误枚举类型
enum DataResponseError: Error {
    case network
    case decoding

    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data ".localizedString
        case .decoding:
            return "An error occurred while decoding data".localizedString
        }
    }
}
