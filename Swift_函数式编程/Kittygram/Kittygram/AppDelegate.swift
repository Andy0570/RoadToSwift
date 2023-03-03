//
//  AppDelegate.swift
//  Kittygram
//
//  Created by Lukasz Mroz on 14.10.2016.
//  Copyright © 2016 Sunshinejr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        // 创建一个纯导航控制器，它没有任何根视图控制器
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()

        window?.makeKeyAndVisible()
        return true
    }
}

