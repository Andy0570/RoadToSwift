//
//  AuteurListViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/14.
//

import UIKit

/**
 参考：
 [Self-Sizing Table View Cells](https://www.raywenderlich.com/24698014-self-sizing-table-view-cells)
 */

class AuteurListViewController: UIViewController {

    private let auteurs = Auteur.auteursFromBundle()
    // 弱引用的隐式解包可选类型变量
    weak var tableView: UITableView!

    override func loadView() {
        super.loadView()

        let tableView = UITableView(frame: .zero, style: .plain)
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

        // 导航栏自动显示大标题
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold)]
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Auteurs"

        view.backgroundColor = UIColor(named: "AuteursBackground")
        tableView.backgroundColor = UIColor(named: "AuteursBackground")

        // !!!: 自适应 Cell 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AuteurTableViewCell.nib, forCellReuseIdentifier: AuteurTableViewCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension AuteurListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auteurs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AuteurTableViewCell.identifier, for: indexPath) as! AuteurTableViewCell
        let auteur = auteurs[indexPath.row]
        return cell.configure(name: auteur.name, bio: auteur.bio, sourceText: auteur.source, imageName: auteur.image)
    }
}

// MARK: - UITableViewDelegate

extension AuteurListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = AuteurDetailViewController()
        detailViewController.selectedAuteur = auteurs[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
