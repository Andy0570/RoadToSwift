/// Copyright (c) 2020 Razeware LLC
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
import AVFoundation

class AVPlayerLayerViewController: UIViewController {
  @IBOutlet weak var viewForPlayerLayer: UIView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
  @IBOutlet weak var loopSwitch: UISwitch!
  @IBOutlet weak var volumeSlider: UISlider!

  enum Rate: Int {
    case slowForward, normal, fastForward
  }

  let playerLayer = AVPlayerLayer()
  var player: AVPlayer? {
    return playerLayer.player
  }
  var rate: Float {
    switch rateSegmentedControl.selectedSegmentIndex {
    case 0:
      return 0.5
    case 2:
      return 2.0
    default:
      return 1.0
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    rateSegmentedControl.selectedSegmentIndex = 1
    setUpPlayerLayer()
    viewForPlayerLayer.layer.addSublayer(playerLayer)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AVPlayerLayerViewController.playerDidReachEndNotificationHandler(_:)),
      name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"),
      object: player?.currentItem)
    playButton.setTitle("Pause", for: .normal)
  }
}

// MARK: - Layer setup
extension AVPlayerLayerViewController {
  func setUpPlayerLayer() {
    playerLayer.frame = viewForPlayerLayer.bounds

    let url = Bundle.main.url(forResource: "colorfulStreak", withExtension: "m4v")!
    let item = AVPlayerItem(asset: AVAsset(url: url))
    let player = AVPlayer(playerItem: item)
    player.actionAtItemEnd = .none // 播放结束时的行为
    player.volume = 1.0
    player.rate = 1.0

    playerLayer.player = player
  }
}

// MARK: - IBActions
extension AVPlayerLayerViewController {
  @IBAction func playButtonTapped(_ sender: UIButton) {
    if player?.rate == 0 {
      player?.rate = rate
      updatePlayButtonTitle(isPlaying: true)
    } else {
      player?.pause()
      updatePlayButtonTitle(isPlaying: false)
    }
  }

  @IBAction func rateSegmentedControlChanged(_ sender: UISegmentedControl) {
    player?.rate = rate
    updatePlayButtonTitle(isPlaying: true)
  }

  @IBAction func loopSwitchChanged(_ sender: UISwitch) {
    if sender.isOn {
      player?.actionAtItemEnd = .none
    } else {
      player?.actionAtItemEnd = .pause
    }
  }

  @IBAction func volumeSliderChanged(_ sender: UISlider) {
    player?.volume = sender.value
  }
}

// MARK: - Triggered actions
extension AVPlayerLayerViewController {
  @objc func playerDidReachEndNotificationHandler(_ notification: Notification) {
    // 验证通知的对象是 AVPlayerItem
    guard let playerItem = notification.object as? AVPlayerItem else {
      return
    }

    // 将播放器设置到初始位置
    playerItem.seek(to: .zero, completionHandler: nil)

    if player?.actionAtItemEnd == .pause {
      player?.pause()
      updatePlayButtonTitle(isPlaying: false)
    }
  }
}

// MARK: - Helpers
extension AVPlayerLayerViewController {
  func updatePlayButtonTitle(isPlaying: Bool) {
    if isPlaying {
      playButton.setTitle("Pause", for: .normal)
    } else {
      playButton.setTitle("Play", for: .normal)
    }
  }
}
