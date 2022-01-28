//
//  OverlayAnimationController.swift
//  CustomModelTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

class OverlayAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // 转场动画的执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
 
    // 转场动画的核心方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
              let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
              let fromView = fromVC.view,
              let toView = toVC.view else {
                  return
              }

        /**
         Modal 转场在 Custom 模式下必须区分 presentation 和 dismissal 转场，而在 FullScreen 模式下可以不用这么做，
         因为 UIKit 会在 dismissal 转场结束后自动将 presentingView 放置到原来的位置。
         */
        
        // 不像容器 VC 转场里需要额外的变量来标记操作类型，UIViewController 自身就有方法跟踪 Modal 状态。
        // 处理 Presentation 转场
        if toVC.isBeingPresented {
            containerView.addSubview(toView)

            let toViewWidth = containerView.frame.width * 2 / 3
            let toViewHeight = containerView.frame.height * 2 / 3
            toView.center = containerView.center
            toView.bounds = CGRect(x: 0, y: 0, width: 1, height: toViewWidth)

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
            } completion: { _ in
                // UIView 动画执行结束后，使用 completeTransition() 来通知系统：转场过程结束
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

        // 处理 Dismissal 转场，.Custom 模式下不要将 toView 添加到 containerView
        if fromVC.isBeingDismissed {
            let fromViewHeight = fromView.frame.height
            
            UIView.animate(withDuration: duration) {
                fromView.bounds = CGRect(x: 0, y: 0, width: 1, height: fromViewHeight)
            } completion: { _ in
                // UIView 动画执行结束后，使用 completeTransition() 来通知系统：转场过程结束
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }

}
