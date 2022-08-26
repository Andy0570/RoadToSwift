//
//  LoadingViewable.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import UIKit

protocol loadingViewable {
    func startAnimating()
    func stopAnimating()
}

extension loadingViewable where Self: UIViewController {
    func startAnimating() {
        let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        loadingView.restorationIdentifier = "loadingView"
        loadingView.center = view.center
        loadingView.cornerRadius = 15
        loadingView.clipsToBounds = true
        loadingView.startAnimation()
    }

    func stopAnimating() {
        for item in view.subviews where item.restorationIdentifier == "loadingView" {
            UIView.animate(withDuration: 0.3) {
                item.alpha = 0
            } completion: { _ in
                item.removeFromSuperview()
            }
        }
    }
}
