//
//  UITableView+EmptyState.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    
    func setEmptyState(message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.textAlignment = .center
        label.text = message
        label.style(.body)

        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }
    
    func removeEmptyState() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension Reactive where Base: UITableView {
    
    func isEmpty(message: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setEmptyState(message: message)
            } else {
                tableView.removeEmptyState()
            }
        }
    }
}
