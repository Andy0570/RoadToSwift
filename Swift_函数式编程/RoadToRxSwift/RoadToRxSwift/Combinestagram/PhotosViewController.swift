//
//  PhotosViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/17.
//

import UIKit
import Photos
import RxSwift

class PhotosViewController: UICollectionViewController {
    private enum Constants {
        static let reuseIdentifier = "Cell"
    }

    // MARK: Public
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotosSubject.asObservable()
    }

    // MARK: Private
    private lazy var photos = PhotosViewController.loadPhotos()
    private lazy var imageManager = PHCachingImageManager()
    private let selectedPhotosSubject = PublishSubject<UIImage>()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(PhotoCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // !!!: 页面消失时，提示 DisposeBag 弃置 Observable
        selectedPhotosSubject.onCompleted()
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = photos.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! PhotoCell
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.item)

        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.flash()
        }

        // imageManager.requestImage(...) 获取选中的照片，并在 completion 闭包中提供 image 和 info 参数供你使用
        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil) { [weak self] image, info in
            guard let image = image, let info = info else { return }

            // 通过 info 字典检查图片资源是缩略图版本还是完整版本
            if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool, !isThumbnail {
                self?.selectedPhotosSubject.onNext(image)
            }
        }
    }

}
