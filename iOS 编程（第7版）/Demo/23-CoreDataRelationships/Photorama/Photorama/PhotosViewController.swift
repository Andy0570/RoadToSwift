//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Qilin Hu on 2021/12/9.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        // 初始化时，先加载本地数据
        updateDataSource()
        
        // 发起网络请求，获取图片列表 -> 方法内部保存数据到 Core Data -> 从 Core Data 读取返回
        store.fetchInterestingPhotos {
            (photosResult) in
            
            self.updateDataSource()
        }
    }
    
    // 从本地磁盘中读取 photo 数据
    func updateDataSource() {
        store.fetchAllPhotos { (photoResult) in
            
            switch photoResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    // MARK: - Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: - Collection View Delegate
    
    // 只有当前 cell 将要显示时，下载图片
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImage(for: photo) { (result) -> Void in
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo),
                    case let .success(image) = result else {
                        return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(displaying: image)
            }
        }
    }
}

