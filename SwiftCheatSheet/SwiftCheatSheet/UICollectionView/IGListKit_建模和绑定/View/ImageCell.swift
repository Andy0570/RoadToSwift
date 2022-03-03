//
//  ImageCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit
import Kingfisher

final class ImageCell: UICollectionViewCell, ListBindable {

    @IBOutlet weak var imageView: UIImageView!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    // MARK: ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ImageViewModel else {
            return
        }

        // 通过 Kingfisher 下载图像
        // 缩小图片以适应 imageView 尺寸
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.indicatorType = .activity // 加载活动指示器
        imageView.kf.setImage(with: viewModel.url,
                              placeholder: nil,
                              options: [.processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)), // fade in 淡入加载效果
                                        .cacheOriginalImage // 缓存原始图像
                                       ],
                              completionHandler: nil);

    }
}
