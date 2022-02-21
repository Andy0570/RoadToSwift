//
//  NavigationController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

import UIKit

class NavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        // 始终显示大导航栏标题
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        // custom tint color
        navigationBar.tintColor = .systemGreen
        // custom background color
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemBackground
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }

}
