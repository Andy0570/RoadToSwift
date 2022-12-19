//
//  ViewController.swift
//  Demo
//
//  Created by Andrea Mazzini on 13/05/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import BubbleTransition

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
  @IBOutlet weak var transitionButton: UIButton!
  
  let transition = BubbleTransition()
  let interactiveTransition = BubbleInteractiveTransition()
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? ModalViewController {
      controller.transitioningDelegate = self
      controller.modalPresentationStyle = .custom
      controller.modalPresentationCapturesStatusBarAppearance = true
      controller.interactiveTransition = interactiveTransition
      interactiveTransition.attach(to: controller)
    }
  }
  
  // MARK: UIViewControllerTransitioningDelegate

  // Present 转场动画
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    // 转场气泡的发源地、颜色
    transition.startingPoint = transitionButton.center
    transition.bubbleColor = transitionButton.backgroundColor!
    return transition
  }

  // Dismiss 转场动画
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    // 转场气泡的发源地、颜色
    transition.startingPoint = transitionButton.center
    transition.bubbleColor = transitionButton.backgroundColor!
    return transition
  }

  // 交互式控制器
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactiveTransition
  }
  
}

