//
//  AuteurTableViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

import UIKit

class AuteurTableViewCell: UITableViewCell {

    @IBOutlet weak var auteurImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    // 使用 Interface Builder 构建 cell 时，在这里进行自定义
    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.textColor = .systemGray2
        bioLabel.textColor = .systemGray3
        sourceLabel.textColor = .systemGray3

        sourceLabel.font = UIFont.italicSystemFont(ofSize: sourceLabel.font.pointSize)
        nameLabel.textAlignment = .center

        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        auteurImageView.image = nil
    }

    func configure(name: String, bio: String, sourceText: String, imageName: String) -> AuteurTableViewCell {
        nameLabel.text = name
        bioLabel.text = bio
        sourceLabel.text = sourceText
        auteurImageView.image = UIImage(named: imageName)
        return self
    }
}
