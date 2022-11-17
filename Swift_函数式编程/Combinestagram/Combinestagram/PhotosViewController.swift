import Photos
import RxSwift

class PhotosViewController: UICollectionViewController {

    // MARK: public properties

    // MARK: private properties
    private lazy var photos = PhotosViewController.loadPhotos()
    private lazy var imageManager = PHCachingImageManager()

    private let selectedPhotosSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotosSubject.asObserver()
    }

    private lazy var thumbnailSize: CGSize = {
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        return CGSize(width: cellSize.width * UIScreen.main.scale,
                      height: cellSize.height * UIScreen.main.scale)
    }()

    static func loadPhotos() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }

    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // !!!: 页面消失时，提示 DisposeBag 弃置 Observable
        selectedPhotosSubject.onCompleted()
    }

    // MARK: UICollectionView

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let asset = photos.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell

        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        })

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.item)

        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.flash()
        }

        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
            guard let image = image, let info = info else { return }

            // 通过 info 字典检查图片资源是缩略图版本还是完整版本？
            if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool, !isThumbnail {
                self?.selectedPhotosSubject.onNext(image)
            }
        })
    }
}
