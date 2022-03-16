//
//  AppDelegate.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/16.
//

import UIKit
import SwiftyBeaver
let log = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configSwiftBeaver()

        return true
    }

    func configSwiftBeaver() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: 备忘录模式，恢复应用状态
    // 备忘录模式捕获并使对象的内部状态暴露出来。换句话说，它可以在某处保存你的东西，稍后在不违反封装的原则下恢复此对外暴露的状态。
    // 也就是说，私有数据仍然是私有的。

    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
