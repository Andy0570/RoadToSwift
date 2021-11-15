//
//  ItemStore.swift
//  LootLogger
//
//  Created by Qilin Hu on 2021/11/15.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    
    // 指定初始化方法，创建 5 个随机的 Item
//    init() {
//        for _ in 0..<5 {
//            createItem()
//        }
//    }
    
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
}
