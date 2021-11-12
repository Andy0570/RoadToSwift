//
//  ViewController.swift
//  Buggy
//
//  Created by Qilin Hu on 2021/11/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        // print("Called \(#function)")
        print("Method: \(#function) in file:\(#file) line:\(#line) called.")
        
        // 打印控制器当前状态
        // print("Is control on? \(sender.isOn)")
        
        badMethod();
    }
    
    func badMethod() {
        let array = NSMutableArray()
        
        for i in 0..<10 {
            array.insert(i, at: i)
        }
        
        // 清空数组(注意范围的变化)
        for _ in 0..<10 {
            array.removeObject(at: 0)
        }
    }
}
