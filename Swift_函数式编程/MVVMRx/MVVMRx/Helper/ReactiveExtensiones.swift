//
//  ReactiveExtensiones.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController: loadingViewable {}

/**
 Rx 团队的 RxCocoa 包含了许多 UIKit 属性，但是有些属性（例如自定义属性，在我们的例子中是 Animating）是不在 RxCocoa 中的，但你可以轻松添加它们：
 */
extension Reactive where Base: UIViewController {
    /// 用于 `startAnimating()` 和 `stopAnimating()` 方法的 binder
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { vc, active in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        }
    }
}
