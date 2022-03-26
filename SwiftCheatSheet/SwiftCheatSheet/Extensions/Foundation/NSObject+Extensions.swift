//
//  NSObject+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import Foundation

extension NSObject {
    /// 返回当前 class 名称的字符串形式
    static var className: String {
        return String(describing: self)
    }
}
