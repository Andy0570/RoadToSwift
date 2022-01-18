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
import AVKit

class PodcastItemViewController: UIViewController {
  let artworkURLString = "https://koenig-media.raywenderlich.com/uploads/2019/04/Podcast-icon-2019-1400x1400.png"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var playerContainerView: UIView!
  @IBOutlet weak var podcastDetailTextView: UITextView!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var playerViewController: AVPlayerViewController!
  var podcastItem: PodcastItem
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
  
  required init?(coder: NSCoder, podcastItem: PodcastItem) {
    self.podcastItem = podcastItem
    super.init(coder: coder)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupNotificationObservers()
    refreshData()
    
    titleLabel.text = podcastItem.title
    let htmlStringData = podcastItem.detail.data(using: .utf8)!
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
    ]
    
    if let attributedHTMLString = try? NSMutableAttributedString(
      data: htmlStringData,
      options: options,
      documentAttributes: nil) {
      podcastDetailTextView.attributedText = attributedHTMLString
    }
    
    updateFavoriteUI()
    
    guard let url = URL(string: artworkURLString) else {
      fatalError("Invalid URL")
    }
    
    downloadImage(for: url)
    
    let player = AVPlayer(url: podcastItem.streamingURL)
    playerViewController.player = player
    playerViewController.player?.play()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    playerViewController.player?.pause()
    super.viewWillDisappear(animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "playerEmbed",
      let playerVC = segue.destination as? AVPlayerViewController {
      playerViewController = playerVC
    }
  }
  
  @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    let favoriteSetting = podcastItem.isFavorite ? false : true
    CoreDataManager.shared.updatePodcaseFavoriteSetting(podcastItem.link, isFavorite: favoriteSetting)
    podcastItem.isFavorite = favoriteSetting
    
    updateFavoriteUI()
  }
  
  private func downloadImage(for url: URL) {
    ImageDownloader.shared.downloadImage(forURL: url) { [weak self] result in
      guard
        let self = self,
        let image = try? result.get()
        else {
          return
      }
      
      DispatchQueue.main.async {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        guard let contentOverlayView = self.playerViewController.contentOverlayView else {
          return
        }
        
        contentOverlayView.addSubview(imageView)
        imageView.frame = contentOverlayView.bounds
      }
    }
  }
  
  private func setupNotificationObservers() {
    NotificationCenter.default.addObserver(
      forName: Notification.Name.appEnteringForeground,
      object: nil,
      queue: nil
    ) { _ in
      self.refreshData()
      self.updateFavoriteUI()
    }
  }
  
  private func updateFavoriteUI() {
    let symbolString = podcastItem.isFavorite ? "star.fill" : "star"
    favoriteButton.setImage(UIImage(systemName: symbolString), for: .normal)
  }
  
  private func refreshData() {
    let refreshedItem = PodcastStore.sharedStore.reloadData(for: podcastItem)
    self.podcastItem = refreshedItem
  }
}
