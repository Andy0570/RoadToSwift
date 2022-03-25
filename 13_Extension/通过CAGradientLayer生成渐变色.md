### 示例一

```swift
/**
 使用示例:
 self.view.applyGradient(colors: [UIColor.red.cgColor, UIColor.blue.cgColor],
                        locations: [0.0, 1.0],
                        direction: .topToBottom)
 */
extension UIView {
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.1, 1.0], direction: Direction = .topToBottom) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        self.layer.addSublayer(gradientLayer)
    }
}
```



### 示例二

```swift
//
//  LDGradientView.swift
//  LDGradientView
//
//  Created by Qilin Hu on 2020/11/14.
//  Reference: <https://appcodelabs.com/create-ibdesignable-gradient-view-swift>
//

import UIKit

@IBDesignable
class LDGradientView: UIView {
    
    // 渐变起始颜色
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // 渐变终止颜色
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // 渐变的角度，从 0 开始逆时针方向的度数
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }
    
    // 渐变层
    private var gradient: CAGradientLayer?
    
    // MARK: 初始化方法
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        installGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }
    
    override var frame: CGRect {
        didSet {
            updateGradient()
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        // 当约束条件被用于父类视图上时，这一点至关重要
        updateGradient()
    }
    
    // 创建渐变，并将其添加到图层上
    private func installGradient() {
        // 如果 layer 层上已经存在渐变，则将其移除
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }
    
    // 创建渐变层方法
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    // 更新已存在的渐变
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
            gradient.frame = self.bounds
        }
    }
    
    // 创建指向对应角度的向量
    func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // 获取向量的起始点和终点
        let end = pointForAngle(angle)
        let start = oppositePoint(end)
        // 转换为渐变空间坐标
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // 弧度转换
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x, y) 是以单位圆为单位。外推到单位平方，得到完整的向量长度。
        if abs(x) > abs(y) {
            // 外推 x 为单位长度
            x = (x > 0 ? 1 : -1)
            y = x * tan(radians)
        } else {
            // 外推 y 为单位长度
            y = (y > 0 ? 1 : -1)
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // 输入点在有符号的单位空间 (-1,-1) 至 (1,1) 转换为渐变空间。(0,0) 到 (1,1)，Y轴翻转。
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    // 当视图在 IB 上被创建时，确保渐变图层正确初始化
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}
```

