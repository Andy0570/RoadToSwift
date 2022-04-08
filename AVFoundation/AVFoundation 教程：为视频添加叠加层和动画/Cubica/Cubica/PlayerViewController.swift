/// Copyright (c) 2019 Razeware LLC
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
import Photos

class PlayerViewController: UIViewController {
  var videoURL: URL!
  
  private var player: AVPlayer!
  private var playerLayer: AVPlayerLayer!
  
  @IBOutlet weak var videoView: UIView!
  
  @IBAction func saveVideoButtonTapped(_ sender: Any) {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        self?.saveVideoToPhotos()
      default:
        print("Photos permissions not granted.")
        return
      }
    }
  }
  
  private func saveVideoToPhotos() {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
    }) { [weak self] (isSaved, error) in
      if isSaved {
        print("Video saved.")
      } else {
        print("Cannot save video.")
        print(error ?? "unknown error")
      }
      DispatchQueue.main.async {
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    player = AVPlayer(url: videoURL)
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = videoView.bounds
    videoView.layer.addSublayer(playerLayer)
    player.play()
    
    NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: nil) { [weak self] _ in self?.restart() }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    playerLayer.frame = videoView.bounds
  }
  
  private func restart() {
    player.seek(to: .zero)
    player.play()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: .AVPlayerItemDidPlayToEndTime,
      object: nil)
  }
}
