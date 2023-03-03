//
//  UserViewController.swift
//  ServiceLayerExample
//
//  Created by Josh Rondestvedt on 12/1/21.
//

import Combine
import UIKit

fileprivate let cellId = "userCell"

final class UserViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = []

    private let viewModel = UserViewControllerViewModel()

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Users"
        view.backgroundColor = .systemBackground

        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // 1 - Subscribes to the viewModel to be notified with it changes
        viewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let user = viewModel.users[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = user.email
        content.secondaryTextProperties.color = .systemGray

        cell.contentConfiguration = content

        return cell
    }
}
