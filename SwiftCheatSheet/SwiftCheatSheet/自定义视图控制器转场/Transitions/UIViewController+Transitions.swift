//
//  UIViewController+Transitions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

enum InteractiveDismissalType {
    case none
    case standard
}

extension UIViewController {
    func present(_ viewController: CustomPresentable, interactiveDismissalType: InteractiveDismissalType, completion: (() -> Void)? = nil) {
        let interactionController: InteractionController?
        switch interactiveDismissalType {
        case .none:
            interactionController = nil
        case .standard:
            // 通过 presented Controller 初始化交互式控制器
            interactionController = StandardInteractionController(viewController: viewController)
        }

        let transitionManager = ModalTransitionManager(interactionController: interactionController)
        // presented Controller 需要通过 transitionManager 属性保持对转场控制器的强引用，
        // 因为 transitioningDelegate 是一个弱引用。
        viewController.transitionManager = transitionManager
        viewController.transitioningDelegate = transitionManager
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true, completion: completion)
    }
}
