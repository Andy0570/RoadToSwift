//
//  Item.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/16.
//

import Foundation

struct Section: Codable {
    let title: String
    let cells: [Cell]
}

struct Cell: Codable, TableViewCellConfigureDelegate {
    let image: String
    let title: String
    let description: String
    let className: String
}
