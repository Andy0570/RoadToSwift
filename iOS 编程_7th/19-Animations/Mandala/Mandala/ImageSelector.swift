//
//  ImageSelector.swift
//  Mandala
//
//  Created by Qilin Hu on 2021/12/9.
//

import UIKit

// 自定义 UIControl 子类
class ImageSelector: UIControl {
    
    // 当前选中的 UIButton 索引
    var selectedIndex = 0 {
        didSet {
            if selectedIndex < 0 {
                selectedIndex = 0
            }
            if selectedIndex >= imageButtons.count {
                selectedIndex = imageButtons.count - 1
            }
            
            // 更新高亮背景视图的背景颜色
            highlightView.backgroundColor = highlightColor(forIndex: selectedIndex)
            
            // 更新高亮背景视图的 centerX
            let imageButton = imageButtons[selectedIndex]
            highlightViewXConstraint = highlightView.centerXAnchor.constraint(equalTo: imageButton.centerXAnchor)
        }
    }
        
    // 视图类：包含 UIButton 的数组
    var imageButtons: [UIButton] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            imageButtons.forEach { selectorStackView.addArrangedSubview($0) }
        }
    }
    
    // 模型类：图片
    var images: [UIImage] = [] {
        didSet {
            imageButtons = images.map { image in
                let imageButton = UIButton()
                imageButton.setImage(image, for: .normal)
                imageButton.imageView?.contentMode = .scaleAspectFit
                imageButton.adjustsImageWhenHighlighted = false
                imageButton.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)
                return imageButton
            }
            
            // !!!: 初始化设置默认索引
            selectedIndex = 0
        }
    }
    
    // 模型类，高亮背景视图对应的颜色数组
    var highlightColors: [UIColor] = [] {
        didSet {
            highlightView.backgroundColor = highlightColor(forIndex: selectedIndex)
        }
    }
    
    private let selectorStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // 高亮背景
    private let highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 高亮背景视图的 X 坐标动态变化
    private var highlightViewXConstraint: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            highlightViewXConstraint.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViewHierarchy()
    }
            
    override func layoutSubviews() {
        super.layoutSubviews()
        
        highlightView.layer.cornerRadius = highlightView.bounds.width / 2.0
    }
    
    // MARK: - Actions
    
    @objc func imageButtonTapped(_ sender: UIButton) {
        guard let buttonIndex = imageButtons.firstIndex(of: sender) else {
            preconditionFailure("The buttons and images are not parallel.")
        }
        
//        // 示例一：渐入渐出动画
//        let selectionAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
//            self.selectedIndex = buttonIndex
//            // 如果在执行动画的 block 中更新约束，由于昂贵的计算，系统默认不会触发动画。
//            // 因此，这里我们明确要求系统立即触发重新计算 frame，迫使视图根据最新的约束来布局其子视图。
//            self.layoutIfNeeded()
//        }
//        selectionAnimator.startAnimation()
        
        /**
         示例二：Spring 弹簧动画
         
         dampingRatio 阻尼比是衡量弹簧动画“弹性”的一个指标。它的值介于0.0和1.0之间。
         接近 0.0 的数值会更有弹性，因此会有更多的振荡。
         接近 1.0 的数值将会少一些“弹性”，因此振荡也会少一些。
         */
        let selectionAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.7) {
            self.selectedIndex = buttonIndex
            self.layoutIfNeeded()
        }
        selectionAnimator.startAnimation()
        
        // 调用 sendActions(for:) 方法向外传递事件
        sendActions(for: .valueChanged)
    }
    
    // MARK: - Private
    
    private func configureViewHierarchy() {
        addSubview(selectorStackView)
        insertSubview(highlightView, belowSubview: selectorStackView)
        
        NSLayoutConstraint.activate([
            selectorStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorStackView.topAnchor.constraint(equalTo: topAnchor),
            selectorStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            highlightView.heightAnchor.constraint(equalTo: highlightView.widthAnchor),
            highlightView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            highlightView.centerYAnchor.constraint(equalTo: selectorStackView.centerYAnchor)
        ])
    }
    
    func highlightColor(forIndex index: Int) -> UIColor {
        guard index >= 0 && index < highlightColors.count else {
            return UIColor.blue.withAlphaComponent(0.6)
        }
        
        return highlightColors[index]
    }
    

}
