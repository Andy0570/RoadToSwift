//
//  UILayoutPriorityExtension.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

extension UILayoutPriority {
    /// Creates a priority which is almost required, but not 100%.
    static var almostRequired: UILayoutPriority {
        // <https://www.avanderlee.com/swift/auto-layout-programmatically/>
        return UILayoutPriority(rawValue: 999)
    }

    /// Creates a priority which is not required at all.
    static var notRequired: UILayoutPriority {
        // <https://www.avanderlee.com/swift/auto-layout-programmatically/>
        return UILayoutPriority(rawValue: 0)
    }
}
