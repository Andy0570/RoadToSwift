//
//  IconCollectionViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/22.
//

import UIKit

final class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconPriceLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }
}
