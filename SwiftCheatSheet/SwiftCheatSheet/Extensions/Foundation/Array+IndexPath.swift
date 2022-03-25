//
//  Array+IndexPath.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import Foundation

// cell.item = items[indexPath]
extension Array {
    subscript(indexPath: IndexPath) -> Element {
        self[indexPath.row]
    }
}
