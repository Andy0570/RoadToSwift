//
//  Dictionary+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/21.
//

import Foundation

/// 如果没有从字典中获取到值，则使用默认值
/// Reference: <https://www.swiftbysundell.com/articles/extending-optionals-in-swift/>
///
/// Usage：
/// let coins = dictionary.value(forKey: "numberOfCoins", defaultValue: 100)
/// let coins = (dictionary["numberOfCoins"] as? Int) ?? 100 // 功能同上
extension Dictionary where Value == Any {
    func value<T>(forKey key: Key, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self[key] as? T else {
            return defaultValue()
        }

        return value
    }
}
