//
//  AttributeCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import UIKit

class AttributeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var item: Attribute? {
        didSet {
            titleLabel.text = item?.key
            titleLabel.text = item?.value
        }
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
