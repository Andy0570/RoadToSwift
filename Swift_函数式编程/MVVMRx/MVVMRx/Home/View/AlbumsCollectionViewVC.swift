//
//  AlbumsCollectionViewVC.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumsCollectionViewVC: UIViewController {

    @IBOutlet private weak var albumsCollectionView: UICollectionView!

    public var albums = PublishSubject<[Album]>()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        albumsCollectionView.backgroundColor = .clear
    }

    private func setupBinding() {
        // 为 UICollectionView 注册重用 'AlbumsCollectionViewCell'
        albumsCollectionView.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: AlbumsCollectionViewCell.self))

        albums.bind(to: albumsCollectionView.rx.items(cellIdentifier: "AlbumsCollectionViewCell", cellType: AlbumsCollectionViewCell.self)) {  (row,album,cell) in
            cell.album = album
            cell.withBackView = true
            }.disposed(by: disposeBag)

        albumsCollectionView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
    }
}
