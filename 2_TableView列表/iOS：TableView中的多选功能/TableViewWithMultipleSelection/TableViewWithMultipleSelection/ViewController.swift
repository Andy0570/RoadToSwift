//
//  ViewController.swift
//  TableViewWithMultipleSelection
//
//  Created by Qilin Hu on 2022/1/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!

    var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup TableView
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none

        tableView.dataSource = viewModel
        tableView.delegate = viewModel

        tableView.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)

        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton.isEnabled = hasSelection
        }
    }


    @IBAction func next(_ sender: Any) {
        print(viewModel.selectedItems.map { $0.title })
        tableView.reloadData()
    }
}
