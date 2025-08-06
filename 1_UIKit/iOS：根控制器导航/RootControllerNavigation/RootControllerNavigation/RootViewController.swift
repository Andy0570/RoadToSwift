//
//  RootViewController.swift
//  RootControllerNavigation
//
//  Created by Stanislav Ostrovskiy on 12/5/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

// 应用程序的根视图控制器
class RootViewController: UIViewController {

    // 当前显示的视图控制器
    private var current: UIViewController
    
    var deeplink: DeeplinkType? {
        didSet {
            handleDeeplink()
        }
    }
    
    init() {
        // 默认的视图控制器是 Splash Screen
        current = SplashViewController()
        super.init(nibName:  nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParentViewController: self)
    }

    // 显示用户登录页面，无任何动画
    func showLoginScreen() {
        
        let new = UINavigationController(rootViewController: LoginViewController())

        // 添加新页面
        addChildViewController(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParentViewController: self)

        // 移除当前正在显示页面
        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current = new
    }

    // 用户登出，使用 slide-in 动画
    func switchToLogout() {
        let loginViewController = LoginViewController()
        let logoutScreen = UINavigationController(rootViewController: loginViewController)
        animateDismissTransition(to: logoutScreen)
    }

    // 切换到APP主页，使用 fade-in 动画
    func switchToMainScreen() {
        let mainViewController = MainViewController()
        let mainScreen = MainNavigationController(rootViewController: mainViewController)
        animateFadeTransition(to: mainScreen) { [weak self] in
            self?.handleDeeplink()
        }
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {

        // 当前页面将要移除
        current.willMove(toParentViewController: nil)

        // 添加新页面
        addChildViewController(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { completed in

            // 动画完成后，执行动作
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?() // 回调通知
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParentViewController: nil)
        addChildViewController(new)
        new.view.frame = initialFrame
        
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?()
        }
    }
    
    private func handleDeeplink() {
        if let mainNavigationController = current as? MainNavigationController, let deeplink = deeplink {
            switch deeplink {
            case .activity:
                mainNavigationController.popToRootViewController(animated: false)
                (mainNavigationController.topViewController as? MainViewController)?.showActivityScreen()
            default:
                // handle any other types of Deeplinks here
                break
            }
            
            // reset the deeplink back no nil, so it will not be triggered more than once
            self.deeplink = nil
        }
    }
}
