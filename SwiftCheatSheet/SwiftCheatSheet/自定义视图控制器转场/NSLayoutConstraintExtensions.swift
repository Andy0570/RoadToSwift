//
//  NSLayoutConstraintExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2023/4/10.
//

import UIKit

public extension NSLayoutConstraint {
    /// Returns the constraint sender with the passed priority.
    /// Reference: <https://www.avanderlee.com/swift/auto-layout-programmatically/>
    ///
    /// - Parameter priority: The priority to be set.
    /// - Returns: The sended constraint adjusted with the new priority.
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
