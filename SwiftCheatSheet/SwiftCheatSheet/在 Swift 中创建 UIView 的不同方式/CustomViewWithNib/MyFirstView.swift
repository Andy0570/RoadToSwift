//
//  MyFirstView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/20.
//

import UIKit

/**
 如何为 View 创建 XIB 文件？

 ‼️ 要点：
 * 需要分别创建 UIView 子类文件和 XIB 文件。
 * 创建 XIB 文件 时，在 User Interface 标签页面中选择 View 模版，XIB 文件名最好与类名相同。
 * 在 XIB 文件的 File's Owner -> Identity 检视器中将类名设置为你的自定义类名。
 * 在 XIB 文件的 Attributes 检视器中将大小改为 Freeform。


 XIB 的优势：
 * 可以重用视图和代码；
 * 当你作为一个团队工作时，它工作得很好；
 * 为自定义视图提供了的视觉化的内容和布局；
 * 可以创建自定义初始化方法；

 XIB 的缺点：
 * 需要分别为视图和自定义类创建 xib 文件；
 * 解决 xibs 中的合并冲突容易出错；
 * 需要编写代码来加载 xib 文件并建立类和 xib 之间的关系；
 * 要全面了解 UI 组件，你需要同时检查 Interface Builder 文件和源代码文件；
 * 通过 IB 配置组件的方法太多：运行时属性、具有不同设置的多个选项卡、特定于大小类的覆盖等。这使得很难发现哪些设置被覆盖。
 */
class MyFirstView: UIView {
    @IBOutlet weak var label: UILabel!
    var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        view.backgroundColor = UIColor.purple // Just for Test
    }

    convenience init(labelText: String) {
        self.init(frame: .zero)
        self.label.text = labelText
        view.backgroundColor = UIColor.green // Just for Test
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        view.backgroundColor = UIColor.red // Just for Test
    }

    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.view = view
    }
}
