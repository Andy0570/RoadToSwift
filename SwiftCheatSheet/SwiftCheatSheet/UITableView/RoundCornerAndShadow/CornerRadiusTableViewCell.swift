//
//  CornerRadiusTableViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/8.
//

import UIKit

class CornerRadiusTableViewCell: BaseTableViewCell {
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // MARK: 在自定义容器视图层上设置圆角
        backgroundColor = .clear
        self.containerView.backgroundColor = .systemBackground
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.masksToBounds = true
    }
}
