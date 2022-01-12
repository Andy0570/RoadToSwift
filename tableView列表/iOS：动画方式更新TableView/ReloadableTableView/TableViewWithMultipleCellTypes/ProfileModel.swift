//
//  ProfileModel.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import Foundation

class Profile {
    var fullName: String?
    var pictureUrl: String?
    var email: String?
    var about: String?
    var friends = [Friend]()
    var profileAttributes = [Attribute]()

    // JSON -> Model
    init?(data: [String: AnyObject]?) {
        guard let data = data, let body = data["data"] as? [String: Any] else {
            return nil
        }

        self.fullName = body["fullName"] as? String
        self.pictureUrl = body["pictureUrl"] as? String
        self.about = body["about"] as? String
        self.email = body["email"] as? String

        if let friends = body["friends"] as? [[String: Any]] {
            self.friends = friends.map { Friend(json: $0) }
        }

        if let profileAttributes = body["profileAttributes"] as? [[String: Any]] {
            self.profileAttributes = profileAttributes.map { Attribute(json: $0) }
        }
    }
}

class Friend {
    var name = ""
    var pictureUrl = ""

    init(json: [String: Any]) {
        self.name = json["name"] as? String ?? ""
        self.pictureUrl = json["pictureUrl"] as? String ?? ""
    }
}

// 遵守 CustomStringConvertible 协议，在将实例转换为字符串时提供特定的表示方式
// 对比 Objective-C 中的 description 方法
extension Friend: CustomStringConvertible {
    var description: String {
        return "\(name): \(pictureUrl)"
    }
}

class Attribute {
    var key = ""
    var value = ""

    init(json: [String: Any]) {
       self.key = json["key"] as? String ?? ""
       self.value = json["value"] as? String ?? ""
    }
}

// 遵守 CustomStringConvertible 协议，在将实例转换为字符串时提供特定的表示方式
// 对比 Objective-C 中的 description 方法
extension Attribute: CustomStringConvertible {
    var description: String {
        return "\(key): \(value)"
    }
}
