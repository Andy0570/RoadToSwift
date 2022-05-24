//
//  UIBezierPath+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/14.
//

import UIKit

extension UIBezierPath {
    /// 生成等边三角形，▷
    /// - Parameters:
    ///   - triangleSideLength: 等边三角形的边长
    ///   - origin: 等边三角形的起点，左下角
    convenience init(triangleSideLength: Float, origin: CGPoint) {
        self.init()
        let squareRoot = Float(sqrt(3))
        let altitude = (squareRoot * triangleSideLength) / 2
        move(to: origin)
        addLine(to: CGPoint(x: CGFloat(triangleSideLength), y: origin.x))
        addLine(to: CGPoint(x: CGFloat(triangleSideLength / 2), y: CGFloat(altitude)))
        close()
    }
}
