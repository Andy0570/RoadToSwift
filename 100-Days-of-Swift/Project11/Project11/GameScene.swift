//
//  GameScene.swift
//  Project11
//
//  Created by Qilin Hu on 2021/12/29.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // 通过 SKSpriteNode 加载图片
        let background = SKSpriteNode(imageNamed: "background@2x.jpg")
        // 设置中心点坐标
        background.position = CGPoint(x: 375, y: 667)
        // 混合模式设置为 .replace 表示直接绘制，忽略任何alpha值
        background.blendMode = .replace
        // 把背景图片添加到场景的最底层
        background.zPosition = -1
        addChild(background)
        
        // 为整个游戏场景添加一个物理体（physicsBody），充当“容器”作用
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 187, y: 0))
        makeBouncer(at: CGPoint(x: 375, y: 0))
        makeBouncer(at: CGPoint(x: 562, y: 0))
        makeBouncer(at: CGPoint(x: 750, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 在触摸位置添加一个 64*64 大小的红色盒子
//        if let touch = touches.first {
//            let location = touch.location(in: self)
//            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
//            // 为盒子添加一个物理体（physicsBody），尺寸与盒子本身大小相同
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
//            box.position = location
//            addChild(box)
//        }
        
        // 将盒子替换为球
        if let touch = touches.first {
            let ball = SKSpriteNode(imageNamed: "ballRed")
            // 为球添加圆形物理体（physicsBody）
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4 // 设置物理弹性（0~1）
            ball.position = touch.location(in: self)
            addChild(ball)
        }
        
    }
    
    // 在场景中添加固定位置的物理球
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        // 水平方向上位于场景的底部边缘
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // 当该物理体与其他物体发生碰撞时，不会移动
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }

        slotBase.position = position
        slotGlow.position = position

        addChild(slotBase)
        addChild(slotGlow)
        
        // 在10秒内将节点旋转180度
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
}
