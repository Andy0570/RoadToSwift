//
//  OverlayPresentationController.swift
//  CustomModelTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

// MARK: 在 iOS 8 及以上系统中，通过 UIPresentationController 实例给 toView 添加一个半透明背景视图
class OverlayPresentationController: UIPresentationController {
    let dimmingView = UIView()

    // Presentation 转场开始前该方法被调用
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

        // 执行转场时，在 presentingView 和 presentedView 之间添加半透明背景视图
        containerView.addSubview(dimmingView)

        let dimmingViewInitialWidth = containerView.frame.width * 2 / 3
        let dimmingViewInitialheight = containerView.frame.height * 2 / 3
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.center = containerView.center
        dimmingView.bounds = CGRect(x: 0, y: 0, width: dimmingViewInitialWidth, height: dimmingViewInitialheight)

        // MARK: 转场协调器（Transition Coordinator）
        // 通过 UIViewController 的 transitionCoordinator() 方法获取转场协调器。
        // animateAlongsideTransition:completion: 与动画控制器中的转场动画同步，执行其他动画。
        // 这里我们使用 transitionCoordinator 与转场动画并行执行 dimmingView 的动画。
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.bounds = containerView.bounds
        }, completion: nil)
    }

    // Dismissal 转场开始前该方法被调用。添加了 dimmingView 消失的动画
    // 实际上由于 presentedView 的形变动画，这个动画根本不会被注意到，此处只为示范。
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0.0
        }, completion: nil)
    }

    // iOS 8 带来了适应性布局，<UIContentContainer> 协议用于响应视图尺寸变化和屏幕旋转事件。
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {
            return
        }

        dimmingView.center = containerView.center
        dimmingView.bounds = containerView.bounds

        let presentedViewWidth = containerView.frame.width * 2 / 3
        let presentedViewHeight = containerView.frame.height * 2 / 3
        presentedView?.center = containerView.center
        presentedView?.bounds = CGRect(x: 0, y: 0, width: presentedViewWidth, height: presentedViewHeight)
    }

}
