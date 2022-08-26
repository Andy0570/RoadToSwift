//
//  LoadingView.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var animateView: AnimateloadingView!
    @IBOutlet var containerView: UIView!

    public var loadingViewMessage: String! {
        didSet {
            messageLabel.text = loadingViewMessage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        containerView.addBlurArea(area: containerView.bounds, style: .dark)
        containerView.bringSubviewToFront(messageLabel)
        containerView.bringSubviewToFront(animateView)
    }

    public func startAnimation() {
        if animateView.isAnimating {
            return
        }
        animateView.startAnimating()
    }

    public func stopAnimation() {
        animateView.stopAnimating()
    }
}
