//
//  ShapeView.swift
//  SwiftDesignPatterns
//
//  Created by Weslie on 2018/12/19.
//  Copyright © 2018 Weslie. All rights reserved.
//

import UIKit

class ShapeView: UIView {
	var shape: Shape!

    // 边框宽度的一半
    let halfLineWidth: CGFloat = 3.0
	
    // 是否显示填充色
	var showFill: Bool = true {
		didSet {
			setNeedsDisplay()
		}
	}
	var fillColor: UIColor = UIColor.orange {
		didSet {
			setNeedsDisplay()
		}
	}
	
    // 是否显示边框
	var showOutline: Bool = true {
		didSet {
			setNeedsDisplay()
		}
	}
	var outlineColor: UIColor = UIColor.gray {
		didSet {
			setNeedsDisplay()
		}
	}
	
    // 处理点击事件的闭包
	var tapHandler: ((ShapeView) -> ())?

	override init(frame: CGRect) {
		super.init(frame: frame)
		
        // 单击手势识别器
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapRecognizer)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    // MARK: - Actions

    // 检测到单击手势时，调用 tapHandler 闭包
	@objc func handleTap() {
		tapHandler?(self)
	}

}

// 具体类，正方形视图
class SquareShapeView: ShapeView {
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
        // 使用填充颜色填充视图
		if showFill {
			fillColor.setFill()
			let fillPath = UIBezierPath(rect: bounds)
			fillPath.fill()
		}
		
        // 使用轮廓颜色显示边框
		if showOutline {
			outlineColor.setStroke()
            
            // 由于 iOS 是以 position 为中心绘制线条的，因此我们在描边路径时需要从 view 的 bounds 里减去 halfLineWidth
			let outlinePath = UIBezierPath(rect: CGRect(
                x: halfLineWidth,
                y: halfLineWidth,
                width: bounds.size.width - 2 * halfLineWidth,
                height: bounds.size.height - 2 * halfLineWidth))
			outlinePath.lineWidth = 2.0 * halfLineWidth
			outlinePath.stroke()
		}
	}
}

// 具体类，圆形
class CircleShapeView: ShapeView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        // 由于圆无法填充其 view 的 bounds，因此要告诉 UIView 该 view 是透明的。
        self.isOpaque = false
        // 由于视图是透明的，因此应该在 bounds 更改时进行重绘
        self.contentMode = UIView.ContentMode.redraw
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // 使用填充颜色填充视图
        if showFill {
            fillColor.setFill()
            let fillPath = UIBezierPath(ovalIn: self.bounds)
            fillPath.fill()
        }

        // 使用轮廓颜色显示边框
        if showOutline {
            outlineColor.setStroke()
            let outlinePath = UIBezierPath(ovalIn: CGRect(
                x: halfLineWidth,
                y: halfLineWidth,
                width: bounds.size.width - 2 * halfLineWidth,
                height: bounds.size.height - 2 * halfLineWidth))
            outlinePath.lineWidth = 2.0 * halfLineWidth
            outlinePath.stroke()
        }
    }
}
