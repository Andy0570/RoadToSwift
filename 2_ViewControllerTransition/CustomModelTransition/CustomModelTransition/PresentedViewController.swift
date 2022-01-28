//
//  PresentedViewController.swift
//  CustomModelTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

class PresentedViewController: UIViewController {

    let presentTransitionDelegate = SDEModalTransitionDelegate()
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 更新 textField 宽度约束
        let widthContraint = textField.constraints.filter { constraint in
            constraint.identifier == "Width"
        }.first
        widthContraint?.constant = view.frame.width * 2 / 3

        // 为 dismissButton 按钮设置渐变动画
        UIView.animate(withDuration: 0.3) {
            self.dismissButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        // MARK: 先执行当前视图内 UI 元素的自定义动画
        var applyTransform = CGAffineTransform(rotationAngle: 3 * Double.pi)
        applyTransform = applyTransform.scaledBy(x: 0.1, y: 0.1)

        // 更新 textField 宽度约束
        let widthContraint = textField.constraints.filter { constraint in
            constraint.identifier == "Width"
        }.first
        widthContraint?.constant = 0

        // 为 dismissButton 按钮设置旋转动画
        UIView.animate(withDuration: 0.4) {
            self.dismissButton.transform = applyTransform
            self.view.layoutIfNeeded()
        } completion: { [weak self] _ in

            // MARK: 执行转场动画
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
