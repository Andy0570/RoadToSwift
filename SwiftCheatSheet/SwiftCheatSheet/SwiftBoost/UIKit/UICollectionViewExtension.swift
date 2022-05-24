#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UICollectionView {
    // MARK: - Layout

    func invalidateLayout(animated: Bool) {
        if animated {
            performBatchUpdates({
                self.collectionViewLayout.invalidateLayout()
            }, completion: nil)
        } else {
            collectionViewLayout.invalidateLayout()
        }
    }
}
#endif
