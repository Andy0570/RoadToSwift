//
//  MyCollectionViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/22.
//

/**
 参考：使用 UICollectionView.CellRegistration 配置集合视图
 <https://www.donnywals.com/configure-collection-view-cells-with-uicollectionview-cellregistration/>
 */

import UIKit
import SwifterSwift

class MyCollectionViewController: UIViewController {
    // 弱引用的隐式解包可选类型变量
    weak var collection: UICollectionView!

    // 在视图控制器中定义一个实例属性
    // 使用 UICollectionView.CellRegistration 配置集合视图
    let simpleConfig = UICollectionView.CellRegistration<MyCollectionViewCell, String> { cell, indexPath, model in
        cell.label.text = model
    }

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.systemBackground
        // 如果我们添加了 scrollviews，这个小技巧可以防止导航栏折叠
        view.addSubview(UIView(frame: .zero))

        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        self.collection = collection
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.backgroundColor = .systemBackground
        collection.alwaysBounceVertical = true
        collection.dragInteractionEnabled = true
        collection.dataSource = self
        collection.delegate = self

        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.itemSize = CGSize(width: 100, height: 100)
        }
    }
}

extension MyCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = "Cell \(indexPath.row)"
        return collectionView.dequeueConfiguredReusableCell(using: simpleConfig, for: indexPath, item: model)
    }
}

extension MyCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController.init(title: "Tapped \(indexPath.row) row", message: nil, defaultActionButtonTitle: "OK", tintColor: UIColor.systemBlue)
        alertController.show(animated: true, vibrate: true, completion: nil)
    }
}
