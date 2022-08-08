import UIKit

extension FlickrPhotosViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let flickrPhoto = photo(for: indexPath)
        guard let thumbnail = flickrPhoto.thumbnail else {
            return []
        }

        // 创建一个引用缩略图的 NSItemProvider 对象。拖动系统使用它来指示正在拖动的项目。
        let item = NSItemProvider(object: thumbnail)
        // 创建一个 UIDragItem 代表要拖动的选定项
        let dragItem = UIDragItem(itemProvider: item)
        return [dragItem]
    }
}

extension FlickrPhotosViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // 从放置协调器获取 destinationIndexPath
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }

        coordinator.items.forEach { dropItem in
            guard let sourceIndexPath = dropItem.sourceIndexPath else {
                return
            }

            collectionView.performBatchUpdates {
                // 从源索引处的数组中删除项目并将它们插入到目标索引中
                let image = photo(for: sourceIndexPath)
                removePhoto(at: sourceIndexPath)
                insertPhoto(image, at: destinationIndexPath)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            } completion: { _ in
                // 在完成块中，执行放置操作
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            }

        }
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
