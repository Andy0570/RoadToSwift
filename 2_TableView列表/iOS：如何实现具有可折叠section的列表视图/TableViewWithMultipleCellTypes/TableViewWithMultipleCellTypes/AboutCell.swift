//
//  AboutCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import UIKit

class AboutCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel!

    var item: ProfileViewModelItem? {
        didSet {
            guard let item = item as? ProfileViewModelAboutItem else {
                return
            }

            aboutLabel.text = item.about
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
