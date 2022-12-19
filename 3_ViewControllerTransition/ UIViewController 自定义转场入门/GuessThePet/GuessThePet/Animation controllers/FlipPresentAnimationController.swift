///// Copyright (c) 2017 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

  // 使用被点击卡片的 frame 作为动画的起点
  private let originFrame: CGRect

  init(originFrame: CGRect) {
    self.originFrame = originFrame
  }

  // 动画的持续时间
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }

  // 转场动画
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // 引用被替换的视图控制器、被呈现的视图控制器，对转换后的屏幕做一个快照
    guard let fromVC = transitionContext.viewController(forKey: .from),
          let toVC = transitionContext.viewController(forKey: .to),
          let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else {
      return
    }

    // UIKit 将整个转换过程封装在一个容器视图中，以简化对视图层次和动画的管理。
    // 获取对容器视图的引用，并获取新视图的最后一帧。
    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: toVC)

    // 配置 snapshot 的 fram，使其于 fromVC 视图中的卡片完全相同
    snapshot.frame = originFrame
    snapshot.layer.cornerRadius = CardViewController.cardCornerRadius
    snapshot.layer.masksToBounds = true

    // UIKit 创建的容器视图只包含 fromVC，所以你必须手动添加任何参与转场的其他视图
    // 另外，视图添加的顺序也很重要
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshot)
    toVC.view.isHidden = true

    // 通过将 snapshot 绕其Y轴旋转90˚来设置动画的起始状态。这将导致它在观看者面前处于边缘状态，因此，不可见。
    AnimationHelper.perspectiveTransform(for: containerView)
    snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)

    // 获取动画的时长
    let duration = transitionDuration(using: transitionContext)

    // 使用 UIView 的关键帧动画，动画时长必须与过渡动画的时长完全一致
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic) {

      // 首先，将 fromVC 视图绕其Y轴旋转90˚，将其隐藏起来。
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
        fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
      }

      // 接下来，通过将 snapshot 从上面设置的边缘朝上的状态旋转回来，将其显示。
      UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
        snapshot.layer.transform = AnimationHelper.yRotation(0.0)
      }

      // 设置 snapshot 的 frame，使其充满屏幕。
      UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
        snapshot.frame = finalFrame
        snapshot.layer.cornerRadius = 0
      }
    } completion: { _ in

      // 当动画完成时，snapshot 与 toVC.view 已经完全匹配，所以这里执行恢复和清理操作
      toVC.view.isHidden = false
      snapshot.removeFromSuperview()
      fromVC.view.layer.transform = CATransform3DIdentity

      // 调用 completeTransition(_:) 通知 UIKit 动画已经完成。
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }

  }

}
