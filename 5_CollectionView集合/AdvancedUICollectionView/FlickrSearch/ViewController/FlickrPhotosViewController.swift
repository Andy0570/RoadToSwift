/// UICollectionView Tutorial: Headers, Selection and Reordering
/// Reference: <https://www.raywenderlich.com/21959913-uicollectionview-tutorial-headers-selection-and-reordering>

import UIKit

enum FlickrConstants {
    static let reuseIdentifier = "FlickrCell"
    static let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    static let itemsPerRow: CGFloat = 3
}

final class FlickrPhotosViewController: UICollectionViewController {
    // MARK: - Properties

    var selectedPhotos: [FlickrPhoto] = []
    let shareTextLabel = UILabel()
    var isSharing = false {
        didSet {
            collectionView.allowsMultipleSelection = isSharing

            collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
            selectedPhotos.removeAll()

            guard let shareButton = navigationItem.rightBarButtonItems?.first else {
                return
            }

            guard isSharing else {
                navigationItem.setRightBarButtonItems([shareButton], animated: true)
                return
            }

            if largePhotoIndexPath != nil {
                largePhotoIndexPath = nil
            }

            updateSharedPhotoCountLabel()

            let sharingItem = UIBarButtonItem(customView: shareTextLabel)
            let items: [UIBarButtonItem] = [shareButton, sharingItem]
            navigationItem.setRightBarButtonItems(items, animated: true)
        }
    }

    // 保存当前选择的照片项的索引路径
    var largePhotoIndexPath: IndexPath? {
        didSet {
            var indexPaths: [IndexPath] = []
            if let largePhotoIndexPath = largePhotoIndexPath {
                indexPaths.append(largePhotoIndexPath)
            }

            if let oldValue = oldValue {
                indexPaths.append(oldValue)
            }

            // 对集合视图进行动画更新
            collectionView.performBatchUpdates {
                self.collectionView.reloadItems(at: indexPaths)
            } completion: { _ in
                // 动画执行完成后，将所选 cell 滚动到屏幕中间
                if let largePhotoIndexPath = self.largePhotoIndexPath {
                    self.collectionView.scrollToItem(at: largePhotoIndexPath, at: .centeredVertically, animated: true)
                }
            }
        }
    }

    var searches: [FlickrSearchResults] = []
    let flickr = Flickr()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }


    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        guard !searches.isEmpty else {
            return
        }

        guard !selectedPhotos.isEmpty else {
            isSharing.toggle()
            return
        }

        guard isSharing else {
            return
        }

        let images: [UIImage] = selectedPhotos.compactMap { photo in
            guard let thumbnail = photo.thumbnail else {
                return nil
            }

            return thumbnail
        }

        guard !images.isEmpty else {
            return
        }

        let shareController = UIActivityViewController(activityItems: images, applicationActivities: nil)

        shareController.completionWithItemsHandler = { _, _, _, _ in
          self.isSharing = false
          self.selectedPhotos.removeAll()
          self.updateSharedPhotoCountLabel()
        }

        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
}
