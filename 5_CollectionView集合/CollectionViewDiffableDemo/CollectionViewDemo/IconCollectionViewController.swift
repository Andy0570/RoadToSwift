//
//  IconCollectionViewController.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 13/1/2021.
//

/// Reference: <https://www.appcoda.com/diffable-data-source/>

import UIKit

private let reuseIdentifier = "Cell"

enum Section {
    case all
}

class IconCollectionViewController: UICollectionViewController {

    private var iconSet: [Icon] = [ Icon(name: "candle", price: 3.99, isFeatured: false),
                                    Icon(name: "cat", price: 2.99, isFeatured: true),
                                    Icon(name: "dribbble", price: 1.99, isFeatured: false),
                                    Icon(name: "ghost", price: 4.99, isFeatured: false),
                                    Icon(name: "hat", price: 2.99, isFeatured: false),
                                    Icon(name: "owl", price: 5.99, isFeatured: true),
                                    Icon(name: "pot", price: 1.99, isFeatured: false),
                                    Icon(name: "pumkin", price: 0.99, isFeatured: false),
                                    Icon(name: "rip", price: 7.99, isFeatured: false),
                                    Icon(name: "skull", price: 8.99, isFeatured: false),
                                    Icon(name: "sky", price: 0.99, isFeatured: false),
                                    Icon(name: "toxic", price: 2.99, isFeatured: false),
                                    Icon(name: "ic_book", price: 2.99, isFeatured: false),
                                    Icon(name: "ic_backpack", price: 3.99, isFeatured: false),
                                    Icon(name: "ic_camera", price: 4.99, isFeatured: false),
                                    Icon(name: "ic_coffee", price: 3.99, isFeatured: true),
                                    Icon(name: "ic_glasses", price: 3.99, isFeatured: false),
                                    Icon(name: "ic_ice_cream", price: 4.99, isFeatured: false),
                                    Icon(name: "ic_smoking_pipe", price: 6.99, isFeatured: false),
                                    Icon(name: "ic_vespa", price: 9.99, isFeatured: false)]

    // 使用 lazy 修饰该变量，只有实例初始化完成之后，才能检索该变量
    lazy var dataSource = configureDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the layout and item size
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 100, height: 150)
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = 10
        }

        // 连接集合视图与数据源
        collectionView.dataSource = dataSource
        updateSnapshot()
    }

    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Icon> {

        // 创建 UICollectionViewDiffableDataSource<Section, Icon> 实例，它是一个泛型对象，能够处理集合中不同的 section 和 item。
        // <Section, Icon> 中的 Section 表示我们使用自定义的 Section 枚举类型处理 section 部分。
        // <Section, Icon> 中的 Icon 表示我们使用 Icon 类型处理 cell 数据。
        let dataSource = UICollectionViewDiffableDataSource<Section, Icon>(collectionView: collectionView) { (collectionView, indexPath, icon) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell
            cell.iconImageView.image = UIImage(named: icon.name)
            cell.iconPriceLabel.text = "$\(icon.price)"

            return cell
        }

        return dataSource
    }

    private func updateSnapshot(animatingDifferences: Bool = false) {
        // 创建一个 Snapshot 并填充数据
        var snapshot = NSDiffableDataSourceSnapshot<Section, Icon>()
        snapshot.appendSections([.all])
        snapshot.appendItems(iconSet, toSection: .all)
        // 将 Snapshot 应用到数据源
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
    }

}
