//
//  SuperHeroDataSource.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

/// ListAdapterDataSource 协议用于确保 ListAdapter 知道它负责哪些数据以及如何显示它
class SuperHeroDataSource: NSObject, ListAdapterDataSource {
    private struct Constants {
        static let objects: [ListDiffable] = [
            SuperHero(firstName: "Peter", lastName: "Parker", superHeroName: "SpiderMan", icon: "🕷"),
            Ad(description: "Do you want to know what your future looks like? 🔮"),
            SuperHero(firstName: "Bruce", lastName: "Wayne", superHeroName: "Batman", icon: "🦇"),
            SuperHero(firstName: "Tony", lastName: "Stark", superHeroName: "Ironman", icon: "🤖"),
            SuperHero(firstName: "Bruce", lastName: "Banner", superHeroName: "Incredible Hulk", icon: "🤢")
        ]
    }

    // MARK: - ListAdapterDataSource

    // 返回应由适配器管理的对象
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return Constants.objects
    }

    // 返回对应模型的 SectionController
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is SuperHero {
            return SuperHeroSectionController()
        } else {
            return AdSectionController()
        }
    }

    // 如果不存在对象，则返回空白占位视图
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
