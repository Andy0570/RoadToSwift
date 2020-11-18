//
//  NSError+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

extension NSError {
    /// NSError 的便捷初始化器，用于设置描述信息。
    /// - Parameters:
    ///   - domain: The error domain.
    ///   - code: The error code.
    ///   - description: Some description for this error.
    convenience init(domain: String, code: Int, description: String) {
        self.init(domain: domain, code: code, userInfo: [(kCFErrorLocalizedDescriptionKey as CFString) as String: description])
    }
}

/**
 Usage:
 
 let myError = NSError(
   domain: "SomeDomain",
   code: 123,
   description: "Some description."
 )
 */
