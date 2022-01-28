//
//  SDENavigationDelegate.swift
//  NavigationControllerTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

class SDENavigationDelegate: NSObject, UINavigationControllerDelegate {

    // interactive 变量用于标记当前转场的交互状态，仅在当前转场确实处于交互状态时，才提供交互控制器
    var interactive = false
    let interactionController = UIPercentDrivenInteractiveTransition()

    // 动画控制器
    // 实现该方法提供动画控制器，返回 nil 则使用系统默认的效果
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let transitionType = SDETransitionType.navigationTransition(operation)
        return SlideAnimationController(type: transitionType)
    }

    // 交互控制器
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return (interactive ? interactionController : nil)
    }
}
