//
//  ZoomableCollectionView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/18.
//

import UIKit

class ZoomableCollectionView: UICollectionView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.width * 4 / 3)
        // スクロールの向き
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        self.init(frame: frame, collectionViewLayout: layout)

        setup()
    }

    func setup() {
        // デリゲートをつける
        self.delegate = self
        self.dataSource = self

        // カスタムセルを指定
        self.register(ZoomableCell.self, forCellWithReuseIdentifier: "singleCell")

        // スクロールバーを表示するかどうか
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        self.backgroundColor = UIColor.gray

        // ページングをするかどうか
        self.isPagingEnabled = true
    }
}

extension ZoomableCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(" タップ ")
    }
}

extension ZoomableCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルの設定
        let cell: ZoomableCell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleCell", for: indexPath) as! ZoomableCell

        let image = UIImage(named: "kanagawa")
        cell.imageView.image = image

        return cell
    }
}
