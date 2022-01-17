//
//  ViewController.swift
//  CollaspibleUICollectionView
//
//  Created by Qilin Hu on 2022/1/17.
//

// MARK: 可折叠展开的集合视图，参考<https://www.swiftjectivec.com/collapsable-collectionview/>
import UIKit

// 支持父-子关系的数据模型
struct Item: Hashable {
    let id = UUID()
    let title: String
    let subItems: [Item]
}

// 类型别名，建议把任何可区别的数据源类型化，以保证可读性。
typealias CollectionDataSource = UICollectionViewDiffableDataSource<Int, Item>

class ViewController: UIViewController {

    private let data: [Item] = {
        return [Item(title: "Programming Languages", subItems: [Item(title: "Swift", subItems: []),
                                                             Item(title: "C++", subItems: []),
                                                             Item(title: "C#", subItems: [])])]
    }()

    private lazy var collectionView: UICollectionView = {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()

    lazy var dataSource: CollectionDataSource = {
        // 注册重用 cell，header cell
        let parentItemCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, model in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = model.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration

            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
        }

        // 注册重用 cell，item cell
        let subItemsCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, model in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = model.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
            contentConfiguration.textProperties.color = .label
            cell.contentConfiguration = contentConfiguration

            let disclosureOptions = UICellAccessory.disclosureIndicator()
            cell.accessories = [disclosureOptions]
        }

        // 创建 diffable 数据源，我们检查 model，以确定它是一个父类还是一个子类。根据结果，我们将返回正确的单元格配置并创建单元格。
        let dataSource = CollectionDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let configType = model.subItems.isEmpty ? subItemsCellRegistration : parentItemCellRegistration
            return collectionView.dequeueConfiguredReusableCell(using: configType, for: indexPath, item: model)
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.frame = view.bounds

        let firstParentItem = data.first!
        let subItems = data.first!.subItems

        // 创建数据源
        var snapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        // 添加第一段 section
        snapshot.append([firstParentItem], to: nil)
        // 填充该 section 部分内容
        snapshot.append(subItems, to: firstParentItem)
        // 应用
        dataSource.apply(snapshot, to: 0)
    }
}

