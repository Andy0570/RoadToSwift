//
//  OneWayPanGestureRecognizer.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

enum OneWayPanGestureDirection {
    case up
    case down
}

class OneWayPanGestureRecognizer: UIPanGestureRecognizer {
    var drag: Bool = false
    var moveX: Int = 0
    var moveY: Int = 0
    var direction: OneWayPanGestureDirection = .down

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        if state == .failed {
            return
        }

        let touch: UITouch = touches.first! as UITouch
        let currentPoint: CGPoint = touch.location(in: view)
        let previousPoint: CGPoint = touch.previousLocation(in: view)
        moveX += Int(previousPoint.x - currentPoint.x)
        moveY += Int(previousPoint.y - currentPoint.y)

        if !drag {
            if moveY == 0 {
                drag = false
            } else if (direction == .down && moveY > 0) || (direction == .up && moveY < 0) {
                state = .failed
            } else {
                drag = true
            }
        }
    }

    override func reset() {
        super.reset()
        drag = false
        moveX = 0
        moveY = 0
    }
}
