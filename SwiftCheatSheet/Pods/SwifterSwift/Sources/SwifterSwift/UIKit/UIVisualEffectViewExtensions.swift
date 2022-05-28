// UIVisualEffectViewExtensions.swift - Copyright © 2022 SwifterSwift

#if canImport(UIKit)
import UIKit

// MARK: - Initializers

public extension UIVisualEffectView {
    /// SwifterSwift: initialize blur effect with style
    convenience init(style: UIBlurEffect.Style) {
        let effect = UIBlurEffect(style: style)
        self.init(effect: effect)
    }
}

#endif
