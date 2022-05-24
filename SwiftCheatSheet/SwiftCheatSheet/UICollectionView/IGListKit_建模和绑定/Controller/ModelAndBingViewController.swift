//
//  ModelAndBingViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit

/// IGListKit 建模和绑定，基于 MVVM 设计模式构建页面。
/// Reference: <https://github.com/Instagram/IGListKit/blob/main/Guides/Modeling%20and%20Binding.md>
class ModelAndBingViewController: UIViewController {
    var data: [ListDiffable] = []

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // 注册重用 Cell
        collectionView.register(UserCell.nib, forCellWithReuseIdentifier: UserCell.identifier)
        collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(ActionCell.nib, forCellWithReuseIdentifier: ActionCell.identifier)
        collectionView.register(CommentCell.nib, forCellWithReuseIdentifier: CommentCell.identifier)
        return collectionView
    }()

    private lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: "https://placekitten.com/g/375/250") else {
            return
        }

        data.append(Post(
            username: "@janedoe",
            timestamp: "15min",
            imageURL: url,
            likes: 384,
            comments: [
                Comment(username: "@ryan", text: "this is beautiful!"),
                Comment(username: "@jsq", text: "😱"),
                Comment(username: "@caitlin", text: "#blessed")
            ]
        ))

        view.addSubview(collectionView)
        collectionView.frame = view.bounds

        adapter.dataSource = self
        adapter.collectionView = self.collectionView
    }
}

extension ModelAndBingViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PostSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
