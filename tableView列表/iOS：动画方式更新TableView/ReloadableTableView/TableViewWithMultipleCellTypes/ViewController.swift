//
//  ViewController.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let viewModel = ProfileViewModel()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        tableView?.dataSource = viewModel

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        // 注册重用 cell
        tableView.register(AboutCell.nib, forCellReuseIdentifier: AboutCell.identifier)
        tableView.register(NamePictureCell.nib, forCellReuseIdentifier: NamePictureCell.identifier)
        tableView.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)
        tableView.register(AttributeCell.nib, forCellReuseIdentifier: AttributeCell.identifier)
        tableView.register(EmailCell.nib, forCellReuseIdentifier: EmailCell.identifier)

        viewModel.addListener()
    }
}

// MARK: - ProfileViewModelDelegate

extension ViewController: ProfileViewModelDelegate {
    func apply(changes: SectionChanges) {
        self.tableView.beginUpdates()

        self.tableView.deleteSections(changes.deletes, with: .fade)
        self.tableView.insertSections(changes.inserts, with: .fade)
        self.tableView.reloadRows(at: changes.updates.reloads, with: .fade)
        self.tableView.insertRows(at: changes.updates.inserts, with: .fade)
        self.tableView.deleteRows(at: changes.updates.deletes, with: .fade)

        self.tableView.endUpdates()
    }
}

