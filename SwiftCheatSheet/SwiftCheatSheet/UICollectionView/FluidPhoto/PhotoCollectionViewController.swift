//
//  PhotoCollectionViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/28.
//

import UIKit

/// Create transition and interaction like iOS Photos app
/// 像 iOS Photos 应用一样创建过渡和交互
/// <https://medium.com/@masamichiueta/create-transition-and-interaction-like-ios-photos-app-2b9f16313d3>
class PhotoCollectionViewController: UIViewController {
    // 弱引用的隐式解包可选类型变量
    weak var collectionView: UICollectionView!

    var photos: [UIImage]!
    var selectedIndexPath: IndexPath!

    var currentLeftSafeAreaInset  : CGFloat = 0.0
    var currentRightSafeAreaInset : CGFloat = 0.0

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.systemBackground
        // 如果我们添加了 scrollviews，这个小技巧可以防止导航栏折叠
        view.addSubview(UIView(frame: .zero))

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 自适应父view的宽高
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(collectionView)
        self.collectionView = collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()



        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            // 设置该属性后 cell 可以在内部覆写 preferredLayoutAttributesFitting 以自适应大小
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collectionView.register(cellWithClass: PhotoCollectionViewCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PhotoCollectionViewCell.self, for: indexPath)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController.init(title: "Tapped \(indexPath.row) row", message: nil, defaultActionButtonTitle: "OK", tintColor: UIColor.systemBlue)
        alertController.show(animated: true, vibrate: true, completion: nil)
    }
}
