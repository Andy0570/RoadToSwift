//
//  RangeSliderTrackLayer.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit

/// 使用 Core Graphics API 渲染两个拇指滑动的轨道
class RangeSliderTrackLayer: CALayer {
    // Layer 到 Slider 是反向引用，使用 weak 声明
    weak var rangeSlider: RangeSlider?

    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }

        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)

        ctx.setFillColor(slider.trackintColor.cgColor)
        ctx.fillPath()

        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = slider.positionForValue(slider.lowerValue)
        let upperValuePosition = slider.positionForValue(slider.upperValue)
        let rect = CGRect(x: lowerValuePosition, y: 0,
                          width: upperValuePosition - lowerValuePosition,
                          height: bounds.height)
        ctx.fill(rect)
    }
}
