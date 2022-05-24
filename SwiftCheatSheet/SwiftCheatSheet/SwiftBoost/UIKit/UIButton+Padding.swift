//
//  UIButton+Padding.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import UIKit

// Usage:
// class PaddedButton: UIButton {
//    override var intrinsicContentSize: CGSize {
//        super.intrinsicContentSize.addingPadding(width: 60, height: 20)
//    }
// }
extension UIButton {
    func addingPadding(width: CGFloat, height: CGFloat) -> CGSize {
        CGSize(width: self.width + width, height: self.height + height)
    }

    // use SFSymbols as an image for your UIButton
    // iconName - SFSymbol Name
    // size - Size of the Symbol in points
    // scale - .small, .medium, .large
    // weight - .ultralight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black
    // tintColor - Color of the Symbol
    // backgroundColor - Background color of the button
    func setSFSymbol(iconName: String, size: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, tintColor: UIColor, backgroundColor: UIColor) {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        let buttonImage = UIImage(systemName: iconName, withConfiguration: symbolConfiguration)
        self.setImage(buttonImage, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }
}
