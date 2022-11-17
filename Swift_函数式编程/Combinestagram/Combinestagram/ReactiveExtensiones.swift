//
//  ReactiveExtensiones.swift
//  Combinestagram
//
//  Created by Qilin Hu on 2022/11/17.
//  Copyright © 2022 Underplot ltd. All rights reserved.
//

import RxSwift

extension UIViewController {
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
