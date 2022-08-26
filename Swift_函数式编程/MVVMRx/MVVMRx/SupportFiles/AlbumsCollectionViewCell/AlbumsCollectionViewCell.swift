//
//  AlbumsCollectionViewCell.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import UIKit

class AlbumsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!

    var withBackView: Bool! {
        didSet {
            self.backViewGenrator()
        }
    }

    private lazy var backView: UIImageView = {
        let backView = UIImageView(frame: albumImage.frame)
        backView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: albumImage.topAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: albumImage.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: albumImage.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: albumImage.bottomAnchor)
        ])
        backView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        backView.alpha = 0.5
        contentView.bringSubviewToFront(albumImage)
        return backView
    }()

    public var album: Album! {
        didSet {
            self.albumImage.loadImage(fromURL: album.albumArtWork)
            self.albumArtist.text = ""
            self.albumTitle.text = album.name
        }
    }

    private func backViewGenrator() {
        backView.loadImage(fromURL: album.albumArtWork)
    }

    override func prepareForReuse() {
        albumImage.image = UIImage()
        backView.image = UIImage()
    }
}
