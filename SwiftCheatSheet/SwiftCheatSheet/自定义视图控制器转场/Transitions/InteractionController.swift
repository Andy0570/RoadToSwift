//
//  InteractionController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

protocol InteractionController: UIViewControllerInteractiveTransitioning {
    var interactionInProgress: Bool { get }
}
