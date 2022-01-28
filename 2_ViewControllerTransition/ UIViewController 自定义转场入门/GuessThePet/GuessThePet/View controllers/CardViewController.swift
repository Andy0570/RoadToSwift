/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CardViewController: UIViewController {
  
  static let cardCornerRadius: CGFloat = 25
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  
  var pageIndex: Int?
  var petCard: PetCard?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = petCard?.description
    cardView.layer.cornerRadius = CardViewController.cardCornerRadius
    cardView.layer.masksToBounds = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segueIdentifier(for: segue) == .reveal,
      let destinationViewController = segue.destination as? RevealViewController {
      destinationViewController.petCard = petCard
      // 当前视图控制器为 toVC 的转场协议提供委托实现
      // 注意，是被展示的视图控制器被要求提供一个转场委托
      destinationViewController.transitioningDelegate = self
    }
  }
  
  @IBAction func handleTap() {
    performSegue(withIdentifier: .reveal, sender: nil)
  }
}

extension CardViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case reveal
  }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CardViewController: UIViewControllerTransitioningDelegate {

  // present 动画控制器
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return FlipPresentAnimationController(originFrame: cardView.frame)
  }

  // dismiss 动画控制器
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // 确保被 dismiss 的视图控制器是预期的类型
    guard let revealVC = dismissed as? RevealViewController else {
      return nil
    }

    return FlipDismissAnimationController(destinationFrame: cardView.frame, interactionController: revealVC.swipeInteractionController)
  }

  // 交互控制器
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    guard let animator = animator as? FlipDismissAnimationController,
            let interactionController = animator.interactionController,
            interactionController.interactionInprogress else {
      return nil
    }

    return interactionController
  }
  
}

