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

@IBDesignable class CounterView: UIView {
    private struct Constants {
        static let numberOfGlasses = 8 // 每天喝水的目标数量
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76 // 弧线宽度

        static var halfOfLineWidth: CGFloat {
          return lineWidth / 2
        }
    }

    // 跟踪当前喝水数量
    @IBInspectable var counter: Int = 5 {
        didSet {
            if counter <= Constants.numberOfGlasses {
                // 视图需要刷新
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = .blue
    @IBInspectable var counterColor: UIColor = .orange

    override func draw(_ rect: CGRect) {
        /************************ 绘制圆弧 ************************/

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = max(bounds.width, bounds.height)
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4

        let path = UIBezierPath(arcCenter: center, radius: radius / 2 - Constants.arcWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()

        /************************ 绘制轮廓 ************************/

        // 1.首先计算两个弧度差，并确保它是正数
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        // 然后计算一杯水的弧度
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        // 然后乘以实际喝水的杯数 = 圆弧结束的角度
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle

        // 2.画外弧
        let outerArcRadius = bounds.width / 2 - Constants.halfOfLineWidth
        let outlinePath = UIBezierPath(arcCenter: center, radius: outerArcRadius, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)

        // 3.画内弧，与外弧角度相同，但反向绘制
        let innerArcRadius = bounds.width / 2 - Constants.arcWidth + Constants.halfOfLineWidth
        outlinePath.addArc(withCenter: center, radius: innerArcRadius, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)

        // 4.关闭贝塞尔曲线路径
        outlinePath.close()

        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()

        /************************ 绘制标记 ************************/

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        // 1.执行绘制之前，先保存原始状态
        context.saveGState()
        outlineColor.setFill()

        let markerWidth: CGFloat = 5.0
        let markerHeight: CGFloat = 10.0

        // 2.位于左上角的标记矩形
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerHeight))

        // 3.将上下文的左上角移动到之前的中心点
        context.translateBy(x: rect.width / 2, y: rect.height / 2)

        for i in 1...Constants.numberOfGlasses {
            // 4.保存居中的上下文
            context.saveGState()
            // 5.计算旋转角度
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
            // 旋转和平移
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2 - markerHeight)

            // 6.填充标记矩形
            markerPath.fill()
            // 7.为下一次旋转恢复居中的上下文
            context.restoreGState()
        }

        // 8. Restore the original state in case of more painting
        context.restoreGState()
    }
}
