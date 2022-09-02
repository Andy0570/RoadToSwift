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

@IBDesignable
class ChocolateButton: UIButton {
  override var isEnabled: Bool {
    didSet {
      updateAlphaForEnabledState()
    }
  }
  
  enum ButtonStyle {
    case
    standard,
    warning
  }
  
  ///Workaround for enum values not being IBInspectable.
  @IBInspectable var isStandard: Bool = false {
    didSet {
      if isStandard {
        style = .standard
      } else {
        style = .warning
      }
    }
  }
  
  private var style: ButtonStyle = .standard {
    didSet {
      updateBackgroundColorForCurrentType()
    }
  }
  
  
  //MARK: Initialization
  
  private func commonInit() {
    setTitleColor(.white, for: .normal)
    updateBackgroundColorForCurrentType()
    updateAlphaForEnabledState()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    commonInit()
  }
  
  func updateBackgroundColorForCurrentType() {
    switch style {
    case .standard:
      backgroundColor = .brown
    case .warning:
      backgroundColor = .red
    }
  }
  
  func updateAlphaForEnabledState() {
    if isEnabled {
      alpha = 1
    } else {
      alpha = 0.5
    }
  }
}
