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

class SyncingBadgeView: UICollectionReusableView {
  static let reuseIdentifier = "syncing-badge"
  let imageView = UIImageView(image: #imageLiteral(resourceName: "syncIcon"))

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    startAnimating()
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
}

extension SyncingBadgeView {
  func configure() {
    backgroundColor = .white

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    addSubview(imageView)

    let inset = CGFloat(2)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
    ])

    let radius = bounds.width / 2.0
    layer.cornerRadius = radius
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 1.0
  }

  func startAnimating() {
    let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotation.toValue = Double.pi * 2
    rotation.duration = 1
    rotation.isCumulative = true
    rotation.repeatCount = Float.greatestFiniteMagnitude
    imageView.layer.add(rotation, forKey: "rotationAnimation")
  }
}
