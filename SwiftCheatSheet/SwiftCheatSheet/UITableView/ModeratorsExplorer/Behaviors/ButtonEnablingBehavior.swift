//
//  ButtonEnablingBehavior.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import UIKit

// 根据页面中 UITextField 的文本内容，自动更新按钮的 enable 状态
final class ButtonEnablingBehavior: NSObject {
    let textFields: [UITextField]
    let onChange: (Bool) -> Void

    init(textFields: [UITextField], onChange: @escaping (Bool) -> Void) {
        self.textFields = textFields
        self.onChange = onChange
        super.init()
        setup()
    }

    private func setup() {
        textFields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        onChange(false)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        var enable = true
        for textField in textFields {
            guard let text = textField.text, !text.isDigits else {
                enable = false
                break
            }
            onChange(enable)
        }
    }
}
