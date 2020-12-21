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
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var podcastTitleLabel: UILabel!
  @IBOutlet weak var podcastBodyLabel: UILabel!
  
  var podcast: Podcast?
  
  func didReceive(_ notification: UNNotification) {
    // 1
    loadPodcast(from: notification)
    
    // 2
    let content = notification.request.content
    podcastTitleLabel.text = content.subtitle
    podcastBodyLabel.text = content.body
    
    // 3
    guard
      let attachment = content.attachments.first,
      attachment.url.startAccessingSecurityScopedResource()
      else {
        return
    }
    
    // 4
    let fileURLString = attachment.url
    
    guard
      let imageData = try? Data(contentsOf: fileURLString),
      let image = UIImage(data: imageData)
      else {
        attachment.url.stopAccessingSecurityScopedResource()
        return
    }
    
    // 5
    imageView.image = image
    attachment.url.stopAccessingSecurityScopedResource()
  }
  
  @IBAction func favoriteButtonTapped(_ sender: Any) {
    // 1
    guard let podcast = podcast else {
      return
    }
    
    // 2
    let favoriteSetting = podcast.isFavorite ? false : true
    podcast.isFavorite = favoriteSetting
    
    // 3
    let symbolName = favoriteSetting ? "star.fill" : "star"
    let image = UIImage(systemName: symbolName)
    favoriteButton.setBackgroundImage(image, for: .normal)
    
    // 4
    CoreDataManager.shared.saveContext()
  }
  
  @IBAction func playButtonTapped(_ sender: Any) {
    extensionContext?.performNotificationDefaultAction()
  }
  
  private func loadPodcast(from notification: UNNotification) {
    // 1
    let link = notification.request.content.userInfo["podcast-link"] as? String
    
    // 2
    guard let podcastLink = link else {
      return
    }
    
    // 3
    let podcast = CoreDataManager.shared.fetchPodcast(byLinkIdentifier: podcastLink)
    
    // 4
    self.podcast = podcast
  }
}
