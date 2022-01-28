//
//  CircularTransition.swift
//  Pong
//
//  Created by Qilin Hu on 2022/1/27.
//  Copyright © 2022 Luke Parham. All rights reserved.
//

import UIKit

protocol CircleTransitionable {
    // 用户点击的按钮
    var triggerButton: UIButton { get }
    // 在屏幕内外制作动画的文本视图
    var contentTextView: UITextView { get }
    // 在屏幕内外制作动画的主视图
    var mainView: UIView { get }
}

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning {

    weak var context: UIViewControllerContextTransitioning?

    // 转场动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    // 转场动画核心方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? CircleTransitionable,
              let toVC = transitionContext.viewController(forKey: .to) as? CircleTransitionable,
              let snapshot = fromVC.mainView.snapshotView(afterScreenUpdates: false) else {
                  transitionContext.completeTransition(false)
                  return
              }

        context = transitionContext

        let containerView = transitionContext.containerView

        // 带有旧视图颜色的背景视图
        let backgroundView = UIView()
        backgroundView.frame = fromVC.mainView.frame
        backgroundView.backgroundColor = fromVC.mainView.backgroundColor
        containerView.addSubview(backgroundView)

        // 将旧文本视图以动画方式离屏
        containerView.addSubview(snapshot)
        fromVC.mainView.removeFromSuperview()
        animateOldTextOffscreen(fromView: snapshot)

        // 逐渐放大的圆形蒙版
        containerView.addSubview(toVC.mainView)
        animate(toView: toVC.mainView, fromTriggerButton: fromVC.triggerButton)

        // 为文本设置淡入动画效果
        animateToTextView(toTextView: toVC.contentTextView, fromTriggerButton: fromVC.triggerButton)
    }

    func animateOldTextOffscreen(fromView: UIView) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn], animations: {
            // 将视图的中心向左下移出屏幕
            fromView.center = CGPoint(x: fromView.center.x - fromView.frame.size.width * 3,
                                      y: fromView.center.y + fromView.frame.size.height * 2.5)
            // 将视图放大 5 倍
            fromView.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        }, completion: nil)
    }

    func animate(toView: UIView, fromTriggerButton triggerButton: UIButton) {
        // 1⃣️ 起始路径
        let rect = CGRect(x: triggerButton.frame.origin.x,
                          y: triggerButton.frame.origin.y,
                          width: triggerButton.frame.width,
                          height: triggerButton.frame.width)
        // 贝塞尔曲线，在正方形矩形区域中画一个椭圆，这里实际上会画出一个圆形
        let circleMaskPathInitial = UIBezierPath(ovalIn: rect)

        // 2⃣️ 终止路径
        let fullHeight = toView.bounds.height
        // 屏幕外的一个点
        let extremePoint = CGPoint(x: triggerButton.center.x,
                                   y: triggerButton.center.y - fullHeight)
        // 使用勾股定理（a² + b² = c²）计算新圆的半径，也就是直角三角形的斜边
        let radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y))
        // 在当前 triggerButton 圆的基础上，在两个方向上插入“负数”来创建一个完全超出屏幕的圆
        let circleMaskPathFinal = UIBezierPath(ovalIn: triggerButton.frame.insetBy(dx: -radius, dy: -radius))

        // 圆形蒙版
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toView.layer.mask = maskLayer

        // 在小圆和大圆之间添加一个动画
        // 由于 UIView 动画无法作用于 CALayers，因此我们需要创建 Core Animation 动画。
        // 创建一个动画对象，被动画的属性是 path 属性。这意味着对渲染的形状进行动画。
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.duration = 0.15
        maskLayerAnimation.delegate = self
        // 为圆形蒙版的 path 属性添加动画
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }

    // 为 toVC 的文本视图添加渐变效果
    func animateToTextView(toTextView: UIView, fromTriggerButton: UIButton) {

        // 设置 toTextView 的初始状态
        let originalCenter = toTextView.center
        toTextView.alpha = 0.0
        toTextView.center = fromTriggerButton.center
        toTextView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        // 添加动画，还原 toTextView 到默认状态
        UIView.animate(withDuration: 0.25, delay: 0.1, options: [.curveEaseOut], animations: {
            toTextView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            toTextView.center = originalCenter
            toTextView.alpha = 1.0
        }, completion: nil)
    }

}

extension CircularTransition: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        context?.completeTransition(true)
    }
}
