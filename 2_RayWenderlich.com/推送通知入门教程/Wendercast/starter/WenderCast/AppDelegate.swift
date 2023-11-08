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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SafariServices
import UIKit
import UserNotifications

// 在注册通知时，使用 categories 来定义可操作通知
enum Identifiers {
    static let newsCategory = "NEWS_CATEGORY" // 自定义类别
    static let viewAction = "VIEW_IDENTIFIER" // 自定义名为“查看”的操作
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // 1.当收到推送通知时，如果应用没有运行，用户点击推送通知，会调用该方法
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UITabBar.appearance().barTintColor = UIColor.themeGreenColor
        UITabBar.appearance().tintColor = UIColor.white

        // 设置 UNUserNotificationCenter 的委托者，以执行自定义 Action
        UNUserNotificationCenter.current().delegate = self;
        
        // 注册推送通知
        registerForPushNotifications()
        
        // 2.检查应用是否通过通知启动
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
           let aps = notification["aps"] as? [String: AnyObject] {
            
            // 2 通过 aps 字典创建一个 NewsItem
            NewsItem.makeNewsItem(aps)
            
            // 3 切换标签视图控制器到新闻页面
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
        
        return true
    }
    
    func registerForPushNotifications() {
        // 1. 注册推送通知，向用户请求通知权限
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, _) in
                print("Perission granted: \(granted)");

                guard granted else { return }

                // !!!: 定义“可操作通知”的行为
                // 1 创建一个新的通知动作，标题为 "View" 按钮，当被触发时就会在前台打开应用程序。
                // 该动作有一个唯一标识符，iOS 用它来区分同一个通知上的其他动作。
                let viewAction = UNNotificationAction(identifier: Identifiers.viewAction,
                                                      title: "View",
                                                      options: [.foreground])

                // 2 定义新闻类别，它将包含动作按钮。这也有一个独特的标识符，您的有效载荷将需要包含该标识符，以指定推送通知属于该类别。
                let newCategory = UNNotificationCategory(identifier: Identifiers.newsCategory,
                                                         actions: [viewAction],
                                                         intentIdentifiers: [],
                                                         options: [])

                // 3 通过调用 setNotificationCategories 来注册新的可操作通知。
                UNUserNotificationCenter.current().setNotificationCategories([newCategory])

                self?.getNotificationSettings()
            }
    }
    
    // 获取通知设置
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // 向 APNs 注册成功时调用，返回设备标识符
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    // 向 APNs 注册失败时调用
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:\(error)")
    }
    
    // 当应用收到推送通知时，处理收到的推送通知内容
    // 默认情况下，如果应用收到推送通知时处于前台状态，则会丢弃通知内容
    // 这里可以截获推送内容，并更新应用页面
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        // 1. 检查 `content-available` 值是否为 1，如果是，这是一个「静默通知」标志。
        if aps["content-available"] as? Int == 1 {
            let podcastStore = PodcastStore.sharedStore
            // 2. 刷新播客列表，这是一个异步网络调用。
            podcastStore.refreshItems { (didLoadNewItems ) in
                // 3.当刷新完成后，调用完成处理程序，让系统知道应用程序是否加载了任何新数据。
                completionHandler(didLoadNewItems ? .newData : .noData)
            }
        } else {
            // 4. 如果不是静默通知，那么它就是一个新闻项目，所以要创建一个新闻项目。
            NewsItem.makeNewsItem(aps)
            completionHandler(.newData)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 1. 获取 userInfo 字典。
        let userInfo = response.notification.request.content.userInfo;
        
        // 2. 从 aps 字典中创建一个 NewsItem，然后导航到 News 标签页选项卡。
        if let aps = userInfo["aps"] as? [String: AnyObject],
           let newItem = NewsItem.makeNewsItem(aps) {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
            
            // 3. 检查 actionIdentifier。如果是 "View" 动作，并且链接是有效的 URL，那么它就会在一个 SFSafariViewController 中显示链接。
            if response.actionIdentifier == Identifiers.viewAction,
               let url = URL(string: newItem.link) {
                let safari = SFSafariViewController(url: url)
                window?.rootViewController?.present(safari, animated: true, completion: nil)
            }
        }
        
        // 4. 调用系统传递给你的完成处理程序。
        completionHandler()
    }
}
