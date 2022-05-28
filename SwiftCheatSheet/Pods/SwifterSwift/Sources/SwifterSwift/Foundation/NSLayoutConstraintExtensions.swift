// NSLayoutConstraintExtensions.swift - Copyright © 2022 SwifterSwift

#if canImport(UIKit)
import UIKit

public extension NSLayoutConstraint {
    /// SwifterSwift: Returns the constraint sender with the passed priority.
    ///
    /// - Parameter priority: The priority to be set.
    /// - Returns: The sended constraint adjusted with the new priority.
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        // <https://www.avanderlee.com/swift/auto-layout-programmatically/>
        self.priority = priority
        return self
    }
}

#endif
