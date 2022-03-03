//
//  Anchors2ViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/3.
//

/**
 参考：以编程方式添加自动布局教程
 原文：[iOS Auto Layout tutorial programmatically](https://theswiftdev.com/ios-auto-layout-tutorial-programmatically/)

 在这个伟大的 iOS 自动布局教程中，我将教你如何支持旋转、使用约束、与图层一起工作、对 corner radius 执行动画。
 */

import UIKit

class Anchors2ViewController: UIViewController {

    // !!!: 使用弱引用处理内存管理问题
    weak var square1: UIView!
    weak var square2: UIView!
    weak var square3: UIView!

    // !!!: 在 loadView 而不是 viewDidLoad 中创建带有约束的视图
    override func loadView() {
        super.loadView()

        addSubviewUseAutoLayout()
        addSubviewUseVisualFormatLanguage()
        addSubviewUseAutoLayoutAnchors()
    }

    // !!!: 在 viewDidLoad 中设置所有其他的属性，如背景颜色等
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        square1.backgroundColor = .yellow
        square2.backgroundColor = .purple
        square3.backgroundColor = .green
    }

    // MARK: 1. 通过 NSLayoutConstraint 添加子视图
    private func addSubviewUseAutoLayout() {
        let square = UIView()
        self.view.addSubview(square)
        square.translatesAutoresizingMaskIntoConstraints = false

        // sqare.width = 64，
        // sqare.height = 64
        // sqare.centerX = self.view.centerX
        // sqare.centerY = self.view.centerY - 128
        self.view.addConstraints([
            NSLayoutConstraint(item: square, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 64),
            NSLayoutConstraint(item: square, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 64),
            NSLayoutConstraint(item: square, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: square, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: -128),
        ])
        self.square1 = square
    }

    // MARK: 2. 通过视觉格式化语言（Visual Format Language）添加子视图
    private func addSubviewUseVisualFormatLanguage() {
        let square = UIView()
        self.view.addSubview(square)
        square.translatesAutoresizingMaskIntoConstraints = false

        let views: [String: UIView] = ["view": self.view , "subview": square]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=128)-[subview(==64)]", options: .alignAllCenterX, metrics: nil, views: views)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=1)-[subview(==64)]", options: .alignAllCenterY, metrics: nil, views: views)
        self.view.addConstraints(vertical)
        self.view.addConstraints(horizontal)
        self.square2 = square
    }

    // MARK: 3. 通过自动布局锚点（Auto Layout Anchors）添加子视图
    private func addSubviewUseAutoLayoutAnchors() {
        let square = UIView()
        self.view.addSubview(square)
        square.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            square.widthAnchor.constraint(equalToConstant: 64),
            square.heightAnchor.constraint(equalToConstant: 64),
            square.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            square.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 158)
        ])
        self.square3 = square
    }
    
    // MARK: 支持屏幕旋转

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

}
