//
//  DeepLinkManager.swift
//  Deeplinks
//
//  Created by Qilin Hu on 2022/1/17.
//

import UIKit

// 把所有 Deeplink 要跳转的页面写在枚举类型中
enum DeeplinkType {
    enum Messages {
        case root
        case details(id: String)
    }
    case messages(Messages)
    case activity
    case newListing
    case request(id: String)
}

// 管理所有 Deeplink 的单例类
let DeepLinker = DeepLinkManager()
class DeepLinkManager {
    fileprivate init() {}

    // 当前的 DeeplinkType
    private var deeplinkType: DeeplinkType?

    // 检查当前 Deeplink 并执行动作
    func checkDeepLink() {
        guard let deeplinkType = deeplinkType else {
            return
        }

        DeeplinkNavigator.shared.processedToDeeplink(deeplinkType)
        // deeplink 处理完成后，重置
        self.deeplinkType = nil
    }

    @discardableResult
    func handleShortcut(item: UIApplicationShortcutItem) -> Bool {
        // 尝试将 ShortcutItem 解析为 DeeplinkType
        deeplinkType = ShortcutParser.shared.handleShortcut(item)
        return deeplinkType != nil
    }

    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        deeplinkType = DeeplinkParser.shared.parseDeepLink(url)
        return deeplinkType != nil
    }

    func handleRemoteNotification(_ notification: [AnyHashable: Any]) {
        deeplinkType = NotificationParser.shared.handleNotification(notification)
    }
}

