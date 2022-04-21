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

    weak var button: MenuButton!

    private lazy var carButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .medium
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

    override func loadView() {
        super.loadView()

        // 初始化按钮。添加按钮并设置自动布局约束
        let button = MenuButton()
        view.addSubview(button)
        self.button = button
        NSLayoutConstraint.activate(button.layoutConstraints(in: view))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground

        view.addSubview(carButton)
        NSLayoutConstraint.activate([
            carButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            carButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
