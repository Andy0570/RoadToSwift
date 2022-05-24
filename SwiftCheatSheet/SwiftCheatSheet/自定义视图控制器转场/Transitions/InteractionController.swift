//
//  InteractionController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

protocol InteractionController: UIViewControllerInteractiveTransitioning {
    // 是否通过手势触发 dismissal 转场
    var interactionInProgress: Bool { get }
}
