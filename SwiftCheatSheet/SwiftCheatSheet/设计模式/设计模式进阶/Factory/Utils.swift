//
//  Utils.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

import UIKit

class Utils {
    class func randomBetweenLower(lower: CGFloat, andUpper: CGFloat) -> CGFloat {
        return lower + CGFloat(arc4random_uniform(101)) / 100.0 * (andUpper - lower)
    }
}
