//
//  Shape.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

import UIKit

// 抽象类，可点击图形的基本模型
class Shape {
    // MARK: 雇工模式
    // 雇工模式（Employee Pattern）也叫作仆人模式（Servant Pattern），属于行为型设计模式。
    // 它为一组类提供通用的功能，而不需要类实现这些功能，也是命令模式的一种扩展。

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
