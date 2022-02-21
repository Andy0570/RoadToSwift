//
//  UITableViewCellExtensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/17.
//

import Foundation

import UIKit

protocol TableViewCellConfigureDelegate: Any {
    var image: String { get }
    var title: String { get }
    var description: String { get }
}

extension UITableViewCell {

    func configureForCell(cell: TableViewCellConfigureDelegate) {
        self.imageView?.image = UIImage(named: cell.image)
        self.textLabel?.text = cell.title
        self.detailTextLabel?.text = cell.description
        self.accessoryType = .disclosureIndicator
    }
}
