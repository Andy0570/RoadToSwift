//
//  ProgramaticallyCreateViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/21.
//

import UIKit

/// 代码方式创建自定义 UIView
/// Reference: <https://medium.com/@tapkain/custom-uiview-in-swift-done-right-ddfe2c3080a>
class ProgramaticallyCreateViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped(_ sender: Any) {
        let customView = CustomView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.borderColor = UIColor.blue.cgColor
        customView.layer.borderWidth = 2.0
        view.addSubview(customView)

        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
