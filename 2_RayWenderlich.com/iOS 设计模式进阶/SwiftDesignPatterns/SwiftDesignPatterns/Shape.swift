//
//  Shape.swift
//  SwiftDesignPatterns
//
//  Created by Weslie on 2018/12/19.
//  Copyright © 2018 Weslie. All rights reserved.
//

import UIKit

// 抽象类，可点击图形的基本模型
class Shape {
    // 计算属性，计算并返回图形的面积
    var area: CGFloat { return 0 }
}

// 具体类，正方形
class SquareShape: Shape {
    // 存储属性，正方形的边长
	var sideLength: CGFloat!
    // 计算属性，正方形的面积
    override var area: CGFloat { return sideLength * sideLength }
}

// 具体类，圆形
class CircleShape: Shape {
    // 存储属性，圆的直径
    var diameter: CGFloat!
    // 计算属性，圆的面积
    override var area: CGFloat { return CGFloat.pi * diameter * diameter / 4.0 }

}
