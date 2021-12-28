//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Qilin Hu on 2021/11/13.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 如果被触发的 segue 是 "showItem" segue
        switch segue.identifier {
        case "showItem":
            // 找出刚才点击的是哪一行
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // 获取与此行关联的 item 并将其传递
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: Actions
    
    @IBAction func addNewItem(_ sender: UIButton) {
        
        // 创建一个新的 Item 并添加到 store
        let newItem = itemStore.createItem()
        
        // 找出该 item 在数组中的位置
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // 将该新的 row 插入到 table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    // 编辑模式
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            // 更改按钮文本以通知用户状态
            sender.setTitle("Edit", for: .normal)
            
            // 关闭编辑模式
            setEditing(false, animated: true)
        } else {
            // 更改按钮文本以通知用户状态
            sender.setTitle("Done", for: .normal)
            
            // 开启编辑模式
            setEditing(true, animated: true)
        }
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建默认样式的 UITableViewCell 实例
        // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        // 优化：从重用池中获取 UITableViewCell 实例
        // let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // 设置 item 描述
        let item = itemStore.allItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 如果 table view 被要求执行删除命令
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            // 更新模型，从 Store 中移除该 Item
            itemStore.removeItem(item)
            
            // 更新 UI，用动画从 table view 中移除该行
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 更新模型
        itemStore.moveItem(form: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
