//
//  EmailCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import UIKit

class EmailCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!

    var item: ProfileViewModelItem? {
        didSet {
            guard let item = item as? ProfileViewModelEmailItem else {
                return
            }

            emailLabel.text = item.email
        }
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
