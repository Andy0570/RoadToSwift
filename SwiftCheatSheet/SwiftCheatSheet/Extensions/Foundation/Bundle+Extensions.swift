//
//  Bundle+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import Foundation

extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    // 获取应用程序版本号
    // let appVersion = Bundle.mainAppVersion
    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
}
