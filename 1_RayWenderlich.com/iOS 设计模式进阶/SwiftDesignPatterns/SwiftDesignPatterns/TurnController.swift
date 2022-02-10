//
//  TurnController.swift
//  SwiftDesignPatterns
//
//  Created by Qilin Hu on 2022/2/10.
//  Copyright © 2022 Weslie. All rights reserved.
//

import Foundation

// 控制玩家的回合顺序
class TurnController {
    // 存储当前和过去的回合
    var currentTurn: Turn?
    var pastTurns: [Turn] = [Turn]()

    private let turnStrategy: TurnStrategy

    private var scorer: Scorer

    init(turnStrategy: TurnStrategy) {
        self.turnStrategy = turnStrategy
        self.scorer = MatchScorer()
        self.scorer.nextScorer = StreakScorer()
    }

    func beginNextTurn() -> (ShapeView, ShapeView) {
        // 使用策略生成 ShapeView 对象，以便玩家可以开始新的回合
        let shapeViews = turnStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns: pastTurns)
        currentTurn = Turn(shapes: [shapeViews.0.shape, shapeViews.1.shape])
        return shapeViews
    }

    // 在玩家点击形状后记录回合结束，并根据该回合玩家点击的形状计算得分
    func endTurnWithTappedShape(tappedShape: Shape) -> Int {
        currentTurn!.turnCompletedWithTappedShape(tappedShape: tappedShape)
        pastTurns.append(currentTurn!)

        // 需要使用 reversed() 反向遍历，因为计算得分的顺序和回合进行的顺序相反。
        let scoreIncrement = scorer.computeScoreIncrement(pastTurns.reversed())
        return scoreIncrement
    }

}
