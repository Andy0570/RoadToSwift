//
//  ViewModel.swift
//  TableViewWithMultipleSelection
//
//  Created by Qilin Hu on 2022/1/24.
//

import Foundation
import UIKit

let dataArray = [Model(title: "Swift"), Model(title: "Objective-C"), Model(title: "Java"), Model(title: "Kotlin"), Model(title: "Java Script"), Model(title: "Python"), Model(title: "Ruby"), Model(title: "PHP"), Model(title: "Perl"), Model(title: "C#"), Model(title: "C++"), Model(title: "Pascal"), Model(title: "Visual Basic")]

class ViewModelItem {
    private var item: Model

    var isSelected = false
    var title: String {
        return item.title
    }

    init(item: Model) {
        self.item = item
    }
}

class ViewModel: NSObject {
    var items = [ViewModelItem]()

    // MARK: 缓存选中的 Model
    var selectedItems: [ViewModelItem] {
        return items.filter { return $0.isSelected }
    }

    // MARK: selectedItems 是否不为空，以更新页面中 next 按钮状态
    // 计算属性 didToggleSelection 是一个 Block 类型
    var didToggleSelection:((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }

    override init() {
        super.init()

        items = dataArray.map { ViewModelItem(item: $0) }
    }

}

extension ViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            cell.item = items[indexPath.row]

            // 同步模型和视图的选中状态
            if items[indexPath.row].isSelected {
                if !cell.isSelected {
                    // 如果 Model 选中了而Cell未选中，则选中cell
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    // 如果 Model 未选中而 Cell 选中了，则取消选中cell
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }

            return cell
        }
        return UITableViewCell()
    }

}

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
