//
//  Array+Extensions.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/12.
//

import Foundation

extension Array where Element: Hashable {

    /// Remove duplicates from the array, preserving the items order
    func filterDuplicates() -> Array<Element> {
        var set = Set<Element>()
        var filteredArray = Array<Element>()
        for item in self {
            if set.insert(item).inserted {
                filteredArray.append(item)
            }
        }
        return filteredArray
    }
}
