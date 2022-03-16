//
//  MenuButtonViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/27.
//

import UIKit

class MenuButtonViewController: UIViewController {
    weak var button: MenuButton!

    override func loadView() {
        super.loadView()

        // 初始化按钮。添加按钮并设置自动布局约束
        let button = MenuButton()
        view.addSubview(button)
        self.button = button
        NSLayoutConstraint.activate(button.layoutConstraints(in: view))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
    }
}
