//
//  PublishImageViewController.swift
//  SocialDemo
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

class PublishImageViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()

    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        return ListAdapter(updater: updater, viewController: self, workingRangeSize: 1)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(navigationLeftBarButtonTapped))

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: - Actions

    @objc func navigationLeftBarButtonTapped() {
        // self.dismiss(animated: true)
        navigationController?.popViewController()
    }
}

extension PublishImageViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            PublishTextViewModel(publishTextType: .title, text: nil, placeholder: "添加标题让更多人看到你的分享～", lengthLimit: 100),
            PublishTextViewModel(publishTextType: .body, text: nil, placeholder: "添加正文内容～", lengthLimit: 1000)
        ]
    }

    // 返回对应模型的 SectionController
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let object = object as? PublishTextViewModel {
            switch object.publishTextType {
                case .title: return TitleSectionController()
                case .body: return BodySectionController()
            }
        } else {
            return ListSectionController()
        }
    }

    // 如果不存在对象，则返回空白占位视图
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
