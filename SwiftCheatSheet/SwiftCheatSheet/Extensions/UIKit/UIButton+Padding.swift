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
    func setSFSymbol(iconName: String, size: CGFloat, weight: UIImage.SymbolWeight,
                     scale: UIImage.SymbolScale, tintColor: UIColor, backgroundColor: UIColor) {
      let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
      let buttonImage = UIImage(systemName: iconName, withConfiguration: symbolConfiguration)
      self.setImage(buttonImage, for: .normal)
      self.tintColor = tintColor
      self.backgroundColor = backgroundColor
    }

    // 垂直分布按钮标题和图片
    // padding - the spacing between the Image and the Title
    func centerTitleVertically(padding: CGFloat = 12.0) {
        guard let imageViewSize = self.imageView?.frame.size, let titleLabelSize = self.titleLabel?.frame.size
            else {
                return
        }

        let totalHeight = imageViewSize.height + titleLabelSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height) / 2,
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )

        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
}
