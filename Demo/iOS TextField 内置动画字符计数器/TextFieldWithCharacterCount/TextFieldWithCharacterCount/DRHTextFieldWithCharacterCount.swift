//
//  DRHTextFieldWithCharacterCount.swift
//  TextFieldWithCharacterCount
//
//  Created by Qilin Hu on 2022/1/13.
//

import UIKit

@IBDesignable class DRHTextFieldWithCharacterCount: UITextField {

    fileprivate let countLabel = UILabel()

    @IBInspectable var lengthLimit: Int = 0
    @IBInspectable var countLabelTextColor: UIColor = UIColor.black

    override func awakeFromNib() {
        super.awakeFromNib()

        if lengthLimit > 0 {
            setCountLabel()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }

    fileprivate func setCountLabel() {
        rightViewMode = .always
        countLabel.font = font?.withSize(10)
        countLabel.textColor = countLabelTextColor
        countLabel.textAlignment = .left
        rightView = countLabel

        countLabel.text = initialCounterValue(text: text)
    }

    fileprivate func initialCounterValue(text: String?) -> String {
        if let text = text {
            return "\(text.count)/\(lengthLimit)"
        } else {
            return "0/\(lengthLimit)"
        }
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if lengthLimit > 0 {
            return CGRect(x: frame.width - 35, y: 0, width: 30, height: 30)
        } else {
            return CGRect.zero
        }
    }

    @objc func textDidChange(notification: Notification) {
        guard let text = self.text, lengthLimit != 0 else {
            return
        }

        // 判断是否存在 markedText，如果存在，则不进行字数统计和字符串截断
        guard self.markedTextRange == nil else {
            return
        }

        if text.count <= lengthLimit {
            countLabel.text = "\(text.count)/\(lengthLimit)"
        } else {
            // 记录当前光标的位置
            let targetPosition = self.offset(from: self.beginningOfDocument, to: self.selectedTextRange!.start)

            // 字符串截取
            let prefixIndex = text.index(text.startIndex, offsetBy: lengthLimit)
            self.text = String(text[..<prefixIndex])

            // 恢复光标位置
            if let targetPosition = self.position(from: self.beginningOfDocument, offset: targetPosition) {
                self.selectedTextRange = self.textRange(from: targetPosition, to: targetPosition)
            }

            countLabel.text = "\(lengthLimit)/\(lengthLimit)"
        }
    }
}
