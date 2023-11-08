//
//  UIView+AppStyles.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit

enum ViewStyle {
    case card
}

extension UIView {
    func style(_ viewStyle: ViewStyle) {
        switch viewStyle {
        case .card:
            layer.cornerRadius = 12
            backgroundColor = .secondarySystemBackground
        }
    }
}
