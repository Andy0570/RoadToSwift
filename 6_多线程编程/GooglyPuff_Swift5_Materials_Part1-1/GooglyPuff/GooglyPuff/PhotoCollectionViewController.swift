/**

 ## Reference
 - [Grand Central Dispatch Tutorial for Swift 5: Part 1/2](https://www.raywenderlich.com/28540615-grand-central-dispatch-tutorial-for-swift-5-part-1-2)
 - [Swift 4 Grand Central Dispatch (GCD) 教程：第 1/2 部分](https://cynine.github.io/cynineblog/2019/01/17/swift4-gcd-tutoral-part-1/)
 - [TUTORIAL Grand Central Dispatch (GCD) and Dispatch Queues in Swift 3](https://www.appcoda.com/grand-central-dispatch/)
 - [Swift 中的并发编程 (第一部分：现状）](https://swift.gg/2017/09/04/all-about-concurrency-in-swift-1-the-present/)
 - [All about Concurrency in Swift - Part 2: The Future](https://www.uraimo.com/2017/07/22/all-about-concurrency-in-swift-2-the-future/)

 */

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let backgroundImageOpacity: CGFloat = 0.1

final class PhotoCollectionViewController: UICollectionViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImageView = UIImageView(image: UIImage(named: "background"))
        backgroundImageView.alpha = backgroundImageOpacity
        backgroundImageView.contentMode = .center
        collectionView?.backgroundView = backgroundImageView

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentChangedNotification(_:)),
            name: PhotoManagerNotification.contentUpdated,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentChangedNotification(_:)),
            name: PhotoManagerNotification.contentAdded,
            object: nil
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOrHideNavPrompt()
    }

    // MARK: - IBAction Methods
    @IBAction private func addPhotoAssets(_ sender: Any) {
        let alert = UIAlertController(title: "Get Photos From:", message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsStoryboard")
            if let navigationController = viewController as? UINavigationController,
               let albumsTableViewController = navigationController.topViewController as? AlbumsTableViewController {
                albumsTableViewController.assetPickerDelegate = self
                self.present(navigationController, animated: true, completion: nil)
            }
        }
        alert.addAction(libraryAction)

        let internetAction = UIAlertAction(title: "Le Internet", style: .default) { _ in
            self.downloadImageAssets()
        }
        alert.addAction(internetAction)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Private Methods
private extension PhotoCollectionViewController {
    func showOrHideNavPrompt() {

        // 💡延后2秒执行
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
            guard let self = self else {
                return
            }

            if !PhotoManager.shared.photos.isEmpty {
                self.navigationItem.prompt = nil
            } else {
                self.navigationItem.prompt = "Add photos with faces to Googlyify them!"
            }

            // 强制导航栏布局更新
            self.navigationController?.viewIfLoaded?.setNeedsLayout()
        }
    }

    func downloadImageAssets() {
        PhotoManager.shared.downloadPhotos { [weak self] error in
            let message = error?.localizedDescription ?? "The images have finished downloading"
            let alert = UIAlertController(title: "Download Complete", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Notification handlers
extension PhotoCollectionViewController {
    @objc func contentChangedNotification(_ notification: Notification) {
        collectionView?.reloadData()
        showOrHideNavPrompt()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.shared.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let photoCell = cell as? PhotoCollectionViewCell ?? PhotoCollectionViewCell()

        let photoAssets = PhotoManager.shared.photos
        let photo = photoAssets[indexPath.row]

        switch photo.statusThumbnail {
        case .goodToGo:
            photoCell.thumbnailImage = photo.thumbnail
        case .downloading:
            photoCell.thumbnailImage = UIImage(named: "photoDownloading")
        case .failed:
            photoCell.thumbnailImage = UIImage(named: "photoDownloadError")
        }

        return photoCell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photos = PhotoManager.shared.photos
        let photo = photos[indexPath.row]

        switch photo.statusImage {
        case .goodToGo:
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailStoryboard")
            if let photoDetailViewController = viewController as? PhotoDetailViewController {
                photoDetailViewController.image = photo.image
                navigationController?.pushViewController(photoDetailViewController, animated: true)
            }

        case .downloading:
            let alert = UIAlertController(
                title: "Downloading",
                message: "The image is currently downloading",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)

        case .failed:
            let alert = UIAlertController(
                title: "Image Failed",
                message: "The image failed to be created",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - AssetPickerDelegate
extension PhotoCollectionViewController: AssetPickerDelegate {
    func assetPickerDidCancel() {
        dismiss(animated: true, completion: nil)
    }

    func assetPickerDidFinishPickingAssets(_ selectedAssets: [PHAsset]) {
        for asset in selectedAssets {
            let photo = AssetPhoto(asset: asset)
            PhotoManager.shared.addPhoto(photo)
        }

        dismiss(animated: true, completion: nil)
    }
}
