//
//  VFLViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/3.
//

/**
 参考：<https://www.hackingwithswift.com/read/6/3/auto-layout-in-code-addconstraints-with-visual-format-language>
 */

import UIKit

class VFLViewController: UIViewController {

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

        // MARK: Visual Format Language

        let viewsDictionary = ["label1": label1,
                               "label2": label2,
                               "label3": label3,
                               "label4": label4,
                               "label5": label5]

        /**
         view.addConstraints(): 为我们的视图控制器的视图添加一个约束数组。使用这个数组而不是单个约束，是因为VFL可以一次生成多个约束。
         NSLayoutConstraint.constraints(withVisualFormat:) 是自动布局方法，它将 VFL 转换为一个约束数组。它接受很多参数，但重要的参数是第一个和最后一个。
         我们为 options 参数传递 []（一个空数组），为 metrics 参数传递 nil。你可以使用这些选项来定制 VFL 的含义，但现在我们并不关心。
         */
        for label in viewsDictionary.keys {
            // H 表示水平方向，V 表示垂直方向。| 表示屏幕边缘。
            // "H:|[label1]|" 意味着 "在水平方向上，我希望我的 label1 在我的视图中的布局从左边缘到右边缘。"
            // 我们的每个标签都应该在我们的视图中从边缘延伸到边缘。
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        }

        // 垂直方向上：
        // label 与 label 之间的间距默认为 10；-
        // 每个 label 的高度是 88；(==88)
        // 第一个 label 与顶部的距离固定为 40；|-40-
        // 最后一个 label 与底部的距离大于 10；-(>=10)-|

        // 优化：把 ==88 写到 metrics 数组中，而不用把具体的数值硬编码到 VFL 语句中。
        let metrics = ["labelHeight": 88]
        // 优化：适配iPhone横屏模式，降低 label 的高度优先级，同时设置所有 label 的高度相等
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))



    }
}
