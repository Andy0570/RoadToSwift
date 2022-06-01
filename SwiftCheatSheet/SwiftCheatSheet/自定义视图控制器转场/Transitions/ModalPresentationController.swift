//
//  ModalPresentationController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

class ModalPresentationController: UIPresentationController {
    lazy var fadeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0.0
        return view
    }()

    // Presentation 转场开始前该方法被调用
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

        containerView.insertSubview(fadeView, at: 0)
        NSLayoutConstraint.activate([
            fadeView.topAnchor.constraint(equalTo: containerView.topAnchor),
            fadeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            fadeView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            fadeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        guard let coordinator = presentedViewController.transitionCoordinator else {
            fadeView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.fadeView.alpha = 1.0
        })
    }

    // Dismissal 转场开始前该方法被调用
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            fadeView.alpha = 0.0
            return
        }

        if !coordinator.isInteractive {
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.fadeView.alpha = 0.0
            })
        }
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView, let presentedView = presentedView else {
            return .zero
        }

        let inset: CGFloat = 16
        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)

        let targetWidth = safeAreaFrame.width - 2 * inset
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height

        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y += 8.0
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        return frame
    }
}
