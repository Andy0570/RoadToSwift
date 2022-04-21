//
//  DifferentViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/20.
//

/// 在 Swift 中创建 UIView 的不同方式？
/// Reference: <https://manasaprema04.medium.com/different-way-of-creating-uiviews-in-swift-4aeb1b5d0d6b>
import UIKit

class DifferentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. 使用默认 init 方法加载 xib 视图
        let customView = MyFirstView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            customView.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 2. 使用自定义 init 方法加载 xib 视图
        let customView1 = MyFirstView(labelText: "convenience init method")
        customView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView1)
        NSLayoutConstraint.activate([
            customView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            customView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            customView1.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: 10),
            customView1.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 3. 直接在调用方法中加载 xib
//        let customView2 = Bundle.main.loadNibNamed("MyFirstView", owner: self, options: nil)?.first as! MyFirstView
//        customView2.backgroundColor = UIColor.red
//        customView2.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(customView2)
//        NSLayoutConstraint.activate([
//            customView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            customView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            customView2.topAnchor.constraint(equalTo: customView1.bottomAnchor, constant: 10),
//            customView2.heightAnchor.constraint(equalToConstant: 50)
//        ])

        // 4. Load custom viewcontroller's view programatically
        let customVCView = CustomViewController().view!
        customVCView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customVCView)
        NSLayoutConstraint.activate([
            customVCView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            customVCView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            customVCView.topAnchor.constraint(equalTo: customView1.bottomAnchor, constant: 10),
            customVCView.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 5. Load programatically created custom View
        let customView3 = MySecondView()
        customView3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView3)
        NSLayoutConstraint.activate([
            customView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            customView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            customView3.topAnchor.constraint(equalTo: customVCView.bottomAnchor, constant: 10),
            customView3.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
