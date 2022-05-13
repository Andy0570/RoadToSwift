//
//  RangeSlider.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit

/// 它是什么：一个由四个属性定义的滑块：minimumValue、maximumValue、lowerValue 和 upperValue。
/// 它的作用：允许用户更直观地定义一个数字范围。
/// 使用场景：编辑视频时裁剪时长、筛选商品时指定价格区间。
/// Reference: <https://www.raywenderlich.com/7595-how-to-make-a-custom-control-tutorial-a-reusable-slider>
class RangeSlider: UIControl {
    /// 范围的最小值
    var minimumValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }

    /// 范围的最大值
    var maximumValue: CGFloat = 1 {
        didSet {
            updateLayerFrames()
        }
    }

    /// 用户设置的下限值
    var lowerValue: CGFloat = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }

    /// 用户设置的上限值
    var upperValue: CGFloat = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }

    var trackintColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    var thumbImage = UIImage(named: "Oval") {
        didSet {
            upperThumbImageView.image = thumbImage
            lowerThumbImageView.image = thumbImage
            updateLayerFrames()
        }
    }

    var highlightedThumbImage = UIImage(named: "HighlightedOval") {
      didSet {
        upperThumbImageView.highlightedImage = highlightedThumbImage
        lowerThumbImageView.highlightedImage = highlightedThumbImage
        updateLayerFrames()
      }
    }

    // 覆写 frame 属性并添加属性观察器
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    // 跟踪触摸位置
    private var previousLocation = CGPoint()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)

        lowerThumbImageView.image = thumbImage
        addSubview(lowerThumbImageView)

        upperThumbImageView.image = thumbImage
        addSubview(upperThumbImageView)

        updateLayerFrames()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateLayerFrames()
    }

    private func updateLayerFrames() {
        guard let thumbImage = thumbImage else {
            return
        }

        // 将 frame 的更新包装到一个事务（Transaction）中
        CATransaction.begin()
        CATransaction.setDisableActions(true) // 禁用图层上的隐式动画

        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()

        lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue), size: thumbImage.size)
        upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue), size: thumbImage.size)

        CATransaction.commit()
    }

    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        guard let thumbImage = thumbImage else {
            return CGPoint.zero
        }

        let x = positionForValue(value) - thumbImage.size.width / 2.0
        return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
    }

    public func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
}

extension RangeSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 将触摸事件转换为控件的坐标空间
        previousLocation = touch.location(in: self)

        // 当触摸事件的坐标空间坐落在两个触点图片上时，继续跟踪触摸事件
        if lowerThumbImageView.frame.contains(previousLocation) {
            lowerThumbImageView.isHighlighted = true
        } else if upperThumbImageView.frame.contains(previousLocation) {
            upperThumbImageView.isHighlighted = true
        }

        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        // 该增量位置确定了用户手指移动的点数
        let deltaLocation = location.x - previousLocation.x
        // 根据控件的最小值和最大值将其转换为缩放的增量值
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width

        previousLocation = location

        // 根据用户将滑块拖动到的位置来调整上限值或下限值
        if lowerThumbImageView.isHighlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbImageView.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }

        // 通过 Target-Action 模式发送通知
        sendActions(for: .valueChanged)

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
    }

    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
}
