//
//  PresentedViewController.swift
//  ModalPresentationDemo
//
//  Created by Qilin Hu on 2021/12/30.
//

import UIKit

class PresentedViewController: UIViewController {

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemPurple
        
        let closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // 以 sheet 方式 present 出来的视图控制器，系统会为它添加一个拖拽关闭的手势。但如果用户在 present 出来的视图控制
        // 器上进行了一些编辑改动，而一个不小心的拖拽导致这个视图控制器被直接 dismiss，进而丢失了刚刚的改动，那么用户可能会不太高兴。
        // 在这种情况下，你可以通过设置视图控制器的 modalInPresentation 属性为 YES 来避免视图控制器被直接 dismiss。
        isModalInPresentation = true
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\(#file) \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\(#file) \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("\(#file) \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("\(#file) \(#function)")
    }
    
    // MARK: - Actions
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// 如果需要在拖拽视图控制器时，提醒用户是否需要保存已经编辑的内容，则可以实现 UIAdaptivePresentationControllerDelegate 协议
extension PresentedViewController: UIAdaptivePresentationControllerDelegate {
    
    // 如果 isModalInPresentation = false，系统会首先调用该方法
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        // 在该方法中返回 false 后，系统会接着调用 presentationControllerDidAttemptToDismiss 方法
        return false
    }
    
    // 如果 isModalInPresentation = true，系统会直接调用该方法
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        
        // 在这个方法中询问用户是否需要保存编辑的内容
        
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("\(#file) \(#function)")
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("\(#file) \(#function)")
    }
}
