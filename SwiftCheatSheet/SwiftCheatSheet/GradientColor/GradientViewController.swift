//
//  GradientViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/27.
//

/**
 创建渐变色

 参考：
 <https://www.swiftdevcenter.com/how-to-create-gradient-color-using-cagradientlayer/>
 */
import UIKit

class GradientViewController: UIViewController {
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fiveView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        // First view
//        firstView.applyGradient(
//            colors: [UIColor.red.cgColor, UIColor.blue.cgColor],
//            locations: [0.0, 1.0],
//            direction: .topToBottom
//        )
//
//        // Second view
//        secondView.applyGradient(
//            colors: [UIColor.red.cgColor, UIColor.cyan.cgColor, UIColor.yellow.cgColor],
//            locations: [0.3, 1.0],
//            direction: .topToBottom
//        )
//
//        // Third view
//        thirdView.applyGradient(
//            colors: [UIColor.orange.cgColor, UIColor.yellow.cgColor],
//            locations: [0.6, 1.0],
//            direction: .bottomToTop
//        )
//
//        // Fourth view
//        fourthView.applyGradient(
//            colors: [UIColor.orange.cgColor, UIColor.yellow.cgColor],
//            locations: nil,
//            direction: .leftToRight
//        )
//
//        // five view
//        fiveView.applyGradient(
//            colors: [UIColor.red.cgColor, UIColor.blue.cgColor],
//            locations: nil,
//            direction: .rightToLeft
//        )
    }
}
