//
//  HomeViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/23.
//

import UIKit

class HomeViewController: UIViewController {
    let presentButton: UIButton = .make(contentColor: .white, backgroundColor: .systemPink, title: "Present the thing!", textFormat: (17.0, .bold), height: 50.0, cornerRadius: 25.0, padding: 16.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(presentButton)
        NSLayoutConstraint.activate([
            presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        presentButton.addTarget(self, action: #selector(presentButtonTapped), for: .touchUpInside)
    }

    @objc private func presentButtonTapped() {
        let coolViewController = CoolViewController()
        present(coolViewController, interactiveDismissalType: .standard)
    }
}
