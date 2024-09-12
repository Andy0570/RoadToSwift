//
//  UIView+Rx.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/28.
//

import RxSwift

/// 通过 Binder 扩展 UIView，实现页面隐藏
/// 使用示例 `usernameValid.bind(to: usernameValidOutlet.rx.isHidden).disposed(by: disposeBag)`
extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { view, hidden in
            view.isHidden = hidden
        }
    }
}
