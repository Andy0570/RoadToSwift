//
//  SplashViewController.swift
//  RootControllerNavigation
//
//  Created by Stanislav Ostrovskiy on 12/5/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

// 启动应用程序时，Splash Screen 将是用户看到的第一个屏幕。这是执行所有服务API调用、检查用户会话、触发登录前分析等的最佳时机。
// 要在此屏幕上指示活动，我们将使用 UIActivityIndicatorView
class SplashViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(activityIndicator)
        
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        makeServiceCall()
    }

    // 模拟 API 调用
    private func makeServiceCall() {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.activityIndicator.stopAnimating()
            if UserDefaults.standard.bool(forKey: "LOGGED_IN") {
                // 用户已登陆，跳转到主页
                AppDelegate.shared.rootViewController.switchToMainScreen()
            } else {
                // 用户未登陆，跳转到登录页面
                AppDelegate.shared.rootViewController.showLoginScreen()
            }
        }
    }
}
