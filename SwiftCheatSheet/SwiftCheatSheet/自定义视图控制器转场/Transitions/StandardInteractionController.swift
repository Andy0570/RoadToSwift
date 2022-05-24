//
//  StandardInteractionController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

class StandardInteractionController: NSObject, InteractionController {
    var interactionInProgress = false // 跟踪交互是否正在进行
    private weak var viewController: CustomPresentable!
    private weak var transitionContext: UIViewControllerContextTransitioning?

    private var interactionDistance: CGFloat = 0
    private var interruptedTranslation: CGFloat = 0
    private var presentedFrame: CGRect?
    // 边缘情况：执行取消动画时，确保交互始终处于可用状态
    private var cancellationAnimator: UIViewPropertyAnimator?

    // MARK: - Setup
    init(viewController: CustomPresentable) {
        self.viewController = viewController
        super.init()
        prepareGestureRecognizer(in: viewController.view)
        if let scrollView = viewController.dismissalHandlingScrollView {
            resolveScrollViewGestures(scrollView)
        }
    }

    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = OneWayPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }

    private func resolveScrollViewGestures(_ scrollView: UIScrollView) {
        let scrollGestureRecognizer = OneWayPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        scrollGestureRecognizer.delegate = self

        scrollView.addGestureRecognizer(scrollGestureRecognizer)
        // 设置手势识别优先级，只有在 dismissal 手势识别器首先失败时才应该识别 scrollView 自身的滚动手势
        scrollView.panGestureRecognizer.require(toFail: scrollGestureRecognizer)
    }

    // MARK: - Gesture handling
    @objc func handleGesture(_ gestureRecognizer: OneWayPanGestureRecognizer) {
        guard let superview = gestureRecognizer.view?.superview else {
            return
        }
        let translation = gestureRecognizer.translation(in: superview).y
        // 将手势的速度带入紧随其后的弹簧动画中，用于设置 initialVelocity 参数
        let velocity = gestureRecognizer.velocity(in: superview).y

        switch gestureRecognizer.state {
        case .began: gestureBegan()
        case .changed: gestureChanged(translation: translation + interruptedTranslation, velocity: velocity)
        case .cancelled: gestureCancelled(translation: translation + interruptedTranslation, velocity: velocity)
        case .ended: gestureEnded(translation: translation + interruptedTranslation, velocity: velocity)
        default: break
        }
    }

    private func gestureBegan() {
        disableOtherTouches()
        cancellationAnimator?.stopAnimation(true)

        if let presentedFrame = presentedFrame {
            interruptedTranslation = viewController.view.frame.minY - presentedFrame.minY
        }

        if !interactionInProgress {
            interactionInProgress = true
            viewController.dismiss(animated: true)
        }
    }

    private func gestureChanged(translation: CGFloat, velocity: CGFloat) {
        var progress = interactionDistance == 0 ? 0 : (translation / interactionDistance)
        if progress < 0 { progress /= (1.0 + abs(progress * 20)) }
        update(progress: progress)
    }

    private func gestureCancelled(translation: CGFloat, velocity: CGFloat) {
        cancel(initialSpringVelocity: springVelocity(distanceToTravel: -translation, gestureVelocity: velocity))
    }

    // 当平移手势结束时，决定完成交互式转场还是取消转场
    private func gestureEnded(translation: CGFloat, velocity: CGFloat) {
        // 当手势速度很快时，无论如何都完成交互式转场并 dismissal 视图控制器。
        // 或者当手势平移超过一定距离并且在相反方向上没有明显的速度时，完成交互式转场动画。
        if velocity > 300 || (translation > interactionDistance / 2.0 && velocity > -300) {
            finish(initialSpringVelocity: springVelocity(distanceToTravel: interactionDistance - translation, gestureVelocity: velocity))
        } else {
            cancel(initialSpringVelocity: springVelocity(distanceToTravel: -translation, gestureVelocity: velocity))
        }
    }

    // MARK: - Transition controlling
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedViewController = transitionContext.viewController(forKey: .from)!
        presentedFrame = transitionContext.finalFrame(for: presentedViewController)
        self.transitionContext = transitionContext
        interactionDistance = transitionContext.containerView.bounds.height - presentedFrame!.minY
    }

    func update(progress: CGFloat) {
        guard let transitionContext = transitionContext, let presentedFrame = presentedFrame else {
            return
        }
        transitionContext.updateInteractiveTransition(progress)
        let presentedViewController = transitionContext.viewController(forKey: .from)!
        presentedViewController.view.frame = CGRect(x: presentedFrame.minX, y: presentedFrame.minY + interactionDistance * progress, width: presentedFrame.width, height: presentedFrame.height)

        if let modalPresentationController = presentedViewController.presentationController as? ModalPresentationController {
            modalPresentationController.fadeView.alpha = 1.0 - progress
        }
    }

    func cancel(initialSpringVelocity: CGFloat) {
        guard let transitionContext = transitionContext, let presentedFrame = presentedFrame else {
            return
        }
        let presentedViewController = transitionContext.viewController(forKey: .from)!

        let timingParameters = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: initialSpringVelocity))
        cancellationAnimator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timingParameters)

        cancellationAnimator?.addAnimations {
            presentedViewController.view.frame = presentedFrame
            if let modalPresentationController = presentedViewController.presentationController as? ModalPresentationController {
                modalPresentationController.fadeView.alpha = 1.0
            }
        }

        cancellationAnimator?.addCompletion { [weak self] _ in
            transitionContext.cancelInteractiveTransition()
            transitionContext.completeTransition(false)
            self?.interactionInProgress = false
            self?.enableOtherTouches()
        }

        cancellationAnimator?.startAnimation()
    }

    func finish(initialSpringVelocity: CGFloat) {
        guard let transitionContext = transitionContext, let presentedFrame = presentedFrame else {
            return
        }
        let presentedViewController = transitionContext.viewController(forKey: .from) as! CustomPresentable
        let dismissedFrame = CGRect(x: presentedFrame.minX, y: transitionContext.containerView.bounds.height, width: presentedFrame.width, height: presentedFrame.height)

        let timingParameters = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: initialSpringVelocity))
        let finishAnimator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timingParameters)

        finishAnimator.addAnimations {
            presentedViewController.view.frame = dismissedFrame
            if let modalPresentationController = presentedViewController.presentationController as? ModalPresentationController {
                modalPresentationController.fadeView.alpha = 0.0
            }
        }

        finishAnimator.addCompletion { [weak self] _ in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            self?.interactionInProgress = false
        }

        finishAnimator.startAnimation()
    }

    // MARK: - Helpers
    // 这里需要将 initialVelocity 的期望值归一化为动画覆盖的总距离
    private func springVelocity(distanceToTravel: CGFloat, gestureVelocity: CGFloat) -> CGFloat {
        distanceToTravel == 0 ? 0 : gestureVelocity / distanceToTravel
    }

    private func disableOtherTouches() {
        viewController.view.subviews.forEach {
            $0.isUserInteractionEnabled = false
        }
    }

    private func enableOtherTouches() {
        viewController.view.subviews.forEach {
            $0.isUserInteractionEnabled = true
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension StandardInteractionController: UIGestureRecognizerDelegate {
    // 根据滚动视图是否滚动到顶部来简单地决定触发哪个手势处理程序。
    // 换句话说：如果滚动视图的垂直内容偏移量为 0 或更小，则滑动应该由 dismissal 手势处理；否则，它应该由滚动视图处理。
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = viewController.dismissalHandlingScrollView {
            return scrollView.contentOffset.y <= 0
        }
        return true
    }
}
