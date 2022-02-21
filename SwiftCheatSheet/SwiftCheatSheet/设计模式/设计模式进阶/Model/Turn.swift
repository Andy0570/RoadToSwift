//
//  Turn.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

import Foundation

// MARK: 依赖注入模式

// Turn 代表一轮游戏回合
class Turn {
    // 存储玩家每一个回合看到的形状，以及是否点击了较大的形状
    let shapes: [Shape]
    var matched: Bool?

    init(shapes: [Shape]) {
        self.shapes = shapes
    }

    // 玩家点击形状后，记录该回合结束
    func turnCompletedWithTappedShape(tappedShape: Shape) {
        // 记录最高分
        // 比较 Shape 形状的面积大小计算得分
        let maxArea = shapes.reduce(0) { $0 > $1.area ? $0 : $1.area }
        matched = tappedShape.area >= maxArea
    }
}
