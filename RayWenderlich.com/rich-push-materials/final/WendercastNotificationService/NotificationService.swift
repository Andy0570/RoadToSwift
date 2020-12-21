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
      if let author = bestAttemptContent.userInfo["podcast-guest"] as? String {
        bestAttemptContent.title = "New Podcast: \(author)"
      }
      
      // 1
      guard let imageURLString =
        bestAttemptContent.userInfo["podcast-image"] as? String else {
          contentHandler(bestAttemptContent)
          return
      }
      
      // 2
      getMediaAttachment(for: imageURLString) { [weak self] image in
        // 3
        guard
          let self = self,
          let image = image,
          let fileURL = self.saveImageAttachment(
            image: image,
            forIdentifier: "attachment.png")
          else {
            contentHandler(bestAttemptContent)
            return
        }
        
        // 4
        let imageAttachment = try? UNNotificationAttachment(
          identifier: "image",
          url: fileURL,
          options: nil)
        
        // 5
        if let imageAttachment = imageAttachment {
          bestAttemptContent.attachments = [imageAttachment]
        }
        
        // 6
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
  
  private func saveImageAttachment(
    image: UIImage,
    forIdentifier identifier: String
  ) -> URL? {
    // 1
    let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
    // 2
    let directoryPath = tempDirectory.appendingPathComponent(
      ProcessInfo.processInfo.globallyUniqueString,
      isDirectory: true)
    
    do {
      // 3
      try FileManager.default.createDirectory(
        at: directoryPath,
        withIntermediateDirectories: true,
        attributes: nil)
      
      // 4
      let fileURL = directoryPath.appendingPathComponent(identifier)
      
      // 5
      guard let imageData = image.pngData() else {
        return nil
      }
      
      // 6
      try imageData.write(to: fileURL)
      return fileURL
    } catch {
      return nil
    }
  }
  
  private func getMediaAttachment(
    for urlString: String,
    completion: @escaping (UIImage?) -> Void
  ) {
    // 1
    guard let url = URL(string: urlString) else {
      completion(nil)
      return
    }
    
    // 2
    ImageDownloader.shared.downloadImage(forURL: url) { result in
      // 3
      guard let image = try? result.get() else {
        completion(nil)
        return
      }
      
      // 4
      completion(image)
    }
  }
}
