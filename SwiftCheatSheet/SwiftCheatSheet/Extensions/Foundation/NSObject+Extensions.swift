//
//  NSObject+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import Foundation

extension NSObject {
    /// String describing the class name.
    static var className: String {
        return String(describing: self)
    }
}
