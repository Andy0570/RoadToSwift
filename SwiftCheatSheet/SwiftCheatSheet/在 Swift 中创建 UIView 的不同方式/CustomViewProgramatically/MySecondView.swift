//
//  MySecondView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/20.
//

import UIKit

/**
 以编程方式创建视图的优点？
 * 代码更容易调试；
 * 约束可能更容易概述；
 * 代码是 UI 组件的单一事实来源；
 * 视图设置是明确的。很清楚配置了哪些属性以及如何配置；
 * 合并冲突更容易解决，因为我们处理的是代码而不是 XML 文件；
 * 可扩展复杂场景：屏幕旋转、动画、动态字体等；
 * 在复杂的场景中，当你需要对布局进行更多控制时（例如，屏幕旋转、每个屏幕尺寸或平台的变化、动画、动态字体），你将需要诉诸编程约束甚至手动 frame 计算。

 以编程方式创建视图有什么缺点？
 * 没有视图的视觉化表示；
 * 最终可能会有很多布局代码；
 */
open class MySecondView: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.text = "View created programatically"
        return label
    }()

    // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    convenience init(labelText: String) {
        self.init(frame: .zero)
        label.text = labelText
    }

    // initWithCode to init view from xib or storyboard
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // common func to init our view
    private func setupView() {
        backgroundColor = .cyan

        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
