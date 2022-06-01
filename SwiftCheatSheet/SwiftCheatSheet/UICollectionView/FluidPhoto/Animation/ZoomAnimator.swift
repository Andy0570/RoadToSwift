//
//  ZoomAnimator.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/30.
//

import UIKit

// 这是 fromVC 和 toVC 都要遵守并实现的协议
protocol ZoomAnimatorDelegate: AnyObject {
    func transitionWillStartWith(zoomAnimator: ZoomAnimator)
    func transitionDidEndWith(zoomAnimator: ZoomAnimator)
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView?
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect?
}

extension ZoomAnimatorDelegate {
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
    }

    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
    }
}

/// 动画控制器，负责缩放动画逻辑
class ZoomAnimator: NSObject {
    weak var fromDelegate: ZoomAnimatorDelegate?
    weak var toDelegate: ZoomAnimatorDelegate?

    var transitionImageView: UIImageView?
    var isPresenting = true

    // 放大动画
    private func animateZoomInTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from),
            let fromReferenceImageView = self.fromDelegate?.referenceImageView(for: self),
            let toReferenceImageView = self.toDelegate?.referenceImageView(for: self),
            let fromReferenceImageViewFrame = self.fromDelegate?.referenceImageViewFrameInTransitioningView(for: self),
            let fromReferenceImage = fromReferenceImageView.image else {
                return
            }

        let containerView = transitionContext.containerView

        self.fromDelegate?.transitionWillStartWith(zoomAnimator: self)
        self.toDelegate?.transitionWillStartWith(zoomAnimator: self)

        toVC.view.alpha = 0
        toReferenceImageView.isHidden = true
        containerView.addSubview(toVC.view)

        if self.transitionImageView == nil {
            let transitionImageView = UIImageView(image: fromReferenceImage)
            transitionImageView.frame = fromReferenceImageViewFrame
            transitionImageView.contentMode = .scaleAspectFill
            transitionImageView.clipsToBounds = true
            self.transitionImageView = transitionImageView
            containerView.addSubview(transitionImageView)
        }

        fromReferenceImageView.isHidden = true

        let finalTransitionFrame = calculateZoomInImageFrame(image: fromReferenceImage, forView: toVC.view)
        // swiftlint:disable:next multiline_arguments
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .transitionCrossDissolve) {
            self.transitionImageView?.frame = finalTransitionFrame
            toVC.view.alpha = 1.0
            fromVC.tabBarController?.tabBar.alpha = 0
        } completion: { _ in
            self.transitionImageView?.removeFromSuperview()
            self.transitionImageView = nil

            toReferenceImageView.isHidden = false
            fromReferenceImageView.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.toDelegate?.transitionDidEndWith(zoomAnimator: self)
            self.fromDelegate?.transitionDidEndWith(zoomAnimator: self)
        }
    }

    // 缩小动画
    private func animateZoomOutTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from),
            let fromReferenceImageView = self.fromDelegate?.referenceImageView(for: self),
            let toReferenceImageView = self.toDelegate?.referenceImageView(for: self),
            let fromReferenceImageViewFrame = self.fromDelegate?.referenceImageViewFrameInTransitioningView(for: self),
            let toReferenceImageViewFrame = self.toDelegate?.referenceImageViewFrameInTransitioningView(for: self),
            let fromReferenceImage = fromReferenceImageView.image else {
                return
            }

        let containerView = transitionContext.containerView

        self.fromDelegate?.transitionWillStartWith(zoomAnimator: self)
        self.toDelegate?.transitionWillStartWith(zoomAnimator: self)

        toReferenceImageView.isHidden = true

        if self.transitionImageView == nil {
            let transitionImageView = UIImageView(image: fromReferenceImage)
            transitionImageView.frame = fromReferenceImageViewFrame
            transitionImageView.contentMode = .scaleAspectFill
            transitionImageView.clipsToBounds = true
            self.transitionImageView = transitionImageView
            containerView.addSubview(transitionImageView)
        }

        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        fromReferenceImageView.isHidden = true

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: []) {
            fromVC.view.alpha = 0
            self.transitionImageView?.frame = toReferenceImageViewFrame
            toVC.tabBarController?.tabBar.alpha = 1
        } completion: { _ in
            self.transitionImageView?.removeFromSuperview()
            self.transitionImageView = nil
            toReferenceImageView.isHidden = false
            fromReferenceImageView.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.toDelegate?.transitionDidEndWith(zoomAnimator: self)
            self.fromDelegate?.transitionDidEndWith(zoomAnimator: self)
        }
    }

    private func calculateZoomInImageFrame(image: UIImage, forView view: UIView) -> CGRect {
        let viewRatio = view.frame.size.width / view.frame.size.height
        let imageRatio = image.size.width / image.size.height
        let touchesSides = (imageRatio > viewRatio)

        if touchesSides {
            let height = view.frame.width / imageRatio
            let yPoint = view.frame.minY + (view.frame.height - height) / 2
            return CGRect(x: 0, y: yPoint, width: view.frame.width, height: height)
        } else {
            let width = view.frame.height * imageRatio
            let xPoint = view.frame.minX + (view.frame.width - width) / 2
            return CGRect(x: xPoint, y: 0, width: width, height: view.frame.height)
        }
    }
}

extension ZoomAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0.5 : 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animateZoomInTransition(using: transitionContext)
        } else {
            animateZoomOutTransition(using: transitionContext)
        }
    }
}
