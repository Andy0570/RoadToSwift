//
//  IconCollectionViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/22.
//

/**
 参考：Using Diffable Data Source with Collection Views
 <https://www.appcoda.com/diffable-data-source/>
 */

import UIKit

enum SectionType {
    case all
}

class IconCollectionViewController: UIViewController {
    
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

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the layout and item size
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 100, height: 150)
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = 10
        }

        // 注册重用 cell for nib
        collectionView.register(IconCollectionViewCell.nib, forCellWithReuseIdentifier: IconCollectionViewCell.identifier)

        // 连接集合视图与数据源
        collectionView.dataSource = dataSource
        updateSnapshot()
    }

    func configureDataSource() -> UICollectionViewDiffableDataSource<SectionType, Icon> {

        // 创建 UICollectionViewDiffableDataSource<Section, Icon> 实例，它是一个泛型对象，能够处理集合中不同的 section 和 item。
        // <Section, Icon> 中的 Section 表示我们使用自定义的 Section 枚举类型处理 section 部分。
        // <Section, Icon> 中的 Icon 表示我们使用 Icon 类型处理 cell 数据。
        let dataSource = UICollectionViewDiffableDataSource<SectionType, Icon>(collectionView: collectionView) { (collectionView, indexPath, icon) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
            cell.iconImageView.image = UIImage(named: icon.name)
            cell.iconPriceLabel.text = "$\(icon.price)"

            return cell
        }

        return dataSource
    }

    func updateSnapshot(animatingChange: Bool = false) {
        // 创建一个 NSDiffableDataSourceSnapshot 快照并填充数据
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Icon>()
        snapshot.appendSections([.all])
        snapshot.appendItems(iconSet, toSection: .all)

        // 将快照应用到数据源
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }

}
