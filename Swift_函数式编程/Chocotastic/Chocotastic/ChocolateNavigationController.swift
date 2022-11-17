import UIKit

/// Subclass to make status bar style work for views embedded in this navigation controller.
class ChocolateNavigationController: UINavigationController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
