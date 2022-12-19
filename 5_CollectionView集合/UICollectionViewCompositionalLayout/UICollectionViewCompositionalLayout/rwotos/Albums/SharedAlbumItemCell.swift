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

class SharedAlbumItemCell: UICollectionViewCell {
  static let reuseIdentifer = "shared-album-item-cell-reuse-identifier"
  let titleLabel = UILabel()
  let ownerLabel = UILabel()
  let featuredPhotoView = UIImageView()
  let ownerAvatar = UIImageView()
  let contentContainer = UIView()

  let owner: Owner;

  enum Owner: Int, CaseIterable {
    case Tom
    case Matt
    case Ray

    func avatar() -> UIImage {
      switch self {
      case .Tom: return #imageLiteral(resourceName: "tom_profile")
      case .Matt: return #imageLiteral(resourceName: "matt_profile")
      case .Ray: return #imageLiteral(resourceName: "ray_profile")
      }
    }

    func name() -> String {
      switch self {
      case .Tom: return "Tom Elliott"
      case .Matt: return "Matt Galloway"
      case .Ray: return "Ray Wenderlich"
      }
    }
  }

  var title: String? {
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
    self.owner = Owner.allCases.randomElement()!
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension SharedAlbumItemCell {
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

    ownerLabel.translatesAutoresizingMaskIntoConstraints = false
    ownerLabel.text = "From \(owner.name())"
    ownerLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    ownerLabel.adjustsFontForContentSizeCategory = true
    ownerLabel.textColor = .placeholderText
    contentContainer.addSubview(ownerLabel)

    ownerAvatar.translatesAutoresizingMaskIntoConstraints = false
    ownerAvatar.image = owner.avatar()
    ownerAvatar.layer.cornerRadius = 15
    ownerAvatar.layer.borderColor = UIColor.systemBackground.cgColor
    ownerAvatar.layer.borderWidth = 1
    ownerAvatar.clipsToBounds = true
    contentContainer.addSubview(ownerAvatar)

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

      ownerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      ownerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      ownerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ownerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      ownerAvatar.heightAnchor.constraint(equalToConstant: 30),
      ownerAvatar.widthAnchor.constraint(equalToConstant: 30),
      ownerAvatar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
      ownerAvatar.bottomAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: -spacing),
    ])
  }
}
