//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Qilin Hu on 2020/11/12.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {

    // 关联插座变量：摄氏度标签
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // 存储属性，华氏温度值
    var fahrenheitValue: Measurement<UnitTemperature>? {
        // 在属性声明之后，可以立即使用花括号声明属性观察器
        didSet {
            updateCelsiusValue()
        }
    }
    
    // 计算属性，摄氏度温度值
    var celsiusValue: Measurement<UnitTemperature>? {
        // 如果存在华氏温度值，则将其转换为等效的摄氏温度值。
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    // 使用闭包语法实例化「格式化数字」
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0;
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        updateCelsiusValue()
    }
    
    // 关联动作：华氏度文本输入框
    @IBAction func fahrenheitFieldEdittingChanged(_ textField: UITextField) {
        
        // 如果输入的值可以转换为 Double 类型，则将其转换并存储到 fahrenheitValue
        // 国际化支持：通过 NumberFormatter 将输入的值转换为华氏温度
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    // 在 storyboard 上添加一个手势识别器，并关联此方法
    // 关联动作：让文本输入框释放第一响应者，收起键盘
    @IBAction func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .ended {
            textField.resignFirstResponder()
        }
    }
    
    func updateCelsiusValue() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 0-9 的数字，也不包含小数点
        let decimalDigits = CharacterSet.decimalDigits
        // 国际化支持：获取本地化的小数点符号，在西班牙语言中，小数点用逗号（,）表示
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        
        for scalar in string.unicodeScalars {
            if !decimalDigits.contains(scalar) && String(scalar) != decimalSeparator {
                return false
            }
        }
        
        // 过滤输入，防止输入多个小数点
        // 如果现有字符串有小数点符号，替换字符串也有小数点符号，则应拒绝更改。
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        if existingTextHasDecimalSeparator != nil,
           replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
}
