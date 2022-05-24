#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UIScrollView {
    enum Side {
        case top, bottom, left, right
    }

    func scrollTo(_ side: Side, animated: Bool) {
        let point: CGPoint
        switch side {
        case .top:
            if contentSize.height < bounds.height { return }
            point = CGPoint(
                x: contentOffset.x,
                y: -(contentInset.top + safeAreaInsets.top)
            )
        case .bottom:
            if contentSize.height < bounds.height { return }
            point = CGPoint(
                x: contentOffset.x,
                y: max(0, contentSize.height - bounds.height) + contentInset.bottom + safeAreaInsets.bottom
            )
        case .left:
            point = CGPoint(x: -contentInset.left, y: contentOffset.y)
        case .right:
            point = CGPoint(x: max(0, contentSize.width - bounds.width) + contentInset.right, y: contentOffset.y)
        }
        setContentOffset(point, animated: animated)
    }
}
#endif
