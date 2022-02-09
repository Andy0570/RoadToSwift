//
//  NotificationParser.swift
//  Deeplinks
//
//  Created by Qilin Hu on 2022/1/18.
//

import Foundation

class NotificationParser {
    static let shared = NotificationParser()
    private init() {}

    func handleNotification(_ userInfo: [AnyHashable: Any]) -> DeeplinkType? {
        if let data = userInfo["data"] as? [String: Any] {
            if let messageId = data["messageId"] as? String {
                return DeeplinkType.messages(.details(id: messageId))
            }
        }
        
        return nil
    }
}
