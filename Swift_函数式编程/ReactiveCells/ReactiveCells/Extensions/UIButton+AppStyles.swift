//
//  UIButton+AppStyles.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit

enum ButtonStyle {
    case red
}

enum ButtonSize {
    case big
}

extension UIButton {
    func style(_ style: ButtonStyle, size: ButtonSize) {
        let normalColor = colorFor(style)
        let darkerColor = normalColor.darker()
        let disabledColor = normalColor.withAlphaComponent(0.5)
        
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18)
        setBackgroundImage(UIImage(color: normalColor), for: .normal)
        setBackgroundImage(UIImage(color: darkerColor), for: .selected)
        setBackgroundImage(UIImage(color: disabledColor), for: .disabled)
        setTitleColor(.white, for: .normal)
        layer.borderColor = darkerColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        switch size {
        case .big:
            heightAnchor.constraint(equalToConstant: 54).isActive = true
            titleLabel?.font = .heavyFont(size: .regular)
        }
    }
    
    func colorFor(_ style: ButtonStyle) -> UIColor {
        switch style {
        case .red:
            return .cartRed
        }
    }
}

