//
//  MenuButtonViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/27.
//

import UIKit

class MenuButtonViewController: UIViewController {
    private var range = Measurement(value: 100, unit: UnitLength.miles) {
        didSet {
            carButton.setNeedsUpdateConfiguration()
        }
    }

    private lazy var formatter = MeasurementFormatter()
    var didTapCommentPencilButton: (() -> Void)?

    weak var menuButton: MenuButton!

    private lazy var carButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .capsule // 按钮圆角样式，胶囊
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }

        // 设置按钮尾部汽车图片
        config.image = UIImage(systemName: "car", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.imagePlacement = .trailing
        config.imagePadding = 8.0

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        // 注册配置更新处理程序
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            // 显示活动指示器
            // config?.showsActivityIndicator = true
            config?.image = button.isHighlighted ? UIImage(systemName: "car.fill") : UIImage(systemName: "car")
            config?.subtitle = self.formatter.string(from: self.range)
            button.configuration = config
        }

        button.configuration = config
        button.setTitle("Start", for: .normal)

        button.addAction(
            UIAction { _ in
                self.range = Measurement(value: Double.random(in: 10...1000), unit: UnitLength.miles)
            }, for: .touchUpInside)

        return button
    }()

    private lazy var commentPencilButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let titleColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.gray()
            config.baseForegroundColor = titleColor
            config.buttonSize = .medium
            config.cornerStyle = .capsule

            // 配置按钮标题样式
            var container = AttributeContainer()
            container.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            config.attributedTitle = AttributedString("我要评论...", attributes: container)
            config.titleAlignment = .leading

            // iOS 13.0, 配置 SF 图片
            config.image = UIImage(systemName: "highlighter")
            config.imagePadding = 5.0
            config.imagePlacement = .leading
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 30)

            button.configuration = config

            // iOS 14.0
            let action = UIAction { _ in
                self.didTapCommentPencilButton?()
            }
            button.addAction(action, for: .touchUpInside)
        } else {
            button.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
            button.setTitle("我要评论...", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(titleColor, for: .normal)
            button.layer.cornerRadius = 17.0
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(commentPencilButtonTapped(_:)), for: .touchUpInside)
        }

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground

        // 自定义心形按钮
        let heartButton = HeartButton()
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.defaultImage = UIImage(named: "like_normal")
        heartButton.selectedImage = UIImage(named: "like_fill")
        heartButton.animatedImage = UIImage(named: "like_fill")
        view.addSubview(heartButton)
        NSLayoutConstraint.activate([
            heartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            heartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heartButton.widthAnchor.constraint(equalToConstant: 48),
            heartButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        // 弹出菜单按钮
        let button = MenuButton()
        view.addSubview(button)
        self.menuButton = button
        NSLayoutConstraint.activate(button.layoutConstraints(in: view))

        // 汽车按钮
        view.addSubview(carButton)
        NSLayoutConstraint.activate([
            carButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            carButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // 我要评论
        view.addSubview(commentPencilButton)
        NSLayoutConstraint.activate([
            commentPencilButton.topAnchor.constraint(equalTo: carButton.bottomAnchor, constant: 20),
            commentPencilButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Action

    @objc func commentPencilButtonTapped(_ sender: UIButton) {
        log.debug("Function: \(#function), line: \(#line)")

        self.didTapCommentPencilButton?()
    }
}
