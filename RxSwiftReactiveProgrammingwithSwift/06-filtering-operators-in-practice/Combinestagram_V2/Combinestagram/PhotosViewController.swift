import UIKit
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

    private let bag = DisposeBag()

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

        // 创建一个共享的可观察序列，监听系统相册授权状态
        let authorized = PHPhotoLibrary.authorized.share()

        // !!!: 系统相册授权成功
        authorized
            // 忽略所有 false 元素，如果用户没有授权相册访问权限，subscribe 订阅代码就不会执行
            .skip(while: { !$0 })
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.photos = PhotosViewController.loadPhotos()
                // FIXME: 在 RxSwift 中，鼓励使用 Schedulers 来切换线程
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            })
            .disposed(by: bag)

        // !!!: 系统相册授权失败
        // 在当前情况下，以下可替换的逻辑可以达到相同的目的：
        // authorized.skip(1).filter { !$0 }
        // authorized.takeLast(1).filter { !$0 }
        // authorized.distinctUntilChanged().takeLast(1).filter { !$0 }
        // 保留 skip、takeLast 和 filter 可能是确保应用程序逻辑在下一个iOS版本发布后不会被破坏的最好方法。
        authorized
            .skip(1)
            .takeLast(1)
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                guard let errorMessage = self?.errorMessage else { return }
                DispatchQueue.main.async(execute: errorMessage)
            })
            .disposed(by: bag)
    }

    // 当用户被拒绝访问他们的照片库，他们会看到禁止访问的提示框，用户必须点击关闭返回到上一个页面
    // 你必须通过 asObservable() 将你的 Completable 转换为可观察对象，因为 take(_:scheduler:) 操作符在 Completable 类型上不可用。
    // take(_:scheduler:) 在给定的时间段内从源序列中获取元素。一旦时间间隔过了，序列 completed 终止。
    private func errorMessage() {
        alert(title: "No access to Camera Roll", message: "You can grant access to Combinestagram from the Settings app")
            .asObservable()
            .take(for: .seconds(5), scheduler: MainScheduler.instance) // 5 秒后弹窗自动关闭
            .subscribe(onCompleted: { [weak self] in
                self?.dismiss(animated: true)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
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

            // 通过 info 字典检查图片资源是缩略图版本还是完整版本
            if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool, !isThumbnail {
                self?.selectedPhotosSubject.onNext(image)
            }
        })
    }
}
