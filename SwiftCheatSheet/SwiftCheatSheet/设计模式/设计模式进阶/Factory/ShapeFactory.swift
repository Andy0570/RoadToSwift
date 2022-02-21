//
//  ShapeFactory.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

import UIKit

// MARK: 抽象工厂模式

protocol ShapeFactory {
    func createShapes() -> (Shape, Shape)
}

class SquareShapeFactory: ShapeFactory {
    // 最小比例
    var minProportion: CGFloat
    // 最大比例
    var maxProportion: CGFloat

    init(minProportion: CGFloat, maxProportion: CGFloat) {
        self.minProportion = minProportion
        self.maxProportion = maxProportion
    }

    func createShapes() -> (Shape, Shape) {
        // 创建具有随机尺寸的第一个正方形
        let shape1 = SquareShape()
        shape1.sideLength = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

        // 创建具有随机尺寸的第二个正方形
        let shape2 = SquareShape()
        shape2.sideLength = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

        return (shape1, shape2)
    }
}

class CircleShapeFactory: ShapeFactory {
    // 最小比例
    var minProportion: CGFloat
    // 最大比例
    var maxProportion: CGFloat

    init(minProportion: CGFloat, maxProportion: CGFloat) {
        self.minProportion = minProportion
        self.maxProportion = maxProportion
    }

    func createShapes() -> (Shape, Shape) {
        let shape1 = CircleShape()
        shape1.diameter = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

        let shape2 = CircleShape()
        shape2.diameter = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

        return (shape1, shape2)
    }
}
