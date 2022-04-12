/// Copyright (c) 2018 Razeware LLC
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

class CustomFooter: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        // 注意：当视图完全或部分透明时，不应使用 isOpaque 属性。否则，结果可能无法预测。
        isOpaque = true
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let footerRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        var arcRect = footerRect
        arcRect.size.height = 8

        context.saveGState()
        // 添加圆弧并基于该圆弧路径裁剪
        let arcPath = CGContext.createArcPathFromBottom(of: arcRect, arcHeight: 4, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 360))
        context.addPath(arcPath)
        context.clip()

        // 添加浅灰色->深灰色渐变
        context.drawLinearGradient(rect: footerRect, startColor: .rwLightGray, endColor: .rwDarkGray)
        context.restoreGState()

        // 设置裁剪，以便 Core Graphics 仅在 footer 区域之外的部分绘制
        context.addRect(footerRect)
        context.addPath(arcPath)
        context.clip(using: .evenOdd)
        // 添加阴影
        context.addPath(arcPath)
        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3, color: UIColor.rwShadow.cgColor)
        context.fillPath()
    }
}
