//
//  StringRepresentable.swift
//  Demo
//
//  Created by Andy0570 on 2022/4/27.
//

import Foundation

/**
 Reference: <https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/>

 Usage:
 private var likes: StringBacked<Int>
 它自身是 String 类型，但你可以通过访问它的 value 属性获取 Int 类型

 var numberOfLikes: Int {
     get { return likes.value }
     set { likes.value = newValue }
 }
 */
protocol StringRepresentable: CustomStringConvertible {
    init?(_ string: String)
}

extension Int: StringRepresentable {}

struct StringBacked<Value: StringRepresentable>: Codable {
    var value: Value

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        // String to Int
        guard let value = Value(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: """
                 Failed to convert an instance of \(Value.self) from "\(string)"
                 """
            )
        }

        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}
