/// Copyright (c) 2019 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class FeaturedAlbumItemCell: UICollectionViewCell {
  static let reuseIdentifer = "featured-album-item-cell-reuse-identifier"
  let titleLabel = UILabel()
  let imageCountLabel = UILabel()
  let featuredPhotoView = UIImageView()
  let contentContainer = UIView()

  var title: String? {
    didSet {
      configure()
    }
  }

  var totalNumberOfImages: Int? {
    didSet {
      configure()
    }
  }

  var featuredPhotoURL: URL? {
    didSet {
      configure()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FeaturedAlbumItemCell {
  func configure() {
    contentContainer.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(featuredPhotoView)
    contentView.addSubview(contentContainer)

    featuredPhotoView.translatesAutoresizingMaskIntoConstraints = false
    if let featuredPhotoURL = featuredPhotoURL {
      featuredPhotoView.image = UIImage(contentsOfFile: featuredPhotoURL.path)
    }
    featuredPhotoView.layer.cornerRadius = 4
    featuredPhotoView.clipsToBounds = true
    contentContainer.addSubview(featuredPhotoView)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    titleLabel.adjustsFontForContentSizeCategory = true
    contentContainer.addSubview(titleLabel)

    imageCountLabel.translatesAutoresizingMaskIntoConstraints = false
    if let totalNumberOfImages = totalNumberOfImages {
      imageCountLabel.text = "\(totalNumberOfImages) photos"
    }
    imageCountLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    imageCountLabel.adjustsFontForContentSizeCategory = true
    imageCountLabel.textColor = .placeholderText
    contentContainer.addSubview(imageCountLabel)

    let spacing = CGFloat(10)
    NSLayoutConstraint.activate([
      contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      featuredPhotoView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
      featuredPhotoView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
      featuredPhotoView.topAnchor.constraint(equalTo: contentContainer.topAnchor),

      titleLabel.topAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: spacing),
      titleLabel.leadingAnchor.constraint(equalTo: featuredPhotoView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: featuredPhotoView.trailingAnchor),

      imageCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      imageCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
