//
//  UITableView+Cells.swift
//  ReactiveCells
//
//  Created by Greg Price on 15/03/2021.
//

import UIKit

extension UITableView {
    
    func registerCell(identifier: String) {
        registerCells(identifiers: [identifier])
    }
    
    func registerCells(identifiers : [String]) {
        for identifier in identifiers {
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else { fatalError() }
        return cell
    }
}
