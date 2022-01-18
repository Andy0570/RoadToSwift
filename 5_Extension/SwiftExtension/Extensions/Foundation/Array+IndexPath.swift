//
//  Array+IndexPath.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

// cell.item = items[indexPath]
extension Array {
    subscript(indexPath: IndexPath) -> Element {
        self[indexPath.row]
    }
}
