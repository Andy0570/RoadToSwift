//
//  DetailViewController.swift
//  NavigationControllerTransition
//
//  Created by Qilin Hu on 2022/1/20.
//

import UIKit

class DetailViewController: UIViewController {

    // 屏幕边缘滑动手势
    lazy var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        var recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(gesture:)))
        recognizer.edges = .left
        return recognizer
    }()

    var navigationDelegate: SDENavigationDelegate?

    deinit {
        view.removeGestureRecognizer(edgePanGestureRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Stackup"
        view.addGestureRecognizer(edgePanGestureRecognizer)

        // MARK: 还可以使用系统内置方式修复侧滑返回手势
        // navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    @IBAction func popButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleEdgePanGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        let translationX = gesture.translation(in: view).x
        let translationBase: CGFloat = view.frame.width / 3
        let translationAbs = (translationX > 0 ? translationX : -translationX)
        let percent = (translationAbs > translationBase ? 1.0 : translationAbs / translationBase)

        switch gesture.state {
        case .began:
            navigationDelegate = self.navigationController?.delegate as? SDENavigationDelegate
            navigationDelegate?.interactive = true
            navigationController?.popViewController(animated: true)
        case .changed:
            // 更新转场进度，进度数值范围为0.0~1.0。
            navigationDelegate?.interactionController.update(percent)
        case .cancelled, .ended:
            // completionCurve ：交互结束后剩余动画的速率曲线
            // completionSpeed：交互结束后动画的开始速率，由该参数与原来的速率相乘得到，实际上是个缩放参数
            navigationDelegate?.interactionController.completionCurve = .easeOut
            let speed = abs(gesture.velocity(in: view).x)

            // 如果进度超过一半，完成这次转场
            if percent > 0.5 {
                // 单位变化速率 = 你要的速率 / 距离
                navigationDelegate?.interactionController.completionSpeed = speed / ((1-percent) * view.frame.width)
                // 完成转场，转场动画从当前状态继续直至结束。
                navigationDelegate?.interactionController.finish()
            } else {
                navigationDelegate?.interactionController.completionSpeed = speed / (percent * view.frame.width)
                // 取消转场，转场动画从当前状态返回至转场发生前的状态。
                navigationDelegate?.interactionController.cancel()
            }
            navigationDelegate?.interactive = false
        default: break
        }
    }

}
