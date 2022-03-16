//
//  AttributedStringViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

/**
 使用 NSMutableAttributedString 和 NSAttributedString 实现多种字体、颜色、下划线、删除线、阴影等等。
 
 参考：<https://www.swiftdevcenter.com/nsmutableattributedstring-tutorial-by-example/>
 */

import UIKit

class AttributedStringViewController: UIViewController {
    let appRedColor = UIColor(red: 230.0 / 255.0, green: 51.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
    let appBlueColor = UIColor(red: 62.0 / 255.0, green: 62.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
    let appYellowColor = UIColor(red: 248.0 / 255.0, green: 175.0 / 255.0, blue: 0.0, alpha: 1.0)
    let darkOrangeColor = UIColor(red: 248.0 / 255.0, green: 150.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setFirstLabel()
        setSecondLable()
        setThirdLabel()
        setFourthLabel()
        setFifthLable()
    }

    // 颜色
    func setFirstLabel() {
        let text = "This is a colorful attributed string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: appRedColor, subString: "This")
        attributedText.apply(color: appYellowColor, onRange: NSRange(location: 5, length: 4)) // //Range of substring "is a"
        attributedText.apply(color: .purple, subString: "colorful")
        attributedText.apply(color: appBlueColor, subString: "attributed")
        attributedText.apply(color: darkOrangeColor, subString: "string")
        self.firstLabel.attributedText = attributedText
    }

    // 字体
    func setSecondLable() {
        let text = "This string is having multiple font"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(font: UIFont.boldSystemFont(ofSize: 24), subString: "This")
        attributedText.apply(font: UIFont.boldSystemFont(ofSize: 24), onRange: NSRange(location: 5, length: 6))
        attributedText.apply(font: UIFont.italicSystemFont(ofSize: 20), subString: "string")
        attributedText.apply(font: UIFont(name: "HelveticaNeue-BoldItalic", size: 20)!, subString: " is")
        attributedText.apply(font: UIFont(name: "HelveticaNeue-ThinItalic", size: 20)!, subString: "having")
        attributedText.apply(color: UIColor.blue, subString: "having")
        attributedText.apply(font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!, subString: "multiple")
        attributedText.apply(color: appRedColor, subString: "multiple")
        self.secondLabel.attributedText = attributedText
    }

    // 下划线、背景色
    func setThirdLabel() {
        let text = "This is underline string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.underLine(subString: "This is underline string")
        attributedText.apply(backgroundColor: appYellowColor, subString: "underline")
        self.thirdLabel.attributedText = attributedText
    }

    // 删除线、下划线、描边
    func setFourthLabel() {
        let text = "This is a strike and underline stroke string"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.strikeThrough(thickness: 2, subString: "This is a")
        attributedText.underLine(subString: "underline")
        attributedText.applyStroke(color: appRedColor, thickness: 2, subString: "stroke string")
        self.fourthLabel.attributedText = attributedText
    }

    // 阴影
    func setFifthLable() {
        let text = "This string is having a shadow"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 4.0, shadowHeigt: 4.0, shadowRadius: 4.0, subString: "This string is")
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 0, shadowHeigt: 0, shadowRadius: 5.0, subString: "having")
        attributedText.applyShadow(shadowColor: .black, shadowWidth: 4.0, shadowHeigt: 4.0, shadowRadius: 4.0, subString: "a shadow")
        self.fifthLabel.attributedText = attributedText
    }
}
