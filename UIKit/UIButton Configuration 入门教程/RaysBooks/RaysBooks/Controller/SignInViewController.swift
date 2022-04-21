/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public class SignInViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "rw-logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        // 配置按钮大小和圆角
        config.buttonSize = .large
        config.cornerStyle = .medium

        // 配置按钮标题样式
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        })

        config.image = UIImage(systemName: "chevron.right")
        // 在标题和图像之间添加 padding
        config.imagePadding = 5
        // 将图像放在按钮的末尾
        config.imagePlacement = .trailing
        // 设置 SF 符号的比例为中等
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        // 使用 configurationUpdateHandler 自动根据应用状态更新按钮样式
        button.configurationUpdateHandler = { [unowned self] button in
            // 复制 configuration 并存储在变量中以便修改
            var config = button.configuration
            // 如果用户正在登录，则显示活动指示器。
            config?.showsActivityIndicator = self.signingIn
            // 活动指示器相对于标题的位置和填充基于 imagePlacement 和 imagePadding
            config?.imagePlacement = self.signingIn ? .leading : .trailing
            config?.title = self.signingIn ? "Signing In..." : "Sign In"
            button.isEnabled = !self.signingIn
            button.configuration = config
        }

        button.configuration = config

        button.setTitle("Sign In", for: .normal)
        button.addAction(
            UIAction { _ in
                self.signingIn = true

                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.signingIn = false
                }
            },
            for: .touchUpInside
        )
        return button
    }()

    private lazy var helpButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .large
        config.cornerStyle = .medium

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.setTitle("Get Help", for: .normal)
        button.menu = UIMenu(children: [
            UIAction(title: "Forgot Password", image: UIImage(systemName: "key.fill")) { _ in
                print("Forgot Password Tapped")
            },
            UIAction(title: "Contact Support", image: UIImage(systemName: "person.crop.circle.badge.questionmark")) { _ in
                print("Contact Support Tapped")
            }
        ])
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private var signingIn = false {
        didSet {
            // 每当 signingIn 属性更改时，更新按钮配置
            signInButton.setNeedsUpdateConfiguration()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })

        view.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(helpButton)

        stackView.setCustomSpacing(125, after: logoImageView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            logoImageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1 / 4),
            logoImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            signInButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            helpButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}
