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
/// THE SOFTWARE

import UIKit

extension CGPath {
    // 创建三角形路径
    static func triangle(in rect: CGRect) -> CGPath {
        let path = CGMutablePath()
        let top = CGPoint(x: rect.width / 2, y: 0)
        let bottomLeft = CGPoint(x: 0, y: rect.height)
        let bottomRight = CGPoint(x: rect.width, y: rect.height)
        path.addLines(between: [top, bottomLeft, bottomRight])
        path.closeSubpath()
        return path
    }
}

class PatternView: UIView {
    enum Constants {
        static let patternSize: CGFloat = 30.0
        static let patternRepeatCount: CGFloat = 2
    }

    enum PatternDirection: CaseIterable {
        case left
        case top
        case right
        case bottom
    }

    var fillColor: [CGFloat] = [1.0, 0.0, 0.0, 1.0]
    var direction: PatternDirection = .top

    // 设置填充颜色和方向
    init(fillColor: [CGFloat], direction: PatternDirection = .top) {
        self.fillColor = fillColor
        self.direction = direction
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    // 创建 Pattern cell，画三角形
    let drawTriangle: CGPatternDrawPatternCallback = { _, context in
        let trianglePath = CGPath.triangle(in:CGRect(x: 0, y: 0, width: Constants.patternSize, height: Constants.patternSize))
        context.addPath(trianglePath)
        context.fillPath()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        UIColor.white.setFill()
        context.fill(rect)

        var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawTriangle, releaseInfo: nil)

        let patternStepX = rect.width / Constants.patternRepeatCount
        let patternStepY = rect.height / Constants.patternRepeatCount

        let patternOffsetX = (patternStepX - Constants.patternSize) / 2.0
        let patternOffsetY = (patternStepY - Constants.patternSize) / 2.0

        var transform: CGAffineTransform
        switch direction {
        case .top:
            transform = .identity
        case .right:
            transform = CGAffineTransform(rotationAngle: 0.5 * .pi)
        case .bottom:
            transform = CGAffineTransform(rotationAngle: .pi)
        case .left:
            transform = CGAffineTransform(rotationAngle: 1.5 * .pi)
        }
        transform = transform.translatedBy(x: patternOffsetX, y: patternOffsetY)


        // 创建 Pattern
        guard let pattern = CGPattern(
            info: nil, // 指向要在 pattern 中使用的私有数据的指针，这里未使用，传 nil。
            bounds: CGRect(x: 0, y: 0, width: 20, height: 20), // pattern cell bounds
            matrix: transform, // 要应用变换的矩阵，如果不使用任何变化，传入单位矩阵
            xStep: patternStepX, // pattern cell 之间的水平距离
            yStep: patternStepY, // pattern cell 之间的垂直距离
            tiling: .constantSpacing, // 平铺，使用该技术解决用户空间单元和设备像素之间的差异
            isColored: false, // cell 绘制时是否应用颜色
            callbacks: &callbacks) else { // 回调，一个指向 CGPatternCallbacks 结构体的指针
                return
            }

        // 向 Core Graphics 提供 pattern color space 信息

        // 设置 pattern 颜色空间
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        guard let patternSpace = CGColorSpace(patternBaseSpace: baseSpace) else {
            return
        }
        context.setFillColorSpace(patternSpace)

        // 设置 graphics context 的填充模式
        context.setFillPattern(pattern, colorComponents: fillColor)
        context.fill(rect)
    }
}

