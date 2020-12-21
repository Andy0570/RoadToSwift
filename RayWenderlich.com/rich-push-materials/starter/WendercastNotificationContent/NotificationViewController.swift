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

/// NotificationViewController 负责为你的用户呈现自定义的通知视图
class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var podcastBodyLabel: UILabel!
    
    var podcast: Podcast?
        
    func didReceive(_ notification: UNNotification) {
        // 1. 调用便捷方法从 Core Data 存储中加载 podcast. 这样就可以设置 podcast，以便以后使用。
        loadPodcast(from: notification)

        // 2. 将标题和正文标签设置为从推送通知中接收到的值。
        let content = notification.request.content
        podcastTitleLabel.text = content.subtitle
        podcastBodyLabel.text = content.body

        // 3. 尝试访问附加到服务扩展的媒体。如果没有，则提前返回。
        // 调用 startAccessingSecurityScopedResource() 允许你访问附件。
        guard
          let attachment = content.attachments.first,
          attachment.url.startAccessingSecurityScopedResource()
          else {
            return
        }

        // 4. 获取附件的URL。试图从磁盘中检索它，并将数据转换为图像。如果失败，提前返回。
        let fileURLString = attachment.url

        guard
          let imageData = try? Data(contentsOf: fileURLString),
          let image = UIImage(data: imageData)
          else {
            attachment.url.stopAccessingSecurityScopedResource()
            return
        }

        // 5. 如果图像检索成功，设置播客图像并停止访问资源。
        imageView.image = image
        attachment.url.stopAccessingSecurityScopedResource()

    }
    
    // 从共享数据存储中加载播客
    private func loadPodcast(from notification: UNNotification) {
      // 1. 试着从通知所附带的 userInfo 对象中获取播客的链接。播客链接是播客在 Core Data 中存储的唯一标识符。
      let link = notification.request.content.userInfo["podcast-link"] as? String

      // 2. 如果链接不存在，则提前返回。
      guard let podcastLink = link else {
        return
      }

      // 3. 使用链接从 Core Data 存储中获取 Podcast 模型对象。
      let podcast = CoreDataManager.shared.fetchPodcast(
        byLinkIdentifier: podcastLink)

      // 4. 设置 podcast 作为响应。
      self.podcast = podcast
    }
    
    // MARK: - Favorite 收藏按钮点击事件
    @IBAction func favoriteButtonTapped(_ sender: Any) {
      // 1. 检查是否有播客已被设置。
      guard let podcast = podcast else {
        return
      }

      // 2. 在 podcast 上检查 isFavorite。
      let favoriteSetting = podcast.isFavorite ? false : true
      podcast.isFavorite = favoriteSetting

      // 3. 更新 favorite 按钮 UI 以匹配模型状态。
      let symbolName = favoriteSetting ? "star.fill" : "star"
      let image = UIImage(systemName: symbolName)
      favoriteButton.setBackgroundImage(image, for: .normal)

      // 4. 更新 Core Data 存储。
      CoreDataManager.shared.saveContext()
    }

    // MARK: - play 播放按钮点击事件
    @IBAction func playButtonTapped(_ sender: Any) {
      extensionContext?.performNotificationDefaultAction()
    }
}
