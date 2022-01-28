///// Copyright (c) 2017 Razeware LLC
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

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

  // 描述交互式动画是否已经发生
  var interactionInprogress = false

  // 用于在内部控制过渡
  private var shouldCompleteTransition = false
  // 该交互式控制器所连接的视图控制器
  private weak var viewController: UIViewController!

  init(viewController: UIViewController) {
    super.init()

    self.viewController = viewController
    prepareGestureRecognizer(in: viewController.view)
  }

  // 添加边缘手势识别器
  private func prepareGestureRecognizer(in view: UIView) {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
    gesture.edges = .left
    view.addGestureRecognizer(gesture)
  }

  // MARK: - Actions

  @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {

    // 通过一个局部变量跟踪手势进度，划过超过 200 point 被认为足以完成转场动画
    let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
    var progress = translation.x / 200
    progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

    switch gestureRecognizer.state {
    case .began:
      interactionInprogress = true
      viewController.dismiss(animated: true, completion: nil)
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
    case .cancelled:
      interactionInprogress = false
      cancel()
    case .ended:
      interactionInprogress = false
      if shouldCompleteTransition {
        finish()
      } else {
        cancel()
      }
    default:
      break
    }
  }

}
