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

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            
            /// 更新 Title
            // 1. 检查通知内容中 userInfo 中 podcast-guest 这个键的值
            if let author = bestAttemptContent.userInfo["podcast-guest"] as? String {
                // 2. 如果它存在，更新通知内容的标题
                bestAttemptContent.title = "New Podcast: \(author)"
            }
            
            // 3. 调用完成处理程序来传递推送。如果 podcast-author 的值不存在，推送就会显示原始标题。
            
            /// 添加图片
            // 1. 检查是否有 podcast-image 的值。如果没有，调用内容处理程序来传递推送并返回。
            guard let imageURLString =
              bestAttemptContent.userInfo["podcast-image"] as? String else {
              contentHandler(bestAttemptContent)
              return
            }

            // 2. 调用便捷方法，用从推送 payload 中接收到的 URL 来检索图片。
            getMediaAttachment(for: imageURLString) { [weak self] image in
              // 3. 当完成块执行时，检查图像是否为 nil；否则，尝试将其保存到磁盘。
              guard
                let self = self,
                let image = image,
                let fileURL = self.saveImageAttachment(
                  image: image,
                  forIdentifier: "attachment.png")
                // 4. 如果存在一个 URL，则说明操作成功；如果这些检查中的任何一项失败，则调用内容处理程序并返回。
                else {
                  contentHandler(bestAttemptContent)
                  return
              }

              // 5. 用文件 URL 创建一个 UNNotificationAttachment。命名标识符图像，将其设置为最终通知上的图像。
              let imageAttachment = try? UNNotificationAttachment(
                identifier: "image",
                url: fileURL,
                options: nil)

              // 6. 如果创建附件成功，将其添加到 bestAttemptContent 的 attachments 属性中。
              if let imageAttachment = imageAttachment {
                bestAttemptContent.attachments = [imageAttachment]
              }

              // 7. 调用内容处理程序来传递推送通知。
              contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    // 便捷方法：保存图片到磁盘
     private func saveImageAttachment(
       image: UIImage,
       forIdentifier identifier: String
     ) -> URL? {
       // 1. 获取临时文件目录
       let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
       // 2. 在临时文件目录下，使用唯一字符串创建一个目录 URL
       let directoryPath = tempDirectory.appendingPathComponent(
         ProcessInfo.processInfo.globallyUniqueString,
         isDirectory: true)

       do {
         // 3. 创建一个空目录
         try FileManager.default.createDirectory(
           at: directoryPath,
           withIntermediateDirectories: true,
           attributes: nil)

         // 4. 根据图片标识符创建一个文件 URL
         let fileURL = directoryPath.appendingPathComponent(identifier)

         // 5. 将图片转换为 Data 对象
         guard let imageData = image.pngData() else {
           return nil
         }

         // 6. 尝试将文件写入磁盘
         try imageData.write(to: fileURL)
           return fileURL
         } catch {
           return nil
       }
     }
     
     // 便捷方法：通过 URL 下载图片
     private func getMediaAttachment(
       for urlString: String,
       completion: @escaping (UIImage?) -> Void
     ) {
       // 1. 确保你能从 urlString 属性中创建 URL
       guard let url = URL(string: urlString) else {
         completion(nil)
         return
       }

       // 2. 使用链接到这个 Target 的 ImageDownloader 尝试下载
       ImageDownloader.shared.downloadImage(forURL: url) { result in
         // 3. 确保生成的图像不是 nil
         guard let image = try? result.get() else {
           completion(nil)
           return
         }

         // 4. 执行完成 Block 块，传递 UIImage 结果
         completion(image)
       }
     }

}
