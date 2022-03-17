//
//  ShapeViewFactory.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

import UIKit

// MARK: 抽象工厂模式

protocol ShapeViewFactory {
    // 创建形状的边界尺寸
    var size: CGSize { get set }
    // 工厂方法，通过 Shape 模型生成 ShapeView 视图
    // 💡 工厂方法要以 make 开头
    func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView)
}

class SquareShapeViewFactory: ShapeViewFactory {
    var size: CGSize

    // 默认使用最大尺寸来初始化工厂
    init(size: CGSize) {
        self.size = size
    }

    func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
        guard let squareShape1 = shapes.0 as? SquareShape,
            let squareShape2 = shapes.1 as? SquareShape else {
            fatalError("向下类型转换发生错误")
        }

        // 构造 shapeView1
        let shapeView1 = SquareShapeView(frame: CGRect(
            x: 0,
            y: 0,
            width: squareShape1.sideLength * size.width,
            height: squareShape1.sideLength * size.height))
        shapeView1.shape = squareShape1

        // 构造 shapeView2
        let shapeView2 = SquareShapeView(frame: CGRect(
            x: 0,
            y: 0,
            width: squareShape2.sideLength * size.width,
            height: squareShape2.sideLength * size.height))
        shapeView2.shape = squareShape2

        return (shapeView1, shapeView2)
    }
}

class CircleShapeViewFactory: ShapeViewFactory {
    var size: CGSize

    // 默认使用最大尺寸来初始化工厂
    init(size: CGSize) {
        self.size = size
    }

    func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
        guard let circleShape1 = shapes.0 as? CircleShape,
            let circleShape2 = shapes.1 as? CircleShape else {
            fatalError("向下类型转换发生错误")
        }

        let shapeView1 = CircleShapeView(frame: CGRect(
            x: 0,
            y: 0,
            width: circleShape1.diameter * size.width,
            height: circleShape1.diameter * size.height))
        shapeView1.shape = circleShape1

        let shapeView2 = CircleShapeView(frame: CGRect(
            x: 0,
            y: 0,
            width: circleShape2.diameter * size.width,
            height: circleShape2.diameter * size.height))
        shapeView2.shape = circleShape2

        return (shapeView1, shapeView2)
    }
}
