//
//  TracksTableViewCell.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import UIKit

class TracksTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackArtist: UILabel!

    public var cellTrack: Track! {
        didSet {
            self.trackImage.clipsToBounds = true
            self.trackImage.layer.cornerRadius = 3
            self.trackImage.loadImage(fromURL: cellTrack.trackArtWork)
            self.trackTitle.text = cellTrack.name
            self.trackArtist.text = cellTrack.artist
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func prepareForReuse() {
        trackImage.image = UIImage()
    }
}
