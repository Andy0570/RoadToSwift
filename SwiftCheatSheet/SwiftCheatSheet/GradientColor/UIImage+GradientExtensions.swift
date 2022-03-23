//
//  UIImage+GradientExtensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/23.
//

import UIKit

extension UIImage {
    /// 生成从左到右的渐变图片
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        // 从左到右渐变，默认是从上到下
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }
}
