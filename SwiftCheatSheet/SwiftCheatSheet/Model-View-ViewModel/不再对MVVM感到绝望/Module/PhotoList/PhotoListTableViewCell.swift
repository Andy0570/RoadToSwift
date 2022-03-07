//
//  PhotoListTableViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

import UIKit
import Kingfisher

class PhotoListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        mainImageView.image = nil
    }

    var photoListCellViewModel: PhotoListCellViewModel? {
        didSet {
            nameLabel.text = photoListCellViewModel?.titleText
            descriptionLabel.text = photoListCellViewModel?.descText
            dateLabel.text = photoListCellViewModel?.dateText

            if let imageUrl = photoListCellViewModel?.imageUrl {
                // 通过 Kingfisher 下载图像
                // 缩小图片以适应 imageView 尺寸
                let processor = DownsamplingImageProcessor(size: mainImageView.bounds.size)
                mainImageView.kf.indicatorType = .activity // 加载活动指示器
                mainImageView.kf.setImage(with: URL(string: imageUrl),
                                          placeholder: nil,
                                          options: [
                                            .processor(processor),
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)), // fade in 淡入加载效果
                                            .cacheOriginalImage // 缓存原始图像
                                          ],
                                          completionHandler: nil)

            }

        }
    }

}
