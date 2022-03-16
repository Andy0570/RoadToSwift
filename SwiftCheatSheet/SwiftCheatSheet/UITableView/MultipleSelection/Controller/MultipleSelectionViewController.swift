//
//  MultipleSelectionViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

import UIKit

class MultipleSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!

    var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableView 中的多选功能"

        // setup TableView
        tableView.rowHeight = 44
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none

        tableView.dataSource = viewModel
        tableView.delegate = viewModel

        tableView.register(CustomTableViewCell.nib, forCellReuseIdentifier: CustomTableViewCell.identifier)

        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton.isEnabled = hasSelection
        }
        self.nextButton.isEnabled = false
    }

    // MARK: Actions

    @IBAction func nextButtonTapped(_ sender: Any) {
        print(viewModel.selectedItems.map { $0.title })
    }
}
