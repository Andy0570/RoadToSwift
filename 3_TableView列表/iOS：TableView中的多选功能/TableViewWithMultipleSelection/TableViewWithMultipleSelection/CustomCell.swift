//
//  CustomCell.swift
//  TableViewWithMultipleSelection
//
//  Created by Qilin Hu on 2022/1/24.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    var item: ViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }

            titleLabel.text = item.title
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // update UI
        accessoryType = selected ? .checkmark : .none
    }
    
}
