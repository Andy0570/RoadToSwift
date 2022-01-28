/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit

extension WhiteViewController {

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      
    triggerButton.backgroundColor = .black
    contentTextView.backgroundColor = .clear
    
    let titleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                           NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
    let storyAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                           NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)]
    
    let mutableAttrString = NSMutableAttributedString(string: "Beep boop, you've unlocked a new\n something or other that I call \"Tech Talk\"\n\n", attributes:titleAttributes)
    mutableAttrString.append(NSAttributedString(string: "Hi, I'm Pong. Tap the black dot,\n choose stuff you care about and close\n me when you're done. You're going to\n like me.\n\nTouch me.", attributes:storyAttributes))
    
    contentTextView.attributedText = mutableAttrString
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let buttonWidthHeight: CGFloat = 25.0
    let padding: CGFloat = 16.0
    let statusBarPadding: CGFloat = 20.0
    
    let constrainedSize = CGSize(width: view.bounds.width - 32.0 - buttonWidthHeight, height: view.bounds.height)
    let titleSize = contentTextView.sizeThatFits(constrainedSize)
    
    contentTextView.bounds = CGRect(x: 0, y: 0, width: titleSize.width, height: titleSize.height)
    
    contentTextView.center = CGPoint(x: 16 + contentTextView.bounds.width/2.0, y: 60 + contentTextView.bounds.height/2.0)
    
    triggerButton.layer.cornerRadius = buttonWidthHeight/2.0
    triggerButton.frame = CGRect(x: view.bounds.width - buttonWidthHeight - padding, y: padding + statusBarPadding, width: buttonWidthHeight, height: buttonWidthHeight)
  }
}

