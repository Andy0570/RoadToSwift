/// Copyright (c) 2022 Razeware LLC
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

class StarshipsListCellBackground: UIView {
    override func draw(_ rect: CGRect) {
        // Core Graphics Context 代表绘画的画布
        // iOS 系统会在调用 draw(_:) 方法之前设置正确的 CGContext 上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        //context.setFillColor(UIColor.red.cgColor)
        //context.fill(bounds)

        // 添加渐变背景
        let backgroundRect = bounds
        context.drawLinearGradient(
            in: backgroundRect,
            startingWith: UIColor.starwarsSpaceBlue.cgColor,
            finishingWith: UIColor.black.cgColor
        )

        // 添加描边
        let strokeRect = backgroundRect.insetBy(dx: 4.5, dy: 4.5)
        context.setStrokeColor(UIColor.starwarsYellow.cgColor)
        context.setLineWidth(1)
        context.stroke(strokeRect)
    }
}
