//
//  UIColor+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import UIKit

extension UIColor {
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /**
     通过颜色生成图片
     
     Usage:
     let image0 = UIColor.orange.image(CGSize(width: 128, height: 128))
     let image1 = UIColor.yellow.image()
     */
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { (rendererContext) in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    // 需要在 Asset catalogs 中创建相同名称的颜色
    static var accent: UIColor {
        UIColor(named: "Accent")!
    }
    
    static var primary: UIColor {
        UIColor(named: "Primary")!
    }
    
    static var primaryText: UIColor {
        UIColor(named: "PrimaryText")!
    }
}
