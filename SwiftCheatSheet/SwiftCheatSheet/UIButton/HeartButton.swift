//
//  HeartButton.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit

/// Reference: <https://github.com/SoufianHossam/SHToggleButton>
@IBDesignable
final class HeartButton: UIButton {
    // MARK: - Properties
    @IBInspectable var defaultImage: UIImage? {
        didSet {
            setImage(defaultImage, for: .normal)
        }
    }

    @IBInspectable var selectedImage: UIImage? {
        didSet {
            setImage(selectedImage, for: .selected)
        }
    }

    @IBInspectable var animatedImage: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isSelected = false
        addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc func heartButtonTapped(_ sender: UIButton) {
        isSelected.toggle()

        if isSelected {
            bounceAnimation()
            fallingAnimation()
        }
    }

    // 按钮缩放动画
    private func bounceAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }

    // 礼花动画
    private func fallingAnimation() {
        guard let animatedImage = animatedImage else {
            return
        }

        for _ in 0...3 {
            let duration = Double.random(in: 0.5...1.0)

            let imageView = UIImageView(image: animatedImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
                imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
            ])

            // 添加关键帧路径动画
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = generateFallingPath(center: imageView.center)
            animation.duration = duration

            /// fillMode：决定当前对象在非 active 时间段的行为。比如动画开始之前，动画结束之后。
            /// 动画结束后保持结束时的状态，需要同时设置以下两者：
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false

            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            imageView.layer.add(animation, forKey: nil)

            // 隐藏动画
            UIView.animate(withDuration: duration) {
                imageView.alpha = 0
            } completion: { _ in
                imageView.removeFromSuperview()
            }
        }
    }

    // 生成贝塞尔曲线路径
    private func generateFallingPath(center: CGPoint) -> CGPath {
        let randomValue = CGFloat(Float.random(in: -50...50))

        let path = UIBezierPath()
        path.move(to: CGPoint(x: center.x, y: center.y))

        let endPoint = CGPoint(x: center.x + randomValue, y: center.y + 200)
        let controlPoint1 = CGPoint(x: center.x + randomValue, y: center.y - 80)
        let controlPoint2 = CGPoint(x: center.x + randomValue, y: center.y - 80)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)

        return path.cgPath
    }
}
