//
//  ViewController.swift
//  CircularProgressBar
//
//  Created by Qilin Hu on 2022/4/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circularProgressBar: CircularProgressBar!

    @IBAction func sliderAction(_ sender: UISlider) {
        circularProgressBar.progress = CGFloat(sender.value)
    }
}

