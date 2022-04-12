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

@IBDesignable class GraphView: UIView {
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }

    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green

    // 每周喝水的样本数据
    var graphPoints: [Int] = [4, 2, 6, 4, 5, 8, 3]

    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height

        /************************ 绘制包含圆角的渐变 ************************/

        /// Create paths to clip the drawing area 模拟圆角裁剪
        /// 注意：使用 Core Graphics 绘制静态视图通常足够快，但是如果你的视图四处移动或需要频繁重绘，你应该使用 Core Animation 框架。
        /// Core Animation 进行了优化，以便 GPU（而不是 CPU）处理大部分任务。相反，CPU 处理由 Core Graphics 在 draw (_:)
        /// 中执行的视图绘制。如果你使用 Core Animation，你需要使用 CALayer 的 cornerRadius 属性。
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constants.cornerRadiusSize)
        path.addClip()

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        // 定义背景渐变
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) else {
            return
        }
        // 绘制背景渐变
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

        /************************ 绘制折线 ************************/

        // 计算 X 点坐标（|-margin-2-X-spacing-X...X-2-margin-|）
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            // 计算点之间的距离
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }

        // 计算 Y 点坐标
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        guard let maxValue = graphPoints.max() else {
            return
        }
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            // 因为 Core Graphics 中的原点位于左上角，而我们需要从左下角作为起点绘制
            return graphHeight + topBorder - yPoint // 翻转图表
        }

        // 添加线条
        UIColor.white.setFill()
        UIColor.white.setStroke()
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))

        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }

        /************************ 绘制折线图下方的裁剪渐变 ************************/

        // Create the clipping path for the graph gradient
        // 在绘制 clipped gradient 之前，添加裁剪路径

        // 1.保存上下文的状态，以在新的 graphics state 中添加 clipping path
        context.saveGState()

        // 2.复制 path 路径
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
            return
        }

        // 3.将线条添加到复制的路径以完成剪辑区域
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()

        // 4.将剪切路径添加到上下文
        clippingPath.addClip()

        // 添加 clipped gradient
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)

        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context.restoreGState()

        // 在 clipped gradient 顶部绘制线条
        graphPath.lineWidth = 2.0
        graphPath.stroke()

        /************************ 绘制数据点 ************************/

        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            let size = CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: size))
            circle.fill()
        }

        /************************ 绘制三条水平线 ************************/

        let linePath = UIBezierPath()

        // Top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))

        // Center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight / 2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight / 2 + topBorder))

        // Bottom line
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()

        linePath.lineWidth = 1.0
        linePath.stroke()
    }
}
