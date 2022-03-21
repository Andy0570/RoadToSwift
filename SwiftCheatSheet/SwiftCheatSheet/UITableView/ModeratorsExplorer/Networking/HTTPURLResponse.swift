//
//  HTTPURLResponse.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import Foundation

extension HTTPURLResponse {
    // 计算属性，HTTP 响应状态码是否返回成功
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
