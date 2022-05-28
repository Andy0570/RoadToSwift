// UILayoutPriorityExtensions.swift - Copyright 2020 SwifterSwift

#if os(iOS) || os(tvOS)
import UIKit

// MARK: - Initializers

extension UILayoutPriority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    /// SwifterSwift: Creates a priority which is almost required, but not 100%.
    static var almostRequired: UILayoutPriority {
        // <https://www.avanderlee.com/swift/auto-layout-programmatically/>
        return UILayoutPriority(rawValue: 999)
    }

    /// SwifterSwift: Creates a priority which is not required at all.
    static var notRequired: UILayoutPriority {
        // <https://www.avanderlee.com/swift/auto-layout-programmatically/>
        return UILayoutPriority(rawValue: 0)
    }

    /// SwifterSwift: Initialize `UILayoutPriority` with a float literal.
    ///
    ///     constraint.priority = 0.5
    ///
    /// - Parameter value: The float value of the constraint.
    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }

    /// SwifterSwift: Initialize `UILayoutPriority` with an integer literal.
    ///
    ///     constraint.priority = 5
    ///
    /// - Parameter value: The integer value of the constraint.
    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }
}

#endif
