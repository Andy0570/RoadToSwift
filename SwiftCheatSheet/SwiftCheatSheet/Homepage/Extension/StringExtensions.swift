//
//  StringExtensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/17.
//

import UIKit

extension String {

    /// 通过字符串创建视图控制器实例
    ///
    /// 使用示例:
    /// let className = "CustomViewController"
    /// if let controller = className.getViewController() {
    ///    navigationController?.pushViewController(controller, animated: true)
    /// }
    ///
    /// - Returns: 视图控制器实例
    public func getViewController() -> UIViewController? {
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            if let viewControllerType = Bundle.main.classNamed("\(appName).\(self)") as? UIViewController.Type {
                return viewControllerType.init()
            }
        }
        return nil
    }
}
