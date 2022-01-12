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

        tableView?.dataSource = viewModel

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(AboutCell.nib, forCellReuseIdentifier: AboutCell.identifier)
        tableView.register(NamePictureCell.nib, forCellReuseIdentifier: NamePictureCell.identifier)
        tableView.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)
        tableView.register(AttributeCell.nib, forCellReuseIdentifier: AttributeCell.identifier)
        tableView.register(EmailCell.nib, forCellReuseIdentifier: EmailCell.identifier)
    }
}

