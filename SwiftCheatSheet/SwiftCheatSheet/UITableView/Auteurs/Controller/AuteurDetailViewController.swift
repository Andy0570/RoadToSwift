//
//  AuteurDetailViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/14.
//

import UIKit

class AuteurDetailViewController: UIViewController {
    var selectedAuteur: Auteur?
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

        title = selectedAuteur?.name

        view.backgroundColor = UIColor(named: "AuteursBackground")
        tableView.backgroundColor = UIColor(named: "AuteursBackground")

        // !!!: 自适应 Cell 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(FilmTableViewCell.nib, forCellReuseIdentifier: FilmTableViewCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension AuteurDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedAuteur?.films.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath)

        if let cell = cell as? FilmTableViewCell, let film = selectedAuteur?.films[indexPath.row] {
            cell.configure(title: film.title, plot: film.plot, isExpanded: film.isExpanded, poster: film.poster)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AuteurDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilmTableViewCell,
            var film = selectedAuteur?.films[indexPath.row] else {
                return
            }

        film.isExpanded.toggle()
        selectedAuteur?.films[indexPath.row] = film

        // !!!: 动态更新 Cell 高度
        tableView.beginUpdates()
        cell.configure(title: film.title, plot: film.plot, isExpanded: film.isExpanded, poster: film.poster)
        tableView.endUpdates()

        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
