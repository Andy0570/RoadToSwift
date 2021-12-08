//
//  ItemStore.swift
//  LootLogger
//
//  Created by Qilin Hu on 2021/11/15.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    
    // 构造保存路径：Documents/directory
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    init() {
        // 初始化时，解码之前保存到沙盒中的 Item 数据
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error reading in saved items:\(error)")
        }
        
        // 向通知中心注册，应用进入到后台时，保存 Item
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    // 创建 Item
    // @discardableresult 注释意味着该函数的调用方可以自由地忽略调用该函数的返回结果。
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    // 删除 Item
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    // 移动 Item
    func moveItem(form fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
    // 保存 Item
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL)")
        
        do {
            // 有两种内置的 coder 编码类型：PropertyListEncoder 和 JSONEncoder
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL, options: [.atomic])
            print("Saved all of the items")
            return true
        } catch let encodingError {
            print("Error encoding allItems:\(encodingError)")
            return false
        }
    }
}
