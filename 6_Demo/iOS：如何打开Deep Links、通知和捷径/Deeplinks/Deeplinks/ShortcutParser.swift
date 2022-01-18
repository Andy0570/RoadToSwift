//
//  ShortcutParser.swift
//  Deeplinks
//
//  Created by Qilin Hu on 2022/1/18.
//

import UIKit

enum ShortcutKey: String {
    case newListing = "com.myApp.newListing"
    case activity = "com.myApp.activity"
    case messages = "com.MyApp.messages"
}

class ShortcutParser {
    static let shared = ShortcutParser()
    private init() { }

    // 注册不同用户类型的快捷方式
    func registerShortcuts(for profileType: ProfileType) {
        let activityIcon = UIApplicationShortcutIcon(templateImageName: "Alert Icon")
        let activityShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.activity.rawValue, localizedTitle: "Recent Activity", localizedSubtitle: nil, icon: activityIcon, userInfo: nil)

        let messageIcon = UIApplicationShortcutIcon(templateImageName: "Messager Icon")
        let messageShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.messages.rawValue, localizedTitle: "Messages", localizedSubtitle: nil, icon: messageIcon, userInfo: nil)

        UIApplication.shared.shortcutItems = [activityShortcutItem, messageShortcutItem]

        switch profileType {
        case .guest:
            break
        case .host:
            let newListingIcon = UIApplicationShortcutIcon(templateImageName: "New Listing Icon")
            let newListingShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.newListing.rawValue, localizedTitle: "New Listing", localizedSubtitle: nil, icon: newListingIcon, userInfo: nil)
            UIApplication.shared.shortcutItems?.append(newListingShortcutItem)
        }
    }

    // 尝试将 ShortcutItem 解析为 DeeplinkType
    func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> DeeplinkType? {
        switch shortcut.type {
        case ShortcutKey.activity.rawValue:
            return .activity
        case ShortcutKey.messages.rawValue:
            return .messages(.root)
        case ShortcutKey.newListing.rawValue:
            return .newListing
        default:
            return nil
        }
    }
}
