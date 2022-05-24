//
//  ModalTransitionManager.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/23.
//

import UIKit

class ModalTransitionManager: NSObject {

    private var interactionController: InteractionController?

    init(interactionController: InteractionController?) {
        self.interactionController = interactionController
    }
}

extension ModalTransitionManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

    }

    // 是否应该以交互式方式执行 dismiss 动画？
    // 当用户点击关闭按钮时，以非交互方式关闭视图；否则，返回一个交互式控制器
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

    }
}
