//
//  ViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/16.
//

import UIKit

class ViewController: UIViewController {

    // 通过枚举的方式声明常量
    // 使用不带 case 的枚举的优点是：它不会被意外地实例化，并只作为一个纯命名空间。
    private enum Constants {
        static let CellIdentifier = "Cell"
    }

    private let sections = Section.sectionsFromBundle()
    private var arrayDataSource: ArrayDataSource! {
        didSet {
            tableView.dataSource = arrayDataSource
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier)
        tableView.delegate = self
        return tableView
    }()

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        // 如果我们添加了 scrollviews，这个技巧可以防止导航栏折叠
        // view.addSubview(UIView(frame: .zero))

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载数据源，设置代理
        arrayDataSource = ArrayDataSource(sections: sections, cellReuseIdentifier: Constants.CellIdentifier)
        arrayDataSource.cellConfigureClosure = { (tableViewCell, cell) in
            tableViewCell.configureForCell(cell: cell)
        }
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = self.arrayDataSource?.getCellItem(at: indexPath),
           let controller = item.className.getViewController() {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
