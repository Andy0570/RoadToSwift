//
//  ViewModel.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

import UIKit

let dataArray = [Model(title: "Swift"), Model(title: "Objective-C"), Model(title: "Java"), Model(title: "Kotlin"), Model(title: "Java Script"), Model(title: "Python"), Model(title: "Ruby"), Model(title: "PHP"), Model(title: "Perl"), Model(title: "C#"), Model(title: "C++"), Model(title: "Pascal"), Model(title: "Visual Basic")]

class ViewModelItem {
    private var item: Model

    var isSelected = false // !!!: 保存 cell 选中状态
    var title: String {
        return item.title
    }

    init(item: Model) {
        self.item = item
    }
}

class ViewModel: NSObject {
    var items: [ViewModelItem] = []

    // MARK: 缓存选中的 Model
    var selectedItems: [ViewModelItem] {
        return items.filter { return $0.isSelected }
    }

    // MARK: 判断 selectedItems 是否不为空，以更新页面中 next 按钮状态
    var didToggleSelection: ((_ hasSelection: Bool) -> Void)?

    override init() {
        super.init()

        // [Model] -> [ViewModelItem]
        items = dataArray.map { ViewModelItem(item: $0) }
    }
}

// MARK: - UITableViewDataSource

extension ViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            fatalError("Could not dequeue cell: CustomTableViewCell")
        }

        let viewModelItem = items[indexPath.row]
        cell.item = viewModelItem

        // 同步模型和视图的选中状态
        if items[indexPath.row].isSelected {
            // 如果 ViewModelItem 是选中状态而 Cell 未选中，则选中 Cell
            if !cell.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        } else {
            // 如果 ViewModelItem 是未选中状态而 Cell 选中，则取消选中 Cell
            if cell.isSelected {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // update viewModel item
        items[indexPath.row].isSelected = true
        didToggleSelection?(!selectedItems.isEmpty)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // update viewModel item
        items[indexPath.row].isSelected = false
        didToggleSelection?(!selectedItems.isEmpty)
    }

    // MARK: 实现 item 选择最大数量限制，最多选中3个
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedItems.count > 2 {
            return nil
        }
        return indexPath
    }
}
