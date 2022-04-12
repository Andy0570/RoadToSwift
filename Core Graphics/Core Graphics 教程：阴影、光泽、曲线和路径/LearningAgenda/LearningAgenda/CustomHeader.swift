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

class CustomHeader: UIView {
    @IBOutlet public var titleLabel: UILabel!

    var startColor = UIColor.rwLightBlue
    var endColor = UIColor.rwDarkBlue
    // 提示：CustomHeader 高 50pt，40pt 显示 彩色文本，10pt 显示阴影
    var coloredBoxHeight: CGFloat = 40

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        // 渐变区域 rect: (0, 0, width, 40)
        var coloredBoxRect = bounds
        coloredBoxRect.size.height = coloredBoxHeight

        // 阴影区域 rect: (0, 40, width, 10)
        var paperRect = bounds
        paperRect.origin.y += coloredBoxHeight
        paperRect.size.height = bounds.height - coloredBoxHeight

        // 添加阴影
        context.saveGState()
        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3.0, color: UIColor.rwShadow.cgColor)
        context.setFillColor(startColor.cgColor)
        context.fill(coloredBoxRect)
        context.restoreGState()

        // 添加光泽效果
        context.drawGlossAndGradient(rect: coloredBoxRect, startColor: startColor, endColor: endColor)

        // 添加深色边框
        context.setStrokeColor(endColor.cgColor)
        context.setLineWidth(1)
        context.stroke(coloredBoxRect.rectFor1PxStroke())
    }

    class func loadViewFromNib() -> CustomHeader? {
        let nib = UINib(nibName: "CustomHeader", bundle: nil)
        return nib.instantiate(withOwner: CustomHeader()).first as? CustomHeader
    }
}
