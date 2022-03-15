//
//  CollapsExpandViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

/**
 非常简单，展开折叠 UITableView
 
 参考：<https://www.swiftdevcenter.com/expand-collapse-uitableview-swift/>
 */

import UIKit

class CollapsExpandViewController: UIViewController {

    private enum Constants {
        static let CellIdentifier = "Cell"
    }

    weak var tableView: UITableView!
    var arrayHeader = [1, 2, 3, 4]

    override func loadView() {
        super.loadView()

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        self.tableView = tableView
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "展开折叠 UITableView"

        view.backgroundColor = UIColor.systemBackground
        tableView.backgroundColor = UIColor.systemBackground
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension CollapsExpandViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayHeader.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrayHeader[section] == 0) ? 0 : 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier, for: indexPath)
        cell.textLabel?.text = "section: \(indexPath.section) row: \(indexPath.row)"
        return cell
    }

}

extension CollapsExpandViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        viewHeader.backgroundColor = UIColor.darkGray
        let button = UIButton(type: .custom)
        button.frame = viewHeader.bounds
        button.tag = section // 通过 UIButton 的 tag 传递 section 索引
        button.addTarget(self, action: #selector(tapSection(sender:)), for: .touchUpInside)
        button.setTitle("Section: \(section)", for: .normal)
        viewHeader.addSubview(button)
        return viewHeader
    }

    @objc func tapSection(sender: UIButton) {
        self.arrayHeader[sender.tag] = (self.arrayHeader[sender.tag] == 0) ? 1 : 0
        self.tableView.reloadSections([sender.tag], with: .fade)
    }

}
