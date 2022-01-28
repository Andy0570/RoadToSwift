//
//  SlideAnimationController.swift
//  CustomModelTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

// 转场的操作类型，模拟系统默认的转场效果：
// * NavigationController push/pop 效果
// * TabBarController 的滑动切换效果
// * Modal 转场的垂直切换效果
enum SDETransitionType {
    case navigationTransition(UINavigationController.Operation)
    case tabTransition(TabOperationDirection)
    case modalTransition(ModalOperation)
}

enum TabOperationDirection {
    case left, right
}

enum ModalOperation {
    case presentation, dismissal
}

class SlideAnimationController: NSObject {
    // 该变量用于存储当前转场的操作类型
    private var transitionType: SDETransitionType

    init(type: SDETransitionType) {
        transitionType = type
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension SlideAnimationController: UIViewControllerAnimatedTransitioning {

    // 转场动画的执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    // 转场动画的核心方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)

        guard let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view,
              let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view else {
                  return
              }

        // 计算位移 transform，NavigationVC 和 TabBarVC 在水平方向上动画，Modal 转场在垂直方向上动画。
        var translation = containerView.frame.width
        var toViewTransform = CGAffineTransform.identity
        var fromViewTransform = CGAffineTransform.identity

        switch transitionType {
        case .navigationTransition(let operation):
            translation = (operation == .push ? translation : -translation)
            toViewTransform = CGAffineTransform(translationX: translation, y: 0)
            fromViewTransform = CGAffineTransform(translationX: -translation, y: 0)
        case .tabTransition(let direction):
            translation = (direction == .left ? translation : -translation)
            fromViewTransform = CGAffineTransform(translationX: translation, y: 0)
            toViewTransform = CGAffineTransform(translationX: -translation, y: 0)
        case .modalTransition(let operation):
            translation = containerView.frame.height
            toViewTransform = CGAffineTransform(translationX: 0, y: (operation == .presentation) ? translation : 0)
            fromViewTransform = CGAffineTransform(translationX: 0, y: (operation == .presentation) ? 0 : translation)
        }

        // 1. 首先，将 toView 添加到容器视图中。
        // 在 Model 转场的 Custom 模式下，presentation 结束后 presentingView (fromView) 并未被主动移出视图结构。
        // 因此在 dismissal 中，注意不要像其他转场中那样将 presentingView (toView) 加入 containerView 中，
        // 否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。
        switch transitionType {
        case .modalTransition(let operation):
            switch operation {
            case .presentation:
                containerView.addSubview(toView)
            case .dismissal:
                break
            }
        default: containerView.addSubview(toView)
        }

        // 2. 通过 UIView Animtion API 执行转场动画，以适配交互式转场
        toView.transform = toViewTransform
        UIView.animate(withDuration: duration) {
            fromView.transform = fromViewTransform
            toView.transform = CGAffineTransform.identity
        } completion: { _ in
            // 考虑到转场中途可能取消的情况，转场结束后，恢复视图状态
            fromView.transform = CGAffineTransform.identity
            toView.transform = CGAffineTransform.identity

            // UIView 动画执行结束后，使用 completeTransition() 来通知系统：转场过程结束
            // 通过 transitionWasCancelled() 获取转场结果
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        // 3. 转场结束后，fromView 会从视图结构中移除，UIKit 自动替我们做了这事。
    }
}
