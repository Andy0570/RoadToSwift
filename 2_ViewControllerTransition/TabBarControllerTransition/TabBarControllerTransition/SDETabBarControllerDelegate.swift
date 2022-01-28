//
//  SDETabBarControllerDelegate.swift
//  TabBarControllerTransition
//
//  Created by Qilin Hu on 2022/1/21.
//

import UIKit

class SDETabBarControllerDelegate: NSObject, UITabBarControllerDelegate {

    // interactive 变量用于标记当前转场的交互状态，仅在当前转场确实处于交互状态时，才提供交互控制器
    var interactive = false
    let interactionController = UIPercentDrivenInteractiveTransition()

    // 动画控制器，返回 nil 则没有动画效果
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let fromVCIndex = tabBarController.viewControllers?.firstIndex(of: fromVC),
                let toVCIndex = tabBarController.viewControllers?.firstIndex(of: toVC) else {
                    return nil
                }

        // 通过判断转场视图控制器的索引设置转场方向
        let tabOperationDirection: TabOperationDirection = toVCIndex < fromVCIndex ? TabOperationDirection.left : TabOperationDirection.right
        let transitionType = SDETransitionType.tabTransition(tabOperationDirection)
        return SlideAnimationController(type: transitionType)
    }

    // 交互控制器
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (interactive ? interactionController : nil)
    }
}
