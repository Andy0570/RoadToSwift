//
//  UIFont+AppFonts.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit

enum FontSize: CGFloat {
    case small = 14.0
    case regular = 16.0
}

extension UIFont {
    
    static func regularFont(size: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue)
    }
    
    static func boldFont(size: FontSize) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size.rawValue)
    }
    
    static func heavyFont(size: FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue, weight: .heavy)
    }
}

