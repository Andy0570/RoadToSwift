//
//  CustomViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/20.
//

import UIKit

/// 为视图控制器创建 XIB 文件时，系统会自动在类文件和 XIB 文件之间建立关联。
class CustomViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
