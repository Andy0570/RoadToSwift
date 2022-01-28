//
//  NSObject+ClassName.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

extension NSObject {
    /// String describing the class name.
    static var className: String {
        return String(describing: self)
    }
}
