import UIKit
import RxSwift
import RxCocoa

class RxNavigationControllerDelegateProxy: DelegateProxy<UINavigationController, UINavigationControllerDelegate>, DelegateProxyType, UINavigationControllerDelegate {

  init(navigationController: UINavigationController) {
    super.init(parentObject: navigationController, delegateProxy: RxNavigationControllerDelegateProxy.self)
  }

  static func registerKnownImplementations() {
    self.register { RxNavigationControllerDelegateProxy(navigationController: $0) }
  }

  static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
    guard let navigationController = object as? UINavigationController else {
      fatalError()
    }
    return navigationController.delegate
  }

  static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
    guard let navigationController = object as? UINavigationController else {
      fatalError()
    }
    if delegate == nil {
      navigationController.delegate = nil
    } else {
      guard let delegate = delegate as? UINavigationControllerDelegate else {
        fatalError()
      }
      navigationController.delegate = delegate
    }
  }
}

