//
//  CoolViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/24.
//

import UIKit

class CoolViewController: UIViewController, CustomPresentable {
    var transitionManager: UIViewControllerTransitioningDelegate?

    let rectangleView: UIView = .make(backgroundColor: .systemPink.withAlphaComponent(0.5), cornerRadius: 12.0)

    let sizeButton: UIButton = .make(
        contentColor: .white,
        backgroundColor: .systemPink,
        title: "Change rectangle size!",
        textFormat: (17.0, .bold),
        height: 50,
        cornerRadius: 25,
        padding: 16
    )

    let dismissButton: UIButton = .make(
        contentColor: .systemPink,
        backgroundColor: .clear,
        title: "Dismiss",
        textFormat: (17.0, .bold),
        height: 50,
        cornerRadius: 25,
        padding: 16,
        style: .outline
    )

    var rectangleHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20.0
        view.addSubviews([rectangleView, sizeButton, dismissButton])

        rectangleHeightConstraint = rectangleView.heightAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            rectangleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            rectangleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rectangleHeightConstraint,

            sizeButton.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 16),
            sizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dismissButton.topAnchor.constraint(equalTo: sizeButton.bottomAnchor, constant: 16),
            dismissButton.widthAnchor.constraint(equalTo: sizeButton.widthAnchor),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).usingPriority(.defaultLow)
        ])

        sizeButton.addTarget(self, action: #selector(sizeButtonTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func sizeButtonTapped() {
        rectangleHeightConstraint.constant = CGFloat(Int.random(in: 50...400))
        updatePresentationLayout(animated: true)
    }
}
