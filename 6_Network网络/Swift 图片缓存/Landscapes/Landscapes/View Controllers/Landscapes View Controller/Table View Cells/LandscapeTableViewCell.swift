//
//  LandscapeTableViewCell.swift
//  Landscapes
//
//  Created by Bart Jacobs on 20/04/2021.
//

import UIKit

/// 1.取消网络图片请求：<https://cocoacasts.com/image-caching-in-swift-cancelling-image-requests>
/// （后续章节需要付费阅读😢）
/// 使用 Kingfisher 缓存图片：<https://cocoacasts.com/image-caching-in-swift-image-caching-with-kingfisher>
final class LandscapeTableViewCell: UITableViewCell {

    // MARK: - Static Properties
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    // MARK: - Properties
    
    @IBOutlet private var titleLabel: UILabel!
    
    private lazy var imageService = ImageService()
    private var imageRequest: Cancellable?
    
    // MARK: -
    
    @IBOutlet private var thumbnailImageView: UIImageView! {
        didSet {
            // Configure Thumbnail Image View
            thumbnailImageView.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: -
    
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Public API
    
    func configure(title: String, imageUrl: URL) {
        // Configure Title Label
        titleLabel.text = title
        
        // Animate Activity Indicator View
        activityIndicatorView.startAnimating()
        
        // Request Image Using Image Service
        imageRequest = imageService.image(for: imageUrl) { [weak self] image in
            // Update Thumbnail Image View
            self?.thumbnailImageView.image = image
        }
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset Thumbnail Image View
        thumbnailImageView.image = nil
        
        // Cancel Image Request
        imageRequest?.cancel()
    }

}
