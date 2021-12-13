//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Qilin Hu on 2021/12/10.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var photoDescription: String?
    
    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    // 添加 Accessibility 支持
    override var isAccessibilityElement: Bool {
        get {
            return true
        }
        set {
            // Ignore attempts to set
        }
    }
    
    // 元素描述信息
    override var accessibilityLabel: String? {
        get {
            return photoDescription
        }
        set {
            // Ignore attempts to set
        }
    }
    
    // 为了告知用户可以对单元格执行操作，您将添加UIAccessibilityTraits.button特性
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return super.accessibilityTraits.union([.image, .button])
        }
        set {
            // Ignore attempts to set
        }
    }
    
}
