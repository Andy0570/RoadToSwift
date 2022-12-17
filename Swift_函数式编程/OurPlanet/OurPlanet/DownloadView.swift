//
//  DownloadView.swift
//  OurPlanet
//
//  Created by Qilin Hu on 2022/11/30.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import UIKit

class DownloadView: UIStackView {
    let label = UILabel()
    let progress = UIProgressView()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false

        axis = .horizontal
        spacing = 0
        distribution = .fillEqually

        if let superview = superview {
            backgroundColor = UIColor.white
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 38).isActive = true

            label.text = "Downloads"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .lightGray
            label.textAlignment = .center

            progress.translatesAutoresizingMaskIntoConstraints = false

            let progressWrap = UIView()
            progressWrap.translatesAutoresizingMaskIntoConstraints = false
            progressWrap.backgroundColor = .lightGray
            progressWrap.addSubview(progress)

            progress.leftAnchor.constraint(equalTo: progressWrap.leftAnchor).isActive = true
            progress.rightAnchor.constraint(equalTo: progressWrap.rightAnchor).isActive = true
            progress.heightAnchor.constraint(equalToConstant: 4).isActive = true
            progress.centerYAnchor.constraint(equalTo: progressWrap.centerYAnchor).isActive = true

            addArrangedSubview(label)
            addArrangedSubview(progressWrap)
        }
    }
}
