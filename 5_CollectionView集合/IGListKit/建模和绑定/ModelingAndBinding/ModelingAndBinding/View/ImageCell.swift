//
//  ImageCell.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/11.
//

import IGListKit
import SDWebImage

final class ImageCell: UICollectionViewCell, ListBindable {
    
    @IBOutlet weak var imageView: UIImageView!

    // MARK: ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ImageViewModel else {
            return
        }
        imageView.sd_setImage(with: viewModel.url, completed: nil)
    }
    
}
