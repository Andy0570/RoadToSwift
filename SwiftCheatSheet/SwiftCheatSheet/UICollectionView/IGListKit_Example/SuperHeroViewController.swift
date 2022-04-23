//
//  SuperHeroViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

/// 10 分钟学习和掌握 ⚔️ IGListKit 的基础知识
/// 参考：<https://medium.com/ios-os-x-development/learn-master-%EF%B8%8F-the-basics-of-iglistkit-in-10-minutes-3b9ce8a2632b>
class SuperHeroViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // ListAdapter 的三个属性：
    // updater：处理 row 和 section 的更新，通常我们用默认实现就够了。
    // viewController： 此属性可用于稍后导航到其他 viewController，它应该是适配器所在的 viewController
    // workingRangeSize: 工作范围是尚未可见但在屏幕附近的 section controllers 的范围
    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        return ListAdapter(updater: updater, viewController: self, workingRangeSize: 1)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = SuperHeroDataSource()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
