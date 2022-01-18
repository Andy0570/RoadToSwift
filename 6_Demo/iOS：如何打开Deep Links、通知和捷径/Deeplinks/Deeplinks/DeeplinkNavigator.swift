//
//  DeeplinkNavigator.swift
//  Deeplinks
//
//  Created by Qilin Hu on 2022/1/17.
//

// !!!: DeeplinkNavigator 会基于 DeeplinkType 打开指定的页面

import UIKit

class DeeplinkNavigator {
    // 单例类
    static let shared = DeeplinkNavigator()
    private init() {}

    var alertController = UIAlertController()

    // 遍历 DeeplinkType 枚举类型，执行页面跳转逻辑
    func processedToDeeplink(_ type: DeeplinkType) {
        switch type {
        case .messages(.root):
            displayAlert(title: "Message Root")
        case .messages(.details(id: let id)):
            displayAlert(title: "Message Details \(id)")
        case .activity:
            displayAlert(title: "Activity")
        case .newListing:
            displayAlert(title: "New Listing")
        case .request(let id):
            displayAlert(title: "Request Details \(id)")
        }
    }

    // 执行 Deeplink，这里简单地执行 Alert 弹窗
    private func displayAlert(title: String) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        alertController.title = title
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            if vc.presentedViewController != nil {
                alertController.dismiss(animated: false) {
                    vc.present(self.alertController, animated: true, completion: nil)
                }
            } else {
                vc.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
