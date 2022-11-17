import UIKit

class PhotoCell: UICollectionViewCell {

  @IBOutlet var imageView: UIImageView!
  var representedAssetIdentifier: String!

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  func flash() {
    imageView.alpha = 0
    setNeedsDisplay()
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      self?.imageView.alpha = 1
    })
  }
}
