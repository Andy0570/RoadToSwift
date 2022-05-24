#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UINavigationBar {
    /**
     SwiftBoost: Set appearance for navigation bar.
     */
    @available(iOS 13.0, tvOS 13.0, *)
    func setAppearance(_ value: NavigationBarAppearance) {
        self.standardAppearance = value.standardAppearance
        self.scrollEdgeAppearance = value.scrollEdgeAppearance
    }

    /**
     SwiftBoost: Appearance cases.
     */
    @available(iOS 13.0, tvOS 13.0, *)
    enum NavigationBarAppearance {
        case transparentAlways
        case transparentStandardOnly
        case opaqueAlways

        var standardAppearance: UINavigationBarAppearance {
            switch self {
            case .transparentAlways:
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                return appearance
            case .transparentStandardOnly:
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                return appearance
            case .opaqueAlways:
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                return appearance
            }
        }

        var scrollEdgeAppearance: UINavigationBarAppearance {
            switch self {
            case .transparentAlways:
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                return appearance
            case .transparentStandardOnly:
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                return appearance
            case .opaqueAlways:
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                return appearance
            }
        }
    }
}
#endif
