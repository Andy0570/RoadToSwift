//
//  MyHelper.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/17.
//  参考: <https://kaushalelsewhere.medium.com/better-way-to-manage-swift-extensions-in-ios-project-78dc34221bc8>

import UIKit

public protocol MyHelperCompatible {
    associatedtype someType
    var my: someType { get }
}

public extension MyHelperCompatible {
    var my: MyHelper<Self> {
        get { return MyHelper(self) }
    }
}

public struct MyHelper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// All conformance here
extension UIColor: MyHelperCompatible {}
