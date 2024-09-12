//
//  CTSettings.swift
//  CoreTextMagazine
//
//  Created by Qilin Hu on 2024/1/11.
//

import UIKit

class CTSettings {
    // MARK: - Properties
    let margin: CGFloat = 20 // 页边距
    let columnsPerPage: CGFloat! // 每页的栏数
    var pageRect: CGRect! // page 大小
    var columnRect: CGRect! // 每页每列的大小

    // MARK: - Initializers
    init() {
        // 在 iPad 上显示两栏，在 iPhone 上显示一栏
        columnsPerPage = UIDevice.current.userInterfaceIdiom == .phone ? 1: 2
        // 通过插入页边距来计算 page 大小
        pageRect = UIScreen.main.bounds.insetBy(dx: margin, dy: margin)
        // 每页每列的宽度 = page 的宽度 / 每页的栏数
        columnRect = CGRect(x: 0,
                            y: 0,
                            width: pageRect.width / columnsPerPage,
                            height: pageRect.height).insetBy(dx: margin, dy: margin)
    }
}
