//
//  CustomPresentable.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/23.
//

import UIKit

protocol CustomPresentable: UIViewController {
    // 被呈现控制器需要保持对遵守 <UIViewControllerTransitioningDelegate> 转场协议对象的强引用
    var transitionManager: UIViewControllerTransitioningDelegate? { get set }
    var dismissalHandlingScrollView: UIScrollView? { get }
    func updatePresentationLayout(animated: Bool)
}

extension CustomPresentable {
    var dismissalHandlingScrollView: UIScrollView? { nil }

    func updatePresentationLayout(animated: Bool) {
        presentationController?.containerView?.setNeedsLayout()
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                self.presentationController?.containerView?.layoutIfNeeded()
            }, completion: nil)
        } else {
            presentationController?.containerView?.layoutIfNeeded()
        }
    }
}
