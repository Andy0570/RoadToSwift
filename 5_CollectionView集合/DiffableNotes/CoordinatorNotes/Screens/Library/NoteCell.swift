//
//  NoteCell.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 27/11/2020.
//

import UIKit

class NoteCell: UICollectionViewCell, Providable {
        
    typealias ProvidedItem = Note
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .quaternarySystemFill
        layer.cornerRadius = 16.0
    }
    
    public func provide(_ note: Note) {
        self.textLabel.text = note.text
        self.dateLabel.text = note.formattedDate
    }
    
    // MARK: - Layout
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(layoutAttributes.frame.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: contentView.systemLayoutSizeFitting(CGSize(width: contentView.bounds.width, height: 1)).height)
    }
}
