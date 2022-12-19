/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class ChecklistItemTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityTraits = .button
        label.accessibilityHint = "Double tap to open"
        label.isAccessibilityElement = true
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    lazy var completionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "square", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.systemBlue
        button.isUserInteractionEnabled = true
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        button.accessibilityLabel = "Mark as Complete"
        return button
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    var item: ChecklistItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            let subtitleText = dateFormatter.string(from: item.date)
            
            titleLabel.text = item.title
            subtitleLabel.text = subtitleText
            
            // The title acts as the cell to voice over because marking the cell as the accessibility element would prevent the checkmark box from being discovered by VoiceOver and other accessibility technologies
            titleLabel.accessibilityLabel = "\(item.title)\n\(subtitleText)"
            
            updateCompletionStatusAccessibilityInformation()
        }
    }
    
    static let reuseIdentifier = String(describing: ChecklistItemTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(completionButton)
        
        completionButton.addTarget(self, action: #selector(userDidTapOnCheckmarkBox), for: .touchUpInside)
        
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if traitCollection.horizontalSizeClass == .compact {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 4),
                completionButton.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -4)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                completionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: completionButton.leadingAnchor, constant: -5),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            completionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            completionButton.widthAnchor.constraint(equalToConstant: 30),
            completionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func userDidTapOnCheckmarkBox() {
        guard let item = item else {
            return
        }
        
        item.completed.toggle()
        
        updateCompletionStatusAccessibilityInformation()
        
        UIView.transition(
            with: completionButton,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                let symbolName: String
                
                if item.completed {
                    symbolName = "checkmark.square"
                } else {
                    symbolName = "square"
                }
                
                let configuration = UIImage.SymbolConfiguration(scale: .large)
                let image = UIImage(systemName: symbolName, withConfiguration: configuration)
                self.completionButton.setImage(image, for: .normal)
            },
            completion: nil)
    }
    
    private func updateCompletionStatusAccessibilityInformation() {
        if item?.completed == true {
            completionButton.accessibilityLabel = "Mark as incomplete"
        } else {
            completionButton.accessibilityLabel = "Mark as complete"
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutSubviews()
    }
}
