//
//  ViewController.swift
//  iDocuments
//
//  Created by Martina on 08/04/22.
//

/**
 Reference:
 * <https://betterprogramming.pub/how-to-create-a-nice-uitabbar-for-your-ios-app-using-swift-5-pt-1-f9d2d5450909>
 * <https://betterprogramming.pub/how-to-create-a-nice-uitabbar-for-your-ios-app-using-swift-5-pt-2-9285466846c8>
 * <https://betterprogramming.pub/design-dribbble-like-floating-buttons-for-your-uitabbar-for-ios-using-swift-5-8bf5eb71f79a>
 */

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let layer = CAShapeLayer()
    var layerHeight = CGFloat()
    var buttonTapped = false
    var middleButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy, scale: .large)
        button.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = UIColor(named: "iDoxViewColor")
        return button
    }()

    let bgColor = UIColor(named: "iDoxLightColor")
    let sColor = UIColor(named: "iDoxAccentColor")
    let tColor = UIColor(named: "iDoxShadowColor")

    var index = Int()
    var optionButtons: [UIButton] = []
    var options = [
        option(name: "A", image: UIImage(systemName: "a") ?? UIImage(), segue: "a"),
        option(name: "B", image: UIImage(systemName: "a") ?? UIImage(), segue: "b"),
        option(name: "C", image: UIImage(systemName: "a") ?? UIImage(), segue: "c")
    ]

    struct option {
        var name = String()
        var image = UIImage()
        var segue = String()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    private func setupTabBar() {
        // tab bar layer
        let x: CGFloat = 10
        let y: CGFloat = 20
        let width = self.tabBar.bounds.width - x * 2
        let height = self.tabBar.bounds.height + y * 1.5
        layerHeight = height
        layer.fillColor = bgColor?.cgColor
        layer.path = UIBezierPath(roundedRect: CGRect(x: x, y: self.tabBar.bounds.minY - y, width: width, height: height),
                                  cornerRadius: height / 2).cgPath

        // tab bar shadow
        layer.shadowColor = tColor?.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5

        // add tab bar layer
        self.tabBar.layer.insertSublayer(layer, at: 0)

        // fix items position
        self.tabBar.itemWidth = width
        self.tabBar.itemPositioning = .centered
        self.tabBar.unselectedItemTintColor = sColor

        // add middle button
        addMiddleButton()
    }

    private func addMiddleButton() {
        // DISABLE TABBAR ITEM - behind the "+" custom button:
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                items[1].isEnabled = false
            }
        }

        // shape, position and size
        tabBar.addSubview(middleButton)
        let size = CGFloat(50)
        let constant: CGFloat = -20 + (layerHeight / 2) - 5

        // 设置约束
        let constraints = [
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: constant),
            middleButton.heightAnchor.constraint(equalToConstant: size),
            middleButton.widthAnchor.constraint(equalToConstant: size)
        ]
        for constraint in constraints {
            constraint.isActive = true
        }
        middleButton.layer.cornerRadius = size / 2

        // shadow
        middleButton.layer.shadowColor = tColor?.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        middleButton.layer.shadowOpacity = 0.75
        middleButton.layer.shadowRadius = 13

        // other
        middleButton.layer.masksToBounds = false
        middleButton.translatesAutoresizingMaskIntoConstraints = false

        // action
        middleButton.addTarget(self, action: #selector(buttonHandler(sender:)), for: .touchUpInside)
    }

    private func createButton(size: CGFloat) -> UIButton {
        // button's appearance
        let buttonBGColor = UIColor(named: "iDoxViewColor")
        let button = UIButton(type: .custom)
        button.backgroundColor = buttonBGColor
        button.translatesAutoresizingMaskIntoConstraints = false

        // button's constraints
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.layer.cornerRadius = size / 2

        // double check that the button is tapped
        if buttonTapped == true {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                button.imageView?.tintColor = .clear
                button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                button.imageView?.tintColor = .white
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }

        return button
    }

    private func createBackground() -> UIButton {
        // background button to deselect middle button
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.titleLabel?.text = ""
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        return button
    }

    private func setupButtons(count: Int, center: UIView, radius: CGFloat) {
        // set buttons distance using degrees
        let degree = 135 / CGFloat(count)

        // create background to avoid other interations
        let background = createBackground()
        background.addTarget(self, action: #selector(backgroundPressed(sender:)), for: .touchUpInside)
        background.addTarget(self, action: #selector(backgroundPressed(sender:)), for: .touchDragInside)
        self.optionButtons.append(background)

        // set middle button to be front
        tabBar.bringSubviewToFront(middleButton)

        // create three buttons
        for i in 0..<count {
            // set index to assign action
            self.index = i

            // create and set the buttons
            let button = createButton(size: 44)
            self.optionButtons.append(button)
            self.view.addSubview(button)
            button.imageView?.isHidden = false

            // 使用三角函数设置约束
            let x = cos(degree * CGFloat(i+1) * .pi/180) * radius
            let y = sin(degree * CGFloat(i+1) * .pi/180) * radius
            button.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor, constant: -x).isActive = true
            button.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -y).isActive = true

            // final setup
            button.setImage(options[i].image, for: .normal)
            self.view.bringSubviewToFront(button)
            button.addTarget(self, action: #selector(optionHandler(sender:)), for: .touchUpInside)
        }
    }

    private func removeButtons() {
        // 从视图中移除多按钮
        for button in self.optionButtons {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                button.transform = CGAffineTransform(scaleX: 1.15, y: 1.1)
            } completion: { _ in
                button.alpha = 0
                if button.alpha == 0 {
                    button.removeFromSuperview()
                }
            }
        }
    }

    // MARK: - Actions

    @objc func buttonHandler(sender: UIButton) {
        let buttonBGColor = UIColor(named: "iDoxViewColor")
        if buttonTapped == false {
            // if button needs to open
            UIView.animate(withDuration: 0.3) {
                // 按钮旋转 45 度
                self.middleButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
                // 更新样式
                self.middleButton.backgroundColor = .white
                self.middleButton.imageView?.tintColor = buttonBGColor
                self.middleButton.layer.borderWidth = 5
                self.middleButton.layer.borderColor = buttonBGColor?.cgColor

                // button is on selected mode
                self.buttonTapped.toggle()

                // perform an action
                self.setupButtons(count: self.options.count, center: self.middleButton, radius: 80)
            }
        } else {
            // if button needs to close
            UIView.animate(withDuration: 0.15) {
                // 回复按钮
                self.middleButton.transform = CGAffineTransform(rotationAngle: 0)
                // 更新样式
                self.middleButton.backgroundColor = buttonBGColor
                self.middleButton.imageView?.tintColor = .white
                self.middleButton.layer.borderWidth = 0

                // button is no longer on selected mode
                self.buttonTapped.toggle()

                // perform an action
                self.removeButtons()
            }
        }
    }

    @objc func backgroundPressed(sender: UIButton) {
        if buttonTapped == true {
            middleButton.sendActions(for: .touchUpInside)
        } else {
            sender.isUserInteractionEnabled = false
            sender.removeFromSuperview()
        }
    }

    @objc func optionHandler(sender: UIButton) {
        switch index {
        case 0: print("Button 1 was pressed.")
        case 1: print("Button 2 was pressed.")
        default: print("Button 3 was pressed.")
        }
    }
}
