/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

extension UIViewController {
  /// Add a child view controller to the current UIViewController. Use this method instead of `addChild`!
  @discardableResult
  func addChildController(_ child: UIViewController?, bottomAnchor: NSLayoutYAxisAnchor? = nil) -> UIViewController? {
    guard let child = child else {
      return nil
    }

    if child.parent != nil {
      child.removeFromParentVC()
    }

    child.willMove(toParent: self)
    addChild(child)
    view.addSubview(child.view)
    child.didMove(toParent: self)

    child.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      child.view.topAnchor.constraint(equalTo: view.topAnchor),
      child.view.bottomAnchor.constraint(equalTo: bottomAnchor ?? view.bottomAnchor)
    ])

    return child
  }

  /// Remove this view controller from its parent controller
  @objc func removeFromParentVC() {
    guard parent != nil else {
      return
    }

    DispatchQueue.main.async {
      self.willMove(toParent: nil)
      NSLayoutConstraint.deactivate(self.view.constraints) // clear constraints
      self.view.removeFromSuperview()
      self.removeFromParent()
    }
  }
}
