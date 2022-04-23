//
//  SuperHero.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

/**
 使用 ListDiffable 创建数据模型

 ListDiffable 允许 IGListKit 唯一地识别和比较对象。某种程度上类似于 Swift 环境中已知的 Hashable 或 Equatable 协议。
 在内部，它使用此功能自动更新 UICollectionView 中的数据。
 */
class SuperHero: ListDiffable {
    private var identifier: String = UUID().uuidString
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var superHeroName: String
    private(set) var icon: String

    init(firstName: String, lastName: String, superHeroName: String, icon: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.superHeroName = superHeroName
        self.icon = icon
    }

    // diffIdentifier - 返回一个唯一的对象，可以用来比较和识别我​​们的模型。
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    // isEqual - 将两个对象相互比较时使用
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? SuperHero else {
            return false
        }
        return self.identifier == object.identifier
    }
}
