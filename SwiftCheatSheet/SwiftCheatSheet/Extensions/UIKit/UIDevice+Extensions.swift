//
//  UIDevice+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/25.
//

import UIKit
import AudioToolbox

// 一行代码实现系统振动反馈提示
// UIDevice.vibrate()
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
}
