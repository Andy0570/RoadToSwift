// UIDeviceExtensions.swift - Copyright © 2022 SwifterSwift

#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UIDevice {
    var isMac: Bool {
        if #available(iOS 14.0, tvOS 14.0, *) {
            if UIDevice.current.userInterfaceIdiom == .mac {
                return true
            }
        }
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }
}
#endif

#if canImport(AudioToolbox)
import AudioToolbox

public extension UIDevice {
    /// SwifterSwift: 一行代码实现系统振动反馈提示
    ///
    ///     UIDevice.vibrate()
    ///
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
}

#endif
