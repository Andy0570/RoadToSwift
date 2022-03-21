//
//  ModeratorTableViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import UIKit

class ModeratorTableViewCell: UITableViewCell {
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var reputationLabel: UILabel!
    @IBOutlet var reputationContainerView: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        reputationContainerView.backgroundColor = .lightGray
        reputationContainerView.layer.cornerRadius = 6

        indicatorView.hidesWhenStopped = true
        indicatorView.color = ColorPalette.RWGreen
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        configure(with: .none)
    }

    func configure(with moderator: Moderator?) {
        if let moderator = moderator {
            displayNameLabel.text = moderator.displayName
            reputationLabel.text = moderator.reputation
            displayNameLabel.alpha = 1
            reputationLabel.alpha = 1
            indicatorView.stopAnimating()
        } else {
            displayNameLabel.alpha = 0
            reputationLabel.alpha = 0
            indicatorView.startAnimating()
        }
    }
}
