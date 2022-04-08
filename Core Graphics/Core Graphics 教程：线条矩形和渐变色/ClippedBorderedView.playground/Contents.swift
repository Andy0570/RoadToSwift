/// Copyright (c) 2019 Razeware LLC
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
import PlaygroundSupport

class YellowViewWithRedBorder: UIView {
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else  {
      return
    }
    
    let redColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.6).cgColor
    let yellowColor = UIColor(red: 1.0, green: 1.0, blue: 0, alpha: 0.6).cgColor
    
    context.setFillColor(yellowColor)
    context.fill(bounds)
    
    // Inset the stroke rect to prevent clipping half the red border
    let strokeRect = bounds
    // let strokeRect = bounds.inset(by: UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5))
    
    context.setStrokeColor(redColor)
    context.stroke(strokeRect)
  }
}

class StripedBackgroundView: UIView {
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else  {
      return
    }
    
    let greyColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5).cgColor
    
    context.setFillColor(greyColor)
    
    for i in (0 ..< Int(bounds.maxX)) where i % 2 == 0 {
      let verticalRect = CGRect(x: CGFloat(i), y: bounds.minY, width: CGFloat(1), height: bounds.height)
      context.fill(verticalRect)
    }
    
    for i in (0 ..< Int(bounds.maxY)) where i % 2 == 0 {
      let horizontalRect = CGRect(x: bounds.minX, y: CGFloat(i), width: bounds.width, height: CGFloat(1))
      context.fill(horizontalRect)
    }
  }
}

class ClippedBorderedViewController: UIViewController {
  override func loadView() {
    let view = StripedBackgroundView()
    self.view = view
    
    let yellowRedView = YellowViewWithRedBorder(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    yellowRedView.isOpaque = false
    view.addSubview(yellowRedView)
  }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ClippedBorderedViewController()

