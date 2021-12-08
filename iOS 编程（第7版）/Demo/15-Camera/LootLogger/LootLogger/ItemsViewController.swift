//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Qilin Hu on 2021/11/13.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.backButtonTitle = "Back"
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
        
    // MARK: - Actions
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        // 创建一个新的 Item 并添加到 store
        let newItem = itemStore.createItem()
        
        // 找出该 item 在数组中的位置
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // 将该新的 row 插入到 table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
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
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: - Table View Data Source
    
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
            
            // 更新模型，从 ImageStore 中移除关联的图片
            imageStore.deleteImage(forkey: item.itemKey)
            
            // 更新 UI，用动画从 table view 中移除该行
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 更新模型
        itemStore.moveItem(form: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
