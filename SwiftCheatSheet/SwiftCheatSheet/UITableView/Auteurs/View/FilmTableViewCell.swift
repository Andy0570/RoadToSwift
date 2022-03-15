//
//  FilmTableViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

import UIKit

class FilmTableViewCell: UITableViewCell {

    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var filmTitleLabel: UILabel!

    // !!!: nib 配置中需要取消勾选 Scrolling Enable 属性
    @IBOutlet weak var moreInfoTextView: UITextView!

    static let moreInfoText = "Tap For Details >"

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    func configure(title: String, plot: String, isExpanded: Bool, poster: String) {
        filmTitleLabel.text = title
        filmTitleLabel.textColor = .systemGray2
        filmTitleLabel.textAlignment = .center
        filmImageView.image = UIImage(named: poster)

        // 根据 Cell 折叠状态，动态配置文本内容
        moreInfoTextView.text = isExpanded ? plot : Self.moreInfoText
        moreInfoTextView.textAlignment = isExpanded ? .left : .center
        moreInfoTextView.textColor = isExpanded ? .systemGray3 : .systemRed

        selectionStyle = .none
    }
}
