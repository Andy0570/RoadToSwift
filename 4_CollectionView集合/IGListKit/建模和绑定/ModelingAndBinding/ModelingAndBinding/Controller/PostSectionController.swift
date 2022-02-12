//
//  PostSectionController.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/12.
//

import IGListKit

//  这宣布你的 SectionController 接收一个 Post 模型。这样你就不需要对你的模型做任何特殊的铸造。
final class PostSectionController: ListBindingSectionController<Post>, ListBindingSectionControllerDataSource, ActionCellDelegate {

    var localLikes: Int? = nil

    override init() {
        super.init()
        dataSource = self
    }

    // MARK: - ListBindingSectionControllerDataSource

    // 通过给定的 Post 模型创建并返回 view model 数组
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let objcet = object as? Post else {
            fatalError()
        }

        let results: [ListDiffable] = [
            UserViewModel(username: objcet.username, timestampe: objcet.timestamp),
            ImageViewModel(url: objcet.imageURL),
            ActionViewModel(likes: localLikes ?? objcet.likes)
        ]
        return results + objcet.comments
    }

    // 返回每个 viewModel 的 size 尺寸
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else {
            fatalError()
        }

        let height: CGFloat
        switch viewModel {
        case is ImageViewModel: height = 250
        case is Comment: height = 35
        default: height = 55
        }

        return CGSize(width: width, height: height)
    }

    // 为每个 viewModel 返回一个 cell
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {

        let identifier: String
        switch viewModel {
        case is ImageViewModel: identifier = "image"
        case is Comment: identifier = "comment"
        case is UserViewModel: identifier = "user"
        default: identifier = "action"
        }

        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: identifier, for: self, at: index) as? UICollectionViewCell & ListBindable else {
            fatalError()
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
