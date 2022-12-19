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
import SafariServices
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().barTintColor = .themeGreenColor
    UINavigationBar.appearance().tintColor = .white
    UITabBar.appearance().barTintColor = .themeGreenColor
    UITabBar.appearance().tintColor = .white
    
    registerForPushNotifications()
    
    return true
  }
  
    // 向 APNs 注册成功时调用，返回设备标识符
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("Device Token: \(token)")
  }
  
  // 向 APNs 注册失败时调用
  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register: \(error)")
  }
  
    // 当应用收到推送通知时，处理收到的推送通知内容
    // 默认情况下，如果应用收到推送通知时处于前台状态，则会丢弃通知内容
    // 这里可以截获推送内容，并更新应用页面
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler:
    @escaping (UIBackgroundFetchResult) -> Void
  ) {
    guard let aps = userInfo["aps"] as? [String: AnyObject] else {
      completionHandler(.failed)
      return
    }
    
    print("\(userInfo)")
    
    // 1. 检查 `content-available` 值是否为 1，如果是，这是一个静默通知标志。
    if aps["content-available"] as? Int == 1 {
      let podcastStore = PodcastStore.sharedStore
      podcastStore.refreshItems { didLoadNewItems in
        completionHandler(didLoadNewItems ? .newData : .noData)
      }
    }
  }
  
  func registerForPushNotifications() {
    // 1. 注册推送通知，向用户请求通知权限
    UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
        guard let self = self else { return }
        print("Permission granted: \(granted)")
        
        guard granted else { return }
        
        // 注册推送通知成功后，在其中添加 Action 动作
        // 1 创建一个新的通知动作，标题为 "View" 按钮，当被触发时就会在前台打开应用程序。
        // 该动作有一个唯一标识符，iOS 用它来区分同一个通知上的其他动作。
        let viewAction = UNNotificationAction(
          identifier: Identifiers.viewAction, title: "View",
          options: [.foreground])
        
        // 2 定义新闻类别，它将包含动作按钮。这也有一个独特的标识符，您的有效载荷将需要包含该标识符，以指定推送通知属于该类别。
        let newsCategory = UNNotificationCategory(
            identifier: Identifiers.newsCategory,
            actions: [viewAction],
            intentIdentifiers: [], options: [])
        
        // 3 通过调用 setNotificationCategories 来注册新的可操作通知。
        UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
        
        self.getNotificationSettings()
    }
  }
  
  // 获取通知设置
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      print("Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
  
  
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}
