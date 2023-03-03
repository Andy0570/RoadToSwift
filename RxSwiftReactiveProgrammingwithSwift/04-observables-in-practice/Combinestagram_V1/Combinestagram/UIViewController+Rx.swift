//
//  UIViewController+Rx.swift
//  Combinestagram
//
//  Created by Qilin Hu on 2023/1/6.
//  Copyright © 2023 Underplot ltd. All rights reserved.
//

import RxSwift

extension UIViewController {
    /// 显示警报弹窗
    /// 用法：alert(title: "标题", message: "内容").subscribe().disposed(by: bag)
    func alert(title: String, message: String?) -> Completable {
        return Completable.create { [weak self] completable in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                completable(.completed)
            }))
            self?.present(alert, animated: true)
            return Disposables.create {
                self?.dismiss(animated: true)
            }
        }
    }
}
