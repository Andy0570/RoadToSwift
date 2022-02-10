//
//  Scorer.swift
//  SwiftDesignPatterns
//
//  Created by Qilin Hu on 2022/2/10.
//  Copyright © 2022 Weslie. All rights reserved.
//

import Foundation

// MARK: 责任链、命令和迭代器模式

// 使用 「命令」来确定一个回合的胜负，并计算游戏的分数
protocol Scorer {

    // MARK: 责任链模式
    var nextScorer: Scorer? { set get }

    // 计算回合得分，接收参数是一个可以用「迭代器」迭代的过去所有回合的集合
    func computeScoreIncrement<S>(_ pastTurnsReversed: S) -> Int where S: Sequence, Turn == S.Iterator.Element
}

class MatchScorer: Scorer {

    // 通过 nextScorer 属性实现了责任链模式
    var nextScorer: Scorer? = nil

    func computeScoreIncrement<S>(_ pastTurnsReversed: S) -> Int where S : Sequence, S.Element == Turn {
        var scoreIncrement: Int?

        // 使用迭代器迭代过去的回合
        for turn in pastTurnsReversed {
            if scoreIncrement == nil {
                // 获胜回合的得分 +1，失败回合的得分 -1
                scoreIncrement = turn.matched! ? 1: -1
                break
            }
        }

        return (scoreIncrement ?? 0) + (nextScorer?.computeScoreIncrement(pastTurnsReversed) ?? 0)
    }
}

class StreakScorer: Scorer {
    var nextScorer: Scorer? = nil

    func computeScoreIncrement<S>(_ pastTurnsReversed: S) -> Int where S : Sequence, S.Element == Turn {
        // 连续获胜的次数
        var streakLength = 0

        // 使用迭代器迭代过去的回合
        for turn in pastTurnsReversed {
            if turn.matched! {
                // 如果该回合获胜，则连续次数 +1
                streakLength += 1
            } else {
                break
            }
        }

        // 计算连胜奖励，连胜五场最多奖励 10 分！
        let streakBonus = streakLength >= 5 ? 10 : 0
        return streakBonus + (nextScorer?.computeScoreIncrement(pastTurnsReversed) ?? 0)
    }
}
