//
//  UIDevice+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
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
