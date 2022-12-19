//
//  TransitionCoordinator.swift
//  Pong
//
//  Created by Qilin Hu on 2022/1/27.
//  Copyright © 2022 Luke Parham. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UINavigationControllerDelegate {

    // 在该方法中返回一个遵守 <UIViewControllerAnimatedTransitioning> 协议的动画控制器
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return CircularTransition()
    }

}
