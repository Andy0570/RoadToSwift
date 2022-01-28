//
//  DiffCalculator.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import Foundation

// MARK: -

struct ReloadableSection<N: Equatable>: Equatable {
    // 为每个 section 创建三个变量：唯一标识符、值和索引
    var key: String
    var value: [ReloadableCell<N>]
    var index: Int

    static func ==(lhs: ReloadableSection, rhs: ReloadableSection) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}

struct ReloadableCell<N: Equatable>: Equatable {
    // 为每个 cell 创建三个变量：唯一标识符、值和索引
    var key: String
    var value: N
    var index: Int

    static func ==(lhs: ReloadableCell, rhs: ReloadableCell) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}

// MARK: - 保存 section 和 cell 的变化

class SectionChanges {
   var insertsInts = [Int]()
   var deletesInts = [Int]()
   var updates = CellChanges()

    var inserts: IndexSet {
        return IndexSet(insertsInts)
    }

    var deletes: IndexSet {
        return IndexSet(deletesInts)
    }
}

class CellChanges{
   var inserts = [IndexPath]()
   var deletes = [IndexPath]()
   var reloads = [IndexPath]()
}

// MARK: -

// 这个结构体用来包装辅助工具方法，即下标语法
struct ReloadableSectionData<N: Equatable>: Equatable {
    var items = [ReloadableSection<N>]()

    // 自定义下标语法，通过 key 找到它所属的 ReloadableSection
    subscript(key: String) -> ReloadableSection<N>? {
        get {
            return items.filter { $0.key == key }.first
        }
    }

    // 自定义下标语法，通过 index 找到它所属的 ReloadableSection
    subscript(index: Int) -> ReloadableSection<N>? {
        get {
            return items.filter { $0.index == index }.first
        }
    }
}

struct ReloadableCellData<N: Equatable>: Equatable {
    var items = [ReloadableCell<N>]()

    // 自定义下标语法，通过 key 找到它所属的 ReloadableCell
    subscript(key: String) -> ReloadableCell<N>? {
        get {
            return items.filter { $0.key == key }.first
        }
    }

    // 自定义下标语法，通过 index 找到它所属的 ReloadableCell
    subscript(index: Int) -> ReloadableCell<N>? {
        get {
            return items.filter { $0.index == index }.first
        }
    }
}


// !!!: “最长公共子序列” Diff 算法
// 计算 `ReloadableSection` 的两个给定数组的差异
class DiffCalculator {
    static func calculator<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
        let sectionChanges = SectionChanges()
        let cellChanges = CellChanges()

        // 合并新旧数组，提取出所有的 sectionKeys 并删除重复部分（不变的部分）
        let uniqueSectionKeys = (oldSectionItems + newSectionItems).map { $0.key }.filterDuplicates()
        // 循环遍历该数组，目的是找出哪些 itme 是要删除、更新、移除的
        for sectionKey in uniqueSectionKeys {
            // 通过下标语法，找到 sectionKey 所对应的 items
            let oldSectionItem = ReloadableSectionData(items: oldSectionItems)[sectionKey]
            let newSectionItem = ReloadableSectionData(items: newSectionItems)[sectionKey]

            if let oldSectionItem = oldSectionItem, let newSectionItem = newSectionItem {
                // MARK: 场景一，新旧数据中都具有所给 key 的 item，带有这个 key 的 item 被更新了。

                // 如果新旧 sectionItem 不一样，则进入该 section 并找到 cell 之间的差异
                if oldSectionItem != newSectionItem {
                    // 与 Section 方式相同，提取出所有的 cellKeys 并删除重复部分（不变的部分）
                    let oldCellData = oldSectionItem.value
                    let newCellData = newSectionItem.value
                    let uniqueCellKeys = (oldCellData + newCellData).map { $0.key }.filterDuplicates()
                    // 循环遍历 uniqueCellKeys，找到每个 key 所对应的 cell：
                    for cellKey in uniqueCellKeys {
                        // 通过下标语法，找到 cellKey 所对应的 items
                        let oldCellItem = ReloadableCellData(items: oldCellData)[cellKey]
                        let newCellItem = ReloadableCellData(items: newCellData)[cellKey]

                        if let oldCellItem = oldCellItem, let newCellItem = newCellItem {
                            if oldCellItem != newCellItem {
                                // 更新 cell
                                cellChanges.reloads.append(IndexPath(row: oldCellItem.index, section: oldSectionItem.index))
                            }
                        } else if let oldCellItem = oldCellItem {
                            // 删除 cell
                            cellChanges.deletes.append(IndexPath(row: oldCellItem.index, section: oldSectionItem.index))
                        } else if let newCellItem = newCellItem {
                            // 插入 cell
                            cellChanges.inserts.append(IndexPath(row: newCellItem.index, section: newSectionItem.index))
                        }
                    }
                }
            } else if let oldSectionItem = oldSectionItem {
                // MARK: 场景二，section 被从数据中删除。
                sectionChanges.deletesInts.append(oldSectionItem.index)
            } else if let newSectionItem = newSectionItem {
                // MARK: 场景三，section 新增
                sectionChanges.insertsInts.append(newSectionItem.index)
            }
        }

        sectionChanges.updates = cellChanges
        return sectionChanges
    }
}





