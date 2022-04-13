//
//  ViewController.swift
//  ModularApp
//
//  Created by Qilin Hu on 2022/4/13.
//

import UIKit
import Core // !!!: 导入 Core 框架

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let products = ProductService().getAllProducts()
        print(products)
    }
}

