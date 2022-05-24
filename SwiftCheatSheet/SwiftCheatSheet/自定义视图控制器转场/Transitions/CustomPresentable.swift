//
//  CustomPresentable.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/23.
//

/**
 Reference:

 [Mastering view controller transitions, part 1: Make them reusable](https://danielgauthier.me//2020/02/24/vctransitions1.html)
 [Mastering view controller transitions, part 2: Make them feel natural](https://danielgauthier.me//2020/02/27/vctransitions2.html)
 [Mastering view controller transitions, part 3: Make them resizable](https://danielgauthier.me//2020/03/03/vctransitions3.html)
 */
import UIKit

protocol CustomPresentable: UIViewController {
    // 被呈现控制器需要保持对遵守 <UIViewControllerTransitioningDelegate> 转场协议对象的强引用
    var transitionManager: UIViewControllerTransitioningDelegate? { get set }

    // 被呈现控制器中包含 scrollView 时，需要协调两个相互冲突的滑动手势。
    // 因为当用户在滚动视图上向下滑动，滚动视图会消耗手势，从而意外防止用户滑动关闭。
    var dismissalHandlingScrollView: UIScrollView? { get }

    // 更新自动布局约束
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
