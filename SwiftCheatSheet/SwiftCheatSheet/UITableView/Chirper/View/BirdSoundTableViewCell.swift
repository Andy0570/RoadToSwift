//
//  BirdSoundTableViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import UIKit
import AVKit

class BirdSoundTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var audioPlayerContainer: UIView!
    @IBOutlet weak var playbackButton: UIButton!

    var playerbackURL: URL?
    var player = AVPlayer()

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    var isPlaying = false {
        didSet {
            let newImage = isPlaying ? UIImage(named: "pause") : UIImage(named: "play")
            playbackButton.setImage(newImage, for: .normal)
            if isPlaying, let url = playerbackURL {
                player.replaceCurrentItem(with: AVPlayerItem(url: url))
                player.play()
            } else {
                player.pause()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        NotificationCenter.default.removeObserver(self)
        isPlaying = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    @IBAction func togglePlayback(_ sender: Any) {
        isPlaying.toggle()
    }

    func configure(recording: Recording) {
        nameLabel.text = recording.friendlyName
        scientificNameLabel.text = "\(recording.genus) \(recording.species)"
        countryLabel.text = recording.country
        dateLabel.text = recording.date

        playerbackURL = recording.fileURL

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    @objc func playerDidFinishPlaying(_: NSNotification) {
        isPlaying = false
        player.seek(to: .zero)
    }

    func ensurePlaybackWorksForDeviceOnSilent() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback, options: [])
    }
}
