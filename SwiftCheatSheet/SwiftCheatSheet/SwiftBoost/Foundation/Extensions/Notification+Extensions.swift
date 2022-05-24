//
//  Notification+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/26.
//

import UIKit

extension Notification {
    func keyboardHeight() -> CGFloat {
        guard let userInfo = userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }

        let size = value.cgRectValue.size
        print("size: \(size)")
        return UIInterfaceOrientation.portrait.isLandscape ? size.width : size.height
    }
}
