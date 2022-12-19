//
//  ShapeViewBuilder.swift
//  SwiftDesignPatterns
//
//  Created by Qilin Hu on 2022/2/10.
//  Copyright © 2022 Weslie. All rights reserved.
//

import UIKit

// MARK: Builder 模式

class ShapeViewBuilder {
    
    // 存储配置 ShapeView 的填充属性
    var showFill = true
    var fillColor = UIColor.orange

    // 存储配置 ShapeView 的描边属性
    var showOutline = true
    var outlineColor = UIColor.gray

    // 私有存储属性，构造 ShapeView 视图的抽象工厂
    private var shapeViewFactory: ShapeViewFactory

    init(shapeViewFactory: ShapeViewFactory) {
        self.shapeViewFactory = shapeViewFactory
    }

    func buildShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
        // 通过抽象工厂创建并返回 ShapeView 视图
        let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes: shapes)
        configureShapeView(shapeView: shapeViews.0)
        configureShapeView(shapeView: shapeViews.1)
        return shapeViews
    }

    private func configureShapeView(shapeView: ShapeView) {
        shapeView.showFill = showFill
        shapeView.fillColor = fillColor
        shapeView.showOutline = showOutline
        shapeView.outlineColor = outlineColor
    }
}
