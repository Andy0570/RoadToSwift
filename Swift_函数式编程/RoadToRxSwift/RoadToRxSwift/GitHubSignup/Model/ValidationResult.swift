//
//  ValidationResult.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/24.
//

import RxSwift
import RxCocoa

/// 登录状态：成功/失败
enum SignupState {
    case signedUp(signedUp: Bool)
}

/// 检验结果枚举类型
enum ValidationResult {
    case ok(message: String) // 验证通过
    case empty // 输入为空
    case validating // 正在验证中
    case failed(message: String) // 验证失败
}

// 扩展 ValidationResult，对应不同的验证结果返回验证是成功还是失败
extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

// 扩展 ValidationResult，对应不同的验证结果返回不同的文字描述
extension ValidationResult {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case .validating:
            return "正在验证..."
        case let .failed(message):
            return message
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}

// 扩展 ValidationResult，对应不同的验证结果返回不同的文字颜色
extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return ValidationColors.errorColor
        }
    }
}

// 扩展UILabel
extension Reactive where Base: UILabel {
    // 让验证结果（ValidationResult类型）可以绑定到 label 上
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
