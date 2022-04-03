//
//  DiffableDatasourceTableView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/11.
//

/**
 使用 UITableView 建立 diffable 数据源。
 参考：
 <https://www.swiftjectivec.com/Diffable-Datasource-Tableview/>
 <https://jllnmercier.medium.com/swift-uitableviewdiffabledatasource-c8db02dec35a>
 */
import UIKit

// Diffable 数据源要求其底层模型必须遵守 Hashable 协议
struct VideoGame: Hashable {
    let id = UUID()
    let name: String
}

extension VideoGame {
    static var data = [
        VideoGame(name: "Mass Effect"),
        VideoGame(name: "Mass Effect 2"),
        VideoGame(name: "Mass Effect 3"),
        VideoGame(name: "ME: Andromeda"),
        VideoGame(name: "ME: Remaster")
    ]
}

/**
 查看 UITableViewDiffableDataSource 头文件声明：

 open class UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject, UITableViewDataSource where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable { }

 1. UITableViewDiffableDataSource 是 NSObject 的子类对象，同时它遵守 UITableViewDataSource 协议。
 2. 其中，SectionIdentifierType, ItemIdentifierType 是它包含的两个泛型类型。
 3. 这两个泛型类型被约束为需要遵守 Hashable 协议。

 typealias UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider = (_ tableView: UITableView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> UITableViewCell?

 Diffable 数据源在初始化时可能看起来有点令人生畏，所以我发现通过为你使用的每个数据源使用类型别名来阅读它会更容易。
 虽然这不是必需的，但我认为这里值得的。
 */
typealias TableDataSource = UITableViewDiffableDataSource<Int, VideoGame>

class DiffableDatasourceTableView: UIViewController {
    let videogames: [VideoGame] = VideoGame.data
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    lazy var dataSource: TableDataSource = {
        let dataSource = TableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            // 在 cellProvider 闭包中处理本质上是 cellForRow: 的内容
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier(), for: indexPath)
            cell.textLabel?.text = model.name
            return cell
        })

        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.reuseIdentifier())
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Diffable 数据源使用快照的概念。这就是它的易用性和强大的 diffing 的来源。
        // 使用 snapshot 对 dataSource 进行差异化比对，进行动态更新。
        // 在这里，你只需要考虑现在应该如何对数据进行建模。在这种情况下，我们已经获得了第一次加载所需的数据，因此我们将传递所有内容并应用它：
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(videogames, toSection: 0)
        dataSource.apply(snapshot)
    }
}
