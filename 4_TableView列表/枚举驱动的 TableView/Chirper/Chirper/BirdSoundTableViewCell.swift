/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import AVKit

class BirdSoundTableViewCell: UITableViewCell {
  
  static let ReuseIdentifier = String(describing: BirdSoundTableViewCell.self)
  static let NibName = String(describing: BirdSoundTableViewCell.self)
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var playbackButton: UIButton!
  @IBOutlet weak var scientificNameLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var audioPlayerContainer: UIView!
  
  var playbackURL: URL?
  var player = AVPlayer()
  
  var isPlaying = false {
    didSet {
      let newImage = isPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
      playbackButton.setImage(newImage, for: .normal)
      if isPlaying, let url = playbackURL {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
      } else {
        player.pause()
      }
    }
  }
  
  override func prepareForReuse() {
    NotificationCenter.default.removeObserver(self)
    isPlaying = false
    super.prepareForReuse()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  
  @IBAction func togglePlayback(_ sender: Any) {
    isPlaying = !isPlaying
  }
  
  func load(recording: Recording) {
    nameLabel.text = recording.friendlyName
    scientificNameLabel.text = "\(recording.genus) \(recording.species)"
    countryLabel.text = recording.country
    dateLabel.text = recording.date
    
//    let playableRecordingURLString = "https:\(recording.fileURL.absoluteString)"
//    playbackURL = URL(string: playableRecordingURLString)
    playbackURL = recording.fileURL
    
    NotificationCenter.default.addObserver(
      self, selector: #selector(playerDidFinishPlaying(_:)),
      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
      object: player.currentItem)
    
    NotificationCenter.default.addObserver(
      self, selector: #selector(itemDidReachEnd(_:)),
      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
      object: player.currentItem)
  }
  
  @objc func playerDidFinishPlaying(_: NSNotification) {
    isPlaying = false
  }
  
  @objc func itemDidReachEnd(_: NSNotification) {
    player.seek(to: kCMTimeZero)
  }
  
  func ensurePlaybackWorksForDeviceOnSilent() {
    let audioSession = AVAudioSession.sharedInstance()
    try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: [])
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}

