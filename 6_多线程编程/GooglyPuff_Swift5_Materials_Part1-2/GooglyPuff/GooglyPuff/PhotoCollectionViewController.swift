/**

 ## Reference
 - [Grand Central Dispatch Tutorial for Swift 5: Part 2/2](https://www.raywenderlich.com/28221123-grand-central-dispatch-tutorial-for-swift-5-part-2-2)
 - [Swift 4 Grand Central Dispatch (GCD) 教程：第 2/2 部分](https://cynine.github.io/cynineblog/2019/01/17/swift4-gcd-tutoral-part-2/)

 */

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let backgroundImageOpacity: CGFloat = 0.1

// 使用 Dispatch Sources 监控应用程序何时进入调试模式
#if DEBUG

// 声明 DispatchSourceSignal 类型的 signal 变量以用于监视 Unix 信号
var signal: DispatchSourceSignal?

// 创建一个分配给 setupSignalHandlerFor 全局属性的块。您将它用于一次性设置调度源。
private let setupSignalHandlerFor = { (_ object: AnyObject) in
    let queue = DispatchQueue.main
    // 设置信号，监视 SIGSTOP Unix 信号
    signal = DispatchSource.makeSignalSource(signal: SIGSTOP, queue: queue)
    // 注册一个在收到 SIGSTOP 信号时调用的事件处理程序闭包
    signal?.setEventHandler(handler: {
        print("Hi, I am: \(object.description ?? "")")
    })
    // 默认情况下，所有源都以挂起状态开始。在这里，您告诉调度源恢复，以便它可以开始监视事件。
    signal?.resume()
}

#endif

final class PhotoCollectionViewController: UICollectionViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
            setupSignalHandlerFor(self)
        #endif

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
