//
//  UILabel+AppStyles.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit

enum LabelStyle {
    case title
    case body
}

extension UILabel {
    func style(_ labelStyle: LabelStyle) {
        switch labelStyle {
        case .title:
            font = .heavyFont(size: .regular)
            textColor = .label
        case .body:
            font = .regularFont(size: .small)
            textColor = .secondaryLabel
        }
    }
}
