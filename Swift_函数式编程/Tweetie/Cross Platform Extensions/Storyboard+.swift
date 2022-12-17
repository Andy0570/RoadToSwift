import Foundation

#if os(iOS)
  import UIKit

  extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T {
      return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
  }
#elseif os(OSX)
  import Cocoa

  extension NSStoryboard.Name {
    public init(stringLiteral value: String) {
      self.init(value)
    }
  }

  extension NSStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T {
      let scene = SceneIdentifier(String(describing: type))
      return instantiateController(withIdentifier: scene) as! T
    }
  }
#endif
