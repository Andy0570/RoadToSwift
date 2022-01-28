//
//  SDEModalTransitionDelegate.swift
//  CustomModelTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

class SDEModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimationController()

//        let transitionType = SDETransitionType.modalTransition(.presentation)
//        return SlideAnimationController(type: transitionType)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimationController()

//        let transitionType = SDETransitionType.modalTransition(.dismissal)
//        return SlideAnimationController(type: transitionType)
    }

    /**
     当 UIViewController 的 modalPresentationStyle 属性为 .Custom 时 (不支持.FullScreen)，我们有机会通过控制器的转场代理
     提供 UIPresentationController 的子类对 Modal 转场进行进一步的定制。

     UIPresentationController 类主要给 Modal 转场带来了以下几点变化：
     1. 定制 presentedView 的外观：设定 presentedView 的尺寸以及在 containerView 中添加自定义视图并为这些视图添加动画；
     2. 可以选择是否移除 presentingView；
     3. 可以在不需要动画控制器的情况下单独工作；
     4. iOS 8 中的适应性布局。
     */
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
