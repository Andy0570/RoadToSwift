//
//  AnchorsViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/3.
//

/**
 参考：<https://www.hackingwithswift.com/read/6/5/auto-layout-anchors>
 */
import UIKit

class AnchorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground

        let label1 = UILabel()
        // 默认情况下，iOS 会基于视图的尺寸和大小自动为你生成自动布局约束
        // 但我们等会要手动添加这些约束，所以需要禁用该特性
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)

        // MARK: Auto Layout Anchors 自动布局锚点

        var previous: UILabel?

        for label in [label1, label2, label3, label4, label5] {
            // 每个 label 的宽度 = 当前视图的宽度
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            // 每个 label 的高度 = 88
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true

            // label.topAnchor = previous.bottomAnchor + 10
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                // 让第一个 Label 相对于 Safe Area 布局
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

            previous = label
        }
    }
}
