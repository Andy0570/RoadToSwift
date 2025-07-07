//
//  LandscapeTableViewCell.swift
//  Landscapes
//
//  Created by Bart Jacobs on 20/04/2021.
//

import UIKit

/// https://cocoacasts.com/image-caching-in-swift-cancelling-image-requests
final class LandscapeTableViewCell: UITableViewCell {

    // MARK: - Static Properties
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    // MARK: - Properties
    
    @IBOutlet private var titleLabel: UILabel!
    
    private lazy var imageService = ImageService()
    
    // MARK: -
    
    @IBOutlet private(set) var thumbnailImageView: UIImageView! {
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
        imageService.image(for: imageUrl) { [weak self] image in
            // Update Thumbnail Image View
            self?.thumbnailImageView.image = image
        }
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset Thumbnail Image View
        thumbnailImageView.image = nil
    }

}
