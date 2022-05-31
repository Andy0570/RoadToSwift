//
//  ZoomDismissalInteractionController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/30.
//

import UIKit

class ZoomDismissalInteractionController: NSObject {
    var transitionContext: UIViewControllerContextTransitioning?
    var animator: UIViewControllerAnimatedTransitioning?

    var fromReferenceImageViewFrame: CGRect?
    var toReferenceImageViewFrame: CGRect?

    // 每次用户触发平移手势时都会调用该方法
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        guard let transitionContext = transitionContext,
            let animator = self.animator as? ZoomAnimator,
            let transitionImageView = animator.transitionImageView,
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromReferenceImageView = animator.fromDelegate?.referenceImageView(for: animator),
            let toReferenceImageView = animator.toDelegate?.referenceImageView(for: animator),
            let fromReferenceImageViewFrame = self.fromReferenceImageViewFrame,
            let toReferenceImageViewFrame = self.toReferenceImageViewFrame else {
            return
        }

        fromReferenceImageView.isHidden = true

        // The center point of source image
        let anchorPoint = CGPoint(x: fromReferenceImageViewFrame.midX, y: fromReferenceImageViewFrame.midY)
        // The translation of the image
        let translatedPoint = gestureRecognizer.translation(in: fromReferenceImageView)
        // The vertical translation of the image
        let verticalDelta: CGFloat = translatedPoint.y < 0 ? 0 : translatedPoint.y
        let backgroundAlpha = backgroundAlphaFor(view: fromVC.view, withPanningVerticalDelta: verticalDelta)
        let scale = scaleFor(view: fromVC.view, withPanningVerticalDelta: verticalDelta)
        fromVC.view.alpha = backgroundAlpha
        // Update image size according to translation of the pan gesture
        transitionImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        // Calculate the position of image to use animation
        let newCenter = CGPoint(x: anchorPoint.x + translatedPoint.x, y: anchorPoint.y + translatedPoint.y - transitionImageView.frame.height * (1 - scale) / 2.0)
        transitionImageView.center = newCenter

        toReferenceImageView.isHidden = true

        // Update interactive transition by scale
        transitionContext.updateInteractiveTransition(1 - scale)

        toVC.tabBarController?.tabBar.alpha = 1 - backgroundAlpha

        if gestureRecognizer.state == .ended {
            let velocity = gestureRecognizer.velocity(in: fromVC.view)
            if velocity.y < 0 || newCenter.y < anchorPoint.y {
                // cancel
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: []) {
                    transitionImageView.frame = fromReferenceImageViewFrame
                    fromVC.view.alpha = 1.0
                    toVC.tabBarController?.tabBar.alpha = 0
                } completion: { _ in
                    toReferenceImageView.isHidden = false
                    fromReferenceImageView.isHidden = false
                    transitionImageView.removeFromSuperview()
                    animator.transitionImageView = nil

                    transitionContext.cancelInteractiveTransition()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    animator.toDelegate?.transitionDidEndWith(zoomAnimator: animator)
                    animator.fromDelegate?.transitionDidEndWith(zoomAnimator: animator)
                    self.transitionContext = nil
                }
            }

            // start animation
            let finalTransitionSize = toReferenceImageViewFrame
            UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                transitionImageView.frame = finalTransitionSize
                fromVC.view.alpha = 0
                toVC.tabBarController?.tabBar.alpha = 1
            } completion: { _ in
                transitionImageView.removeFromSuperview()
                toReferenceImageView.isHidden = false
                fromReferenceImageView.isHidden = false

                self.transitionContext?.finishInteractiveTransition()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                animator.toDelegate?.transitionDidEndWith(zoomAnimator: animator)
                animator.fromDelegate?.transitionDidEndWith(zoomAnimator: animator)
                self.transitionContext = nil
            }
        }
    }

    func backgroundAlphaFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        let startingAlpha: CGFloat = 1.0
        let finalAlpha: CGFloat = 0.0
        let totalAvailableAlpha = startingAlpha - finalAlpha

        let maximumDelta = view.bounds.height / 4.0
        let deltaAsPercentageOfMaximun = min(abs(verticalDelta) / maximumDelta, 1.0)

        return startingAlpha - (deltaAsPercentageOfMaximun * totalAvailableAlpha)
    }

    func scaleFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        let startingScale: CGFloat = 1.0
        let finalScale: CGFloat = 0.5
        let totalAvailableScale = startingScale - finalScale

        let maximumDelta = view.bounds.height / 2.0
        let deltaAsPercentageOfMaximun = min(abs(verticalDelta) / maximumDelta, 1.0)

        return startingScale - (deltaAsPercentageOfMaximun * totalAvailableScale)
    }
}

extension ZoomDismissalInteractionController: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext

        let containerView = transitionContext.containerView

        guard let animator = self.animator as? ZoomAnimator,
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromReferenceImageViewFrame = animator.fromDelegate?.referenceImageViewFrameInTransitioningView(for: animator),
            let toReferenceImageViewFrame = animator.toDelegate?.referenceImageViewFrameInTransitioningView(for: animator),
            let fromReferenceImageView = animator.fromDelegate?.referenceImageView(for: animator),
            let fromReferenceImage = fromReferenceImageView.image else {
                return
            }

        animator.fromDelegate?.transitionWillStartWith(zoomAnimator: animator)
        animator.toDelegate?.transitionWillStartWith(zoomAnimator: animator)

        self.fromReferenceImageViewFrame = fromReferenceImageViewFrame
        self.toReferenceImageViewFrame = toReferenceImageViewFrame

        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        if animator.transitionImageView == nil {
            let transitionImageView = UIImageView(image: fromReferenceImage)
            transitionImageView.contentMode = .scaleAspectFill
            transitionImageView.clipsToBounds = true
            transitionImageView.frame = fromReferenceImageViewFrame
            animator.transitionImageView = transitionImageView
            containerView.addSubview(transitionImageView)
        }
    }
}
