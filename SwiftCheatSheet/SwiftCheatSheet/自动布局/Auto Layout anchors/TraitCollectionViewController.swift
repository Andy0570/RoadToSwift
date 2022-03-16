//
//  TraitCollectionViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/3.
//

/**
 参考：<https://theswiftdev.com/mastering-ios-auto-layout-anchors-programmatically-from-swift/>
 */
import UIKit

class TraitCollectionViewController: UIViewController {
    weak var testView: UIView!

    var regularConstraints: [NSLayoutConstraint] = []
    var compactConstraints: [NSLayoutConstraint] = []

    override func loadView() {
        super.loadView()

        let testView = UIView(frame: .zero)
        testView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(testView)

        self.regularConstraints = [
            testView.widthAnchor.constraint(equalToConstant: 64),
            testView.widthAnchor.constraint(equalTo: testView.heightAnchor),
            testView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]

        self.compactConstraints = [
            testView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            testView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]

        self.activateCurrentConstraints()
        self.testView = testView
    }

    private func activateCurrentConstraints() {
        NSLayoutConstraint.deactivate(self.compactConstraints + self.regularConstraints)

        if self.traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(self.regularConstraints)
        } else {
            NSLayoutConstraint.activate(self.compactConstraints)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
        self.testView.backgroundColor = .red
    }

    // MARK: - rotation support

    //  是否支持自动转屏
    override var shouldAutorotate: Bool {
        return true
    }

    // 支持哪些转屏方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    // 页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    // MARK: - trait collections

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.activateCurrentConstraints()
    }
}
