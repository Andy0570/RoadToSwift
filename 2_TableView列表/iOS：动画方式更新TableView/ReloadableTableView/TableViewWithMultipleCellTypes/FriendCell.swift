//
//  FriendCell.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var item: Friend? {
        didSet {
            guard let item = item else {
                return
            }

            if !item.pictureUrl.isEmpty {
                pictureImageView.image = UIImage(named: item.pictureUrl)
            }
            nameLabel.text = item.name
        }
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        pictureImageView.layer.cornerRadius = 40
        pictureImageView.layer.masksToBounds = true
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.backgroundColor = UIColor.lightGray
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        pictureImageView.image = nil
    }
    
}
