#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UINavigationController {
    convenience init(rootViewController2: UIViewController, prefersLargeTitles: Bool) {
        self.init(rootViewController: rootViewController2)
        #if os(iOS)
        navigationBar.prefersLargeTitles = prefersLargeTitles
        #endif
    }
}
#endif
