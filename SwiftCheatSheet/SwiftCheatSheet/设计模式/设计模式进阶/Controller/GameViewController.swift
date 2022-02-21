//
//  GameViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

/**
 参考：
 * [Intermediate Design Patterns in Swift](https://www.raywenderlich.com/2102-intermediate-design-patterns-in-swift)
 * [iOS 设计模式进阶](https://juejin.cn/post/6844903772804628494)
 */

import UIKit

class GameViewController: UIViewController {

    private var gameView: GameView { return view as! GameView }
    private var turnController: TurnController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化抽象工厂

        // 正方形
        // 在 [0.3, 0.8] 区间内取边长绘制正方形，绘制的图形可以在任何屏幕尺寸下缩放。
        let squareShapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
        // 由 GameView 确定哪种尺寸的图形适合当前屏幕。
        let squareShapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
        let squareShapeViewBuilder = shapeViewBuilderForFactory(shapeViewFactory: squareShapeViewFactory)
        // 创建正方形的策略
        let squareTurnStrategy = BasicTurnStrategy(shapeFactory: squareShapeFactory, shapeViewBuilder: squareShapeViewBuilder)

        // 圆形
        let circleShapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
        let circleShapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
        let circleShapeViewBuilder = shapeViewBuilderForFactory(shapeViewFactory: circleShapeViewFactory)
        // 创建圆形的策略
        let circleTurnStrategy = BasicTurnStrategy(shapeFactory: circleShapeFactory, shapeViewBuilder: circleShapeViewBuilder)

        // 随机策略
        let randomTurnStrategy = RandomTurnStrategy(firstStrategy: squareTurnStrategy, secondStrategy: circleTurnStrategy)

        // 创建「回合控制器」来使用随机策略
        turnController = TurnController(turnStrategy: randomTurnStrategy)

        // 当 GameView 加载后开始新的一局游戏
        beginNextTurn()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // 封装代码，通过 ShapeViewFactory 创建 ShapeViewBuilder
    private func shapeViewBuilderForFactory(shapeViewFactory: ShapeViewFactory) -> ShapeViewBuilder {
        let shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
        shapeViewBuilder.fillColor = UIColor.brown
        shapeViewBuilder.outlineColor = UIColor.orange
        return shapeViewBuilder
    }

    private func beginNextTurn() {


        let shapeViews = turnController.beginNextTurn()

        shapeViews.0.tapHandler = { tappedView in
            self.gameView.score += self.turnController.endTurnWithTappedShape(tappedShape: tappedView.shape)
            self.beginNextTurn()
        }
        shapeViews.1.tapHandler = shapeViews.0.tapHandler

        gameView.addShapeViews(newShapeViews: shapeViews)
    }



}
