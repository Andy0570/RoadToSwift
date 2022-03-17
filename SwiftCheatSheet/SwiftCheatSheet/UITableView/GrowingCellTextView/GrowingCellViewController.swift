//
//  GrowingCellViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

/**
 在 UITableViewCell 中动态调整 UITextView 的高度

 参考：<https://www.swiftdevcenter.com/the-dynamic-height-of-uitextview-inside-uitableviewcell-swift/>
 */

import UIKit

class GrowingCellViewController: UIViewController {
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
        title = "动态调整 UITextView 的高度"

        // 自适应 Cell 高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        view.backgroundColor = UIColor.systemGray4
        tableView.backgroundColor = UIColor.systemGray4
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(GrowingCell.nib, forCellReuseIdentifier: GrowingCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension GrowingCellViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GrowingCell.identifier, for: indexPath) as? GrowingCell else {
            fatalError("Could not dequeue cell: GrowingCell")
        }

        cell.cellDelegate = self
        return cell
    }
}

extension GrowingCellViewController: GrowingCellProtocol {
    func updateHeightOfRow(_ cell: GrowingCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))

        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let currentIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: currentIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
