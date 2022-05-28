//
//  FastCartButton.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit

/// 自定义 UIKit 控件，带动画的购物车按钮
/// Reference: <https://danielgauthier.me/2020/01/21/custom-control.html>
/// GitHub: <https://github.com/danielmgauthier/danielmgauthier.github.io/blob/master/_posts/2020-01-21-custom-control.md>
class FastCartButton: UIControl {
    // MARK: - Properties

    let buttonView: UIView = .make(backgroundColor: .systemPink, cornerRadius: 26.0)
    let imageView: UIImageView = .make(image: UIImage(systemName: "cart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22.0, weight: .bold, scale: .default)), tintColor: .white)
    let topWhiteLine: UIView = .make(backgroundColor: .white, cornerRadius: 1.0)
    let middleWhiteLine: UIView = .make(backgroundColor: .white, cornerRadius: 1.0)
    let bottomWhiteLine: UIView = .make(backgroundColor: .white, cornerRadius: 1.0)
    let topPinkLine: UIView = .make(backgroundColor: .systemPink, cornerRadius: 1.0)
    let middlePinkLine: UIView = .make(backgroundColor: .systemPink, cornerRadius: 1.0)
    let bottomPinkLine: UIView = .make(backgroundColor: .systemPink, cornerRadius: 1.0)

    var imageViewCenterXConstraint: NSLayoutConstraint!
    var lineWidthConstraintGroup: [NSLayoutConstraint]!
    var lineTrailingConstraintGroup: [NSLayoutConstraint]!

    enum TouchState {
        case idle // 没有交互或动画正在发生
        case down // 按钮当前被按下
        // swiftlint:disable:next identifier_name
        case up // 按钮被松开（即触发了 touchUpInside）
        case cancelled // 按钮被取消点击
    }

    // 计算属性，跟踪按钮当前状态
    private var touchState: TouchState = .idle {
        didSet {
            guard touchState != oldValue else {
                return
            }

            switch touchState {
            case .idle:
                break
            case .down:
                performTouchDownAnimations()
            case .up:
                performTouchUpAnimations()
            case .cancelled:
                performTouchCancelledAnimations()
            }
        }
    }

    /// 如果用户点击一个控件，然后将他们的手指从该控件拖出一个相对较小的距离（<= 大约 70 点），UIControl
    /// 仍然认为自己被 “按下”，或者高亮显示；当用户随后释放时，仍然会触发 touchUpInside 事件，即使触摸实际上不再位于控件内部。
    private var extendedBounds: CGRect {
        bounds.insetBy(dx: -70, dy: -70)
    }

    // MARK: - View Methods

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        setupButton()
        setupImageView()
        setupWhiteLines()
        setupPinkLines()
    }

    private func setupButton() {
        buttonView.clipsToBounds = true
        addSubview(buttonView)
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonView.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonView.widthAnchor.constraint(equalToConstant: 52.0),
            buttonView.heightAnchor.constraint(equalToConstant: 52.0)
        ])
    }

    private func setupImageView() {
        buttonView.addSubview(imageView)
        imageViewCenterXConstraint = imageView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor)
        NSLayoutConstraint.activate([
            imageViewCenterXConstraint,
            imageView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
    }

    private func setupWhiteLines() {
        buttonView.addSubview(topWhiteLine)
        buttonView.addSubview(middleWhiteLine)
        buttonView.addSubview(bottomWhiteLine)

        lineWidthConstraintGroup = [
            topWhiteLine.widthAnchor.constraint(equalToConstant: 24),
            middleWhiteLine.widthAnchor.constraint(equalToConstant: 24),
            bottomWhiteLine.widthAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(lineWidthConstraintGroup)

        lineTrailingConstraintGroup = [
            topWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 11),
            middleWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 8),
            bottomWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 14)
        ]
        NSLayoutConstraint.activate(lineTrailingConstraintGroup)

        NSLayoutConstraint.activate([
            topWhiteLine.bottomAnchor.constraint(equalTo: middleWhiteLine.topAnchor, constant: -3),
            topWhiteLine.heightAnchor.constraint(equalToConstant: 2),

            middleWhiteLine.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor, constant: 1),
            middleWhiteLine.heightAnchor.constraint(equalToConstant: 2),

            bottomWhiteLine.topAnchor.constraint(equalTo: middleWhiteLine.bottomAnchor, constant: 3),
            bottomWhiteLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    private func setupPinkLines() {
        topPinkLine.alpha = 0.6
        middlePinkLine.alpha = 0.6
        bottomPinkLine.alpha = 0.6

        insertSubview(topPinkLine, belowSubview: buttonView)
        insertSubview(middlePinkLine, belowSubview: buttonView)
        insertSubview(bottomPinkLine, belowSubview: buttonView)

        NSLayoutConstraint.activate([
            topPinkLine.centerYAnchor.constraint(equalTo: topWhiteLine.centerYAnchor),
            topPinkLine.trailingAnchor.constraint(equalTo: topWhiteLine.trailingAnchor),
            topPinkLine.heightAnchor.constraint(equalTo: topWhiteLine.heightAnchor),
            topPinkLine.widthAnchor.constraint(equalTo: topWhiteLine.widthAnchor),

            middlePinkLine.centerYAnchor.constraint(equalTo: middleWhiteLine.centerYAnchor),
            middlePinkLine.trailingAnchor.constraint(equalTo: middleWhiteLine.trailingAnchor),
            middlePinkLine.heightAnchor.constraint(equalTo: middleWhiteLine.heightAnchor),
            middlePinkLine.widthAnchor.constraint(equalTo: middleWhiteLine.widthAnchor),

            bottomPinkLine.centerYAnchor.constraint(equalTo: bottomWhiteLine.centerYAnchor),
            bottomPinkLine.trailingAnchor.constraint(equalTo: bottomWhiteLine.trailingAnchor),
            bottomPinkLine.heightAnchor.constraint(equalTo: bottomWhiteLine.heightAnchor),
            bottomPinkLine.widthAnchor.constraint(equalTo: bottomWhiteLine.widthAnchor)
        ])
    }

    private func performTouchDownAnimations() {
        // 拉长购物车线条
        NSLayoutConstraint.deactivate(lineWidthConstraintGroup)
        lineWidthConstraintGroup.removeAll()
        lineWidthConstraintGroup = [
            topWhiteLine.widthAnchor.constraint(equalToConstant: 24),
            middleWhiteLine.widthAnchor.constraint(equalToConstant: 24),
            bottomWhiteLine.widthAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(lineWidthConstraintGroup)

        // 将线条远离购物车，模拟类似“拉弓”的效果
        NSLayoutConstraint.deactivate(lineTrailingConstraintGroup)
        lineTrailingConstraintGroup.removeAll()
        lineTrailingConstraintGroup = [
            topWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 8.0 + CGFloat.random(in: -4.0...4.0)),
            middleWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 8.0 + CGFloat.random(in: -4.0...4.0)),
            bottomWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 8.0 + CGFloat.random(in: -4.0...4.0))
        ]
        NSLayoutConstraint.activate(lineTrailingConstraintGroup)

        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            self.layoutIfNeeded()
            self.topPinkLine.alpha = 1.0
            self.middlePinkLine.alpha = 1.0
            self.bottomPinkLine.alpha = 1.0
            self.imageView.transform = CGAffineTransform(rotationAngle: -0.1)
        }, completion: nil)
    }

    private func performTouchUpAnimations() {
        UIView.animateKeyframes(withDuration: 0.8, delay: 0.0, options: [.allowUserInteraction, .calculationModeCubic, .beginFromCurrentState]) {
            // 1.首先，我们稍微拉回推车，逆时针旋转它（比我们在触摸按下时所做的稍微远一点），然后将线拉回来一点与推车同步。
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.35) {
                self.imageViewCenterXConstraint.constant = -4.0
                self.imageView.transform = CGAffineTransform(rotationAngle: -0.15)

                NSLayoutConstraint.deactivate(self.lineTrailingConstraintGroup)
                self.lineTrailingConstraintGroup.removeAll()
                self.lineTrailingConstraintGroup = [
                    self.topWhiteLine.trailingAnchor.constraint(equalTo: self.buttonView.leadingAnchor, constant: 2.0 + CGFloat.random(in: -4.0...4.0)),
                    self.middleWhiteLine.trailingAnchor.constraint(equalTo: self.buttonView.leadingAnchor, constant: 2.0 + CGFloat.random(in: -4.0...4.0)),
                    self.bottomWhiteLine.trailingAnchor.constraint(equalTo: self.buttonView.leadingAnchor, constant: 2.0 + CGFloat.random(in: -4.0...4.0))
                ]
                NSLayoutConstraint.activate(self.lineTrailingConstraintGroup)

                self.layoutIfNeeded()
            }

            // 2.一旦推车开始向前移动，我们就迅速将推车旋转回其静止位置，这给人的印象是推车在起飞时 “砰砰” 地回到它的 4 个轮子上。
            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.04) {
                self.imageView.transform = .identity
            }

            // 3.在这里，我们实际上将购物车移到右侧，离开按钮的边缘。
            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.5) {
                self.imageViewCenterXConstraint.constant = 104.0
                self.layoutIfNeeded()
            }

            // 4.我们还将线条向右移动，以跟随购物车离开按钮的边缘。
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.5) {
                NSLayoutConstraint.deactivate(self.lineTrailingConstraintGroup)
                self.lineTrailingConstraintGroup.removeAll()
                self.lineTrailingConstraintGroup = [
                    self.topWhiteLine.trailingAnchor.constraint(equalTo: self.buttonView.leadingAnchor, constant: 104.0),
                    self.middleWhiteLine.trailingAnchor.constraint(equalTo: self.buttonView.leadingAnchor, constant: 104.0),
                    self.bottomWhiteLine.trailingAnchor.constraint(equalTo: self.buttonView.leadingAnchor, constant: 104.0)
                ]
                NSLayoutConstraint.activate(self.lineTrailingConstraintGroup)

                NSLayoutConstraint.deactivate(self.lineWidthConstraintGroup)
                self.lineWidthConstraintGroup.removeAll()
                self.lineWidthConstraintGroup = [
                    self.topWhiteLine.widthAnchor.constraint(equalToConstant: 48.0 + CGFloat.random(in: -4.0...4.0)),
                    self.middleWhiteLine.widthAnchor.constraint(equalToConstant: 48.0 + CGFloat.random(in: -4.0...4.0)),
                    self.bottomWhiteLine.widthAnchor.constraint(equalToConstant: 48.0 + CGFloat.random(in: -4.0...4.0))
                ]
                NSLayoutConstraint.activate(self.lineWidthConstraintGroup)

                self.layoutIfNeeded()
            }

            // 5.最后，我们只是以足够快的速度淡出粉红色线条，以至于当它们的前缘到达按钮的右边缘时，它们不再可见。
            UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.2) {
                self.topPinkLine.alpha = 0.0
                self.middlePinkLine.alpha = 0.0
                self.bottomPinkLine.alpha = 0.0
            }
        } completion: { _ in
            self.touchState = .idle
        }
    }

    private func performTouchCancelledAnimations() {
        NSLayoutConstraint.deactivate(lineWidthConstraintGroup)
        lineWidthConstraintGroup.removeAll()
        lineWidthConstraintGroup = [
            topWhiteLine.widthAnchor.constraint(equalToConstant: 24),
            middleWhiteLine.widthAnchor.constraint(equalToConstant: 24),
            bottomWhiteLine.widthAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(lineWidthConstraintGroup)

        NSLayoutConstraint.deactivate(lineTrailingConstraintGroup)
        lineTrailingConstraintGroup.removeAll()
        lineTrailingConstraintGroup = [
            topWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 11),
            middleWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 8),
            bottomWhiteLine.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 14)
        ]
        NSLayoutConstraint.activate(lineTrailingConstraintGroup)

        imageViewCenterXConstraint.isActive = false
        imageViewCenterXConstraint.constant = 0.0
        imageViewCenterXConstraint.isActive = true

        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction) {
            self.layoutIfNeeded()
            self.topPinkLine.alpha = 0.6
            self.middlePinkLine.alpha = 0.6
            self.bottomPinkLine.alpha = 0.6
            self.imageView.transform = .identity
        } completion: { _ in
            self.touchState = .idle
        }
    }

    // MARK: - Overrides

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard touchState == .idle else {
            return false
        }

        touchState = .down
        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        if extendedBounds.contains(point) {
            touchState = .down
        } else {
            touchState = .cancelled
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if let point = touch?.location(in: self), extendedBounds.contains(point) {
            touchState = .up
        } else {
            touchState = .cancelled
        }
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        touchState = .cancelled
    }
}

private extension UIView {
    static func make(backgroundColor: UIColor, cornerRadius: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }
}

private extension UIImageView {
    static func make(image: UIImage?, tintColor: UIColor) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = tintColor
        return imageView
    }
}
