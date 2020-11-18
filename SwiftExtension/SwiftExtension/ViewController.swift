//
//  ViewController.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let view: UIView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        self.view.addSubview(view)
        
        let image = UIColor.red.image()
        let imageView: UIImageView = UIImageView(frame: view.bounds)
        imageView.image = image
        view.addSubview(imageView)
    }
}

