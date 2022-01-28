//
//  PresentingViewController.swift
//  CustomModelTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

class PresentingViewController: UIViewController {

    let presentTransitionDelegate = SDEModalTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    /**
     .FullScreen 模式下，presentingView 的移除和添加由 UIKit 负责，在 presentation 转场结束后被移除，dismissal 转场结束时重新回到原来的位置；
     .Custom 模式下，presentingView 依然由 UIKit 负责，但 presentation 转场结束后不会被移除。
     */

    // 通过 segue 方式触发转场时，在此处修改转场参数。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let presentedVC = segue.destination as? PresentedViewController {
            // 通过 presentedVC.transitioningDelegate 设置自定义 Modal 转场代理
            presentedVC.transitioningDelegate = presentTransitionDelegate
            // 当与 UIPresentationController 配合时该属性必须为 .custom。
            presentedVC.modalPresentationStyle = .custom
        }
    }

}

