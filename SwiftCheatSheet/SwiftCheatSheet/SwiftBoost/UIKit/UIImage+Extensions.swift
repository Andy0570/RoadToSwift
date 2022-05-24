//
//  UIImage+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import UIKit

extension UIImage {
    /// 生成从左到右的渐变图片
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        // 从左到右渐变，默认是从上到下，即 (0.5, 0.0) -> (0.5, 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }

    /// 将图片裁剪为正方形
    /// let img = UIImage() // Must be a real UIImage
    /// let imgSquared = img.squared()
    func squared() -> UIImage? {
        let originalWidth  = size.width
        let originalHeight = size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0

        if originalWidth > originalHeight {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
        } else if originalHeight > originalWidth {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }

        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        guard let imageRef = cgImage?.cropping(to: cropSquare) else {
            return nil
        }

        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }

    /// 调整图片像素大小
    /// let img2 = UIImage() // Must be a real UIImage
    /// let img2Thumb = img2.resized(maxSize: 512)
    func resized(maxSize: CGFloat) -> UIImage? {
        let scale: CGFloat
        if size.width > size.height {
            scale = maxSize / size.width
        } else {
            scale = maxSize / size.height
        }

        let newWidth = size.width * scale
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
