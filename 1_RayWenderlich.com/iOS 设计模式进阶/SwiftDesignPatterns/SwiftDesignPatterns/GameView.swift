//
//  GameView.swift
//  SwiftDesignPatterns
//
//  Created by Weslie on 2018/12/19.
//  Copyright © 2018 Weslie. All rights reserved.
//

import UIKit

class GameView: UIView {
	var score: Int = 0 {
		didSet {
			scoreLabel.attributedText = attributedTextForScore(aScore: score)
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	let padding: CGFloat = 20.0
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		backgroundColor = UIColor(red: 0x7c/255.0, green: 0xbb/255.0, blue: 0xf2/255.0, alpha: 1)
		
		scoreLabel = UILabel(frame: CGRect.zero)
		scoreLabel.attributedText = attributedTextForScore(aScore: 0)
		addSubview(scoreLabel)
		scoreLabel.sizeToFit()
	}
	
	override func layoutSubviews() {
		scoreLabel.sizeToFit()
		scoreLabel.center.x = bounds.size.width / 2.0
		scoreLabel.frame.origin.y = padding
	}
	
	func sizeAvailableForShapes() -> CGSize {
		let topY    = scoreLabel.frame.maxY + padding
		let bottomY = bounds.size.height - padding
		let leftX  = padding
		let rightX = bounds.size.width - padding
		let smallestDimension = min(rightX - leftX, (bottomY - topY - 2 * padding) / 2.0)
		return CGSize(width: smallestDimension, height: smallestDimension)
	}
	
	func addShapeViews(newShapeViews: (ShapeView, ShapeView)) {
		shapeViews?.0.removeFromSuperview()
		shapeViews?.1.removeFromSuperview()
		
		shapeViews = newShapeViews
		
		newShapeViews.0.center.x = bounds.size.width / 2.0
		newShapeViews.0.center.y = center.y - padding - newShapeViews.0.frame.size.height / 2.0
		addSubview(newShapeViews.0)
		
		newShapeViews.1.center.x = bounds.size.width / 2.0
		newShapeViews.1.center.y = center.y + padding + newShapeViews.1.frame.size.height / 2.0
		addSubview(newShapeViews.1)
	}
	
	private final func attributedTextForScore(aScore: Int) -> NSAttributedString? {
		return NSAttributedString(string: "Score: \(aScore)",
			attributes: [ NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32),
						  NSAttributedString.Key.foregroundColor : aScore < 0 ? UIColor.red : UIColor.black])
	}
	
	private var scoreLabel: UILabel!
	private var shapeViews: (ShapeView, ShapeView)?
}

