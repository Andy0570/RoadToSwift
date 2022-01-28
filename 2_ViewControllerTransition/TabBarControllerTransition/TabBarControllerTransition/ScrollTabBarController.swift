//
//  ScrollTabBarController.swift
//  TabBarControllerTransition
//
//  Created by Qilin Hu on 2022/1/21.
//

import UIKit

class ScrollTabBarController: UITabBarController {

    // 屏幕边缘手势
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        var recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        return recognizer
    }()

    // 保留强引用
    private let tabBarControllerDelegate = SDETabBarControllerDelegate()

    // 计算属性，返回容器中视图控制器的数量
    private var subViewControllerCount: Int {
        if let count = viewControllers?.count {
            return count
        } else {
            return 0
        }
    }

    deinit {
        view.removeGestureRecognizer(panGestureRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = tabBarControllerDelegate
        tabBar.tintColor = .green
        view.addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: Actions

    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let translationX =  panGesture.translation(in: view).x
        let translationAbs = translationX > 0 ? translationX : -translationX
        let progress = translationAbs / view.frame.width

        switch panGesture.state {
        case .began:
            tabBarControllerDelegate.interactive = true
            let velocityX = panGesture.velocity(in: view).x
            if velocityX < 0 {
                if selectedIndex < subViewControllerCount - 1 {
                    selectedIndex += 1
                }
            } else {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            }
        case .changed:
            tabBarControllerDelegate.interactionController.update(progress)
        case .cancelled, .ended:
            /*这里有个小问题，转场结束或是取消时有很大几率出现动画不正常的问题。在8.1以上版本的模拟器中都有发现，7.x 由于缺乏条件尚未测试，
              但在我的 iOS 9.2 的真机设备上没有发现，而且似乎只在 UITabBarController 的交互转场中发现了这个问题。在 NavigationController 暂且没发现这个问题，
              Modal 转场尚未测试，因为我在 Demo 里没给它添加交互控制功能。

              测试不完整，具体原因也未知，不过解决手段找到了。多谢 @llwenDeng 发现这个 Bug 并且找到了解决手段。
              解决手段是修改交互控制器的 completionSpeed 为1以下的数值，这个属性用来控制动画速度，我猜测是内部实现在边界判断上有问题。
              这里其修改为0.99，既解决了 Bug 同时尽可能贴近原来的动画设定。
            */
            if progress > 0.3 {
                // completionSpeed 属性用来解决动画在交互/非交互状态之间切换时的平滑过渡问题
                tabBarControllerDelegate.interactionController.completionSpeed = 0.99
                tabBarControllerDelegate.interactionController.finish()
            } else {
                // 转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                tabBarControllerDelegate.interactionController.completionSpeed = 0.99
                tabBarControllerDelegate.interactionController.cancel()
            }
            tabBarControllerDelegate.interactive = false
        default:
            break
        }
    }
    



}
