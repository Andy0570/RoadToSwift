//
//  PhotoCell.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/17.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    var representedAssetIdentifier: String!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let bounds = contentView.bounds
        imageView.frame = bounds
    }

    func flash() {
        imageView.alpha = 0
        setNeedsDisplay()
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.imageView.alpha = 1.0
        })
    }
}
