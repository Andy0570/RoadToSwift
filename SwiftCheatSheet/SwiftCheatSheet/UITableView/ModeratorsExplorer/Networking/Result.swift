//
//  Result.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

// 网络请求响应结果：Result<PagedModeratorResponse, DataResponseError>
enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
