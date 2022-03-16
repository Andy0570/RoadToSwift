//
//  TurnStrategy.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/21.
//

import Foundation

// MARK: 策略模式
// 根据程序在运行时确定的内容来设计算法
// 通过对每个策略必须实现的行为的抽象声明来定义一系列算法，这使得该族内的算法可以互换。

protocol TurnStrategy {
    // 获取游戏中上一个回合的数组，返回下一个回合的形状视图
    func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView)
}

// 基本策略，描述本回合要使用的形状
class BasicTurnStrategy: TurnStrategy {
    // MARK: 依赖注入，此策略不关心它使用的是哪一个（正方形/圆形）工厂或者建造者
    // 它需要的属性是由外部创建并在初始化实例时赋值注入，而不是在类内部创建的，因此称之为依赖注入。

    // 存储属性，构造 Shape 模型的抽象工厂
    let shapeFactory: ShapeFactory
    // 存储属性，Builder 构造器在内部构造 ShapeView 视图，同时统一配置视图外观
    let shapeViewBuilder: ShapeViewBuilder

    init(shapeFactory: ShapeFactory, shapeViewBuilder: ShapeViewBuilder) {
        self.shapeFactory = shapeFactory
        self.shapeViewBuilder = shapeViewBuilder
    }

    func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView) {
        // shapeFactory.createShapes() 方法通过抽象工厂创建并返回 Shape 模型
        return shapeViewBuilder.buildShapeViewsForShapes(shapes: shapeFactory.createShapes())
    }
}

// 组合模式，随机策略，描述本回合要使用哪种基本策略
class RandomTurnStrategy: TurnStrategy {
    let firstStrategy: TurnStrategy
    let secondStrategy: TurnStrategy

    init(firstStrategy: TurnStrategy, secondStrategy: TurnStrategy) {
        self.firstStrategy = firstStrategy
        self.secondStrategy = secondStrategy
    }

    func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView) {
        if Utils.randomBetweenLower(lower: 0.0, andUpper: 100.0) < 50.0 {
            return firstStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns: pastTurns)
        } else {
            return secondStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns: pastTurns)
        }
    }
}
