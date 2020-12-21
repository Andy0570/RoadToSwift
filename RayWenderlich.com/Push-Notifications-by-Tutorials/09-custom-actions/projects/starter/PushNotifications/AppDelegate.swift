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
import UserNotifications

private let categoryIdentifier = "AcceptOrReject"

// 枚举类型，用于识别通知的 Accept 或 Reject 按钮
private enum ActionIdentifier: String {
  case accept, reject
}

@UIApplicationMain
class AppDelegate: UIResponder {
  var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    registerForPushNotifications(application: application)

    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    sendPushNotificationDetails(to: "http://192.168.1.1:8080/api/token", using: deviceToken)
    registerCustomActions()
  }
  
  private func registerCustomActions() {
    let accept = UNNotificationAction(identifier: ActionIdentifier.accept.rawValue, title: "Accept", options: .authenticationRequired)
    let reject = UNNotificationAction(identifier: ActionIdentifier.reject.rawValue, title: "Reject", options: .authenticationRequired)
    let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [accept, reject], intentIdentifiers: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
  }

}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound, .badge])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    defer { completionHandler() }
    
    // 获取点击的推送通知 Action 按钮
    let identity = response.notification.request.content.categoryIdentifier
    guard identity == categoryIdentifier,
          let action = ActionIdentifier(rawValue: response.actionIdentifier) else {
      return
    }
    
    print("You press \(response.actionIdentifier)")
    
    // 获取 payload 中的 userInfo 字段值，并注册到 Foundation 通知中
    let userInfo = response.notification.request.content.userInfo
    
    switch action {
    case .accept:
      Notification.Name.acceptButton.post(userInfo: userInfo)
    case .reject:
      Notification.Name.rejectButton.post(userInfo: userInfo)
    }
    
  }
}
