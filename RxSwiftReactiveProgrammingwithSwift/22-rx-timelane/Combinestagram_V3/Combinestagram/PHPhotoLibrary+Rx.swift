//
//  PHPhotoLibrary+Rx.swift
//  Combinestagram
//
//  Created by Qilin Hu on 2023/1/6.
//  Copyright © 2023 Underplot ltd. All rights reserved.
//

import Photos
import RxSwift

extension PHPhotoLibrary {
    static var authorized: Observable<Bool> {
        return Observable.create { observer in
            DispatchQueue.main.async {
                // 如果用户先前已经授权访问，则返回 true；否则返回 false，并再次发起授权请求
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    // requestAuthorization(_:) 方法不保证该闭包会在哪个线程执行，为避免应用崩溃
                    // 在订阅的 onNext(_:) 代码中主动切换到主线程更新 UI（见 PhotosViewController.swift 第47行）
                    requestAuthorization { newStatus in
                        observer.onNext(newStatus == .authorized)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}
