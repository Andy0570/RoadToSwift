// NotificationExtensions.swift - Copyright © 2022 SwifterSwift

#if canImport(UIKit)
import UIKit

public extension Notification {
    func keyboardHeight() -> CGFloat {
        guard let userInfo = userInfo, let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }

        let size = value.cgRectValue.size
        return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
    }
}

#endif
