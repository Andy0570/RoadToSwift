//
//  PostSectionController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit

//  这宣布你的 SectionController 接收一个 Post 模型。这样你就不需要对你的模型做任何特殊的铸造。
final class PostSectionController: ListBindingSectionController<Post>, ListBindingSectionControllerDataSource, ActionCellDelegate {
    var localLikes: Int?

    override init() {
        super.init()
        dataSource = self
    }

    // MARK: - ListBindingSectionControllerDataSource

    // 通过给定的 Post 模型创建并返回 ViewModel 数组
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let objcet = object as? Post else {
            fatalError("需要传递 Post 类型")
        }

        let results: [ListDiffable] = [
            UserViewModel(username: objcet.username, timestamp: objcet.timestamp),
            ImageViewModel(url: objcet.imageURL),
            ActionViewModel(likes: localLikes ?? objcet.likes)
        ]
        return results + objcet.comments
    }

    // 返回每个 ViewModel 的 size 尺寸
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else {
            fatalError("error")
        }

        let height: CGFloat
        switch viewModel {
        case is ImageViewModel: height = 250
        case is Comment: height = 35
        default: height = 55
        }

        return CGSize(width: width, height: height)
    }

    // 为每个 ViewModel 返回一个 Cell 视图实例
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        let identifier: String
        switch viewModel {
        case is ImageViewModel: identifier = ImageCell.identifier
        case is Comment: identifier = CommentCell.identifier
        case is UserViewModel: identifier = UserCell.identifier
        default: identifier = ActionCell.identifier
        }

        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: identifier, for: self, at: index) as? UICollectionViewCell & ListBindable else {
            fatalError("cell 类型不不配")
        }

        if let cell = cell as? ActionCell {
            cell.delegate = self
        }

        return cell
    }

    // MARK: - ActionCellDelegate

    func didTapHeart(cell: ActionCell) {
        localLikes = (localLikes ?? object?.likes ?? 0) + 1
        update(animated: true)
    }
}
