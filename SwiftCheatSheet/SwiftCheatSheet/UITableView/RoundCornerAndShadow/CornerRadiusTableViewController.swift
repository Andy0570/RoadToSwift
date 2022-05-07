//
//  CornerRadiusTableViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/8.
//

import UIKit

/**
 UITableViewCell with Round Corners and Shadows in Swift 5
 <https://simaspavlos.medium.com/round-corners-and-shadow-in-uitableviewcell-swift-5-8eb903bf38a1>
 */
class CornerRadiusTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置圆角和阴影"
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.register(CornerRadiusTableViewCell.nib, forCellReuseIdentifier: CornerRadiusTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CornerRadiusTableViewCell.identifier, for: indexPath) as? CornerRadiusTableViewCell else {
            fatalError("Could not dequeue cell: CornerRadiusTableViewCell, make sure the cell is registered with table view")
        }

        if indexPath.row == 0 {
            cell.titleLabel.text = "在 cell 上同时设置圆角和阴影"
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "最佳实践"
        } else if indexPath.row == 2 {
            cell.titleLabel.text = "分别在不同的视图层上设置圆角和阴影"
        }

        return cell
    }
}
