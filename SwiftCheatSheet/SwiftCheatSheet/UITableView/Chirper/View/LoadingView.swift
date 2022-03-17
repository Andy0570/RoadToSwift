//
//  LoadingView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import UIKit

class LoadingView: UIView {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        return view
    }()

    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    init() {
        super.init(frame: .zero)
        initialize()
    }

    func initialize() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
