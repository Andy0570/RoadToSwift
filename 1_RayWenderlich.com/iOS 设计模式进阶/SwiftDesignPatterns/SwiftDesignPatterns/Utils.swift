//
//  Utils.swift
//  SwiftDesignPatterns
//
//  Created by Weslie on 2018/12/19.
//  Copyright © 2018 Weslie. All rights reserved.
//

import UIKit

class Utils {
	class func randomBetweenLower(lower: CGFloat, andUpper: CGFloat) -> CGFloat {
		return lower + CGFloat(arc4random_uniform(101)) / 100.0 * (andUpper - lower)
	}
}
