//
//  TraitsViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/17.
//

import UIKit
import RxSwift

/**
 ## RxSwift 特征序列：Single、Maybe、Completable

 Single 只会发出 .success(value) 或者 .error 事件。success(value) 实际上是 next 和 completed 事件的组合。
 这对一次性进程非常有用，这些进程要么成功并产生值，要么失败，比如下载数据或从磁盘加载数据。

 Completable 只发出 .completed 或 .error 事件。它不会产生任何值。
 当你只关心操作成功完成或失败（如文件写入）时，可以使用 completable。

 Maybe 是 Single 和 Completable 的混合体。它可以发出 .success(value)、.completed 或 .error。
 如果你需要实现一个可能成功也可能失败的操作，并在成功时返回值，那么 Maybe 就是最佳选择。
 */
class TraitsViewController: UIViewController {
    private let disposeBag = DisposeBag()

    // Error 枚举类型，模拟从磁盘上的文件读取数据时可能发生的错误类型
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }

    func loadText(from name: String) -> Single<String> {
        return Single.create { single in
            let disposable = Disposables.create()

            // 获取文件名路径，否则返回文件未找到错误
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.failure(FileReadError.fileNotFound))
                return disposable
            }

            // 从指定路径中读取数据，否则返回文件不可读错误
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.failure(FileReadError.unreadable))
                return disposable
            }

            // 将数据转换为字符串，否则返回编码错误
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.failure(FileReadError.encodingFailed))
                return disposable
            }

            // 数据读取成功，将数据内容作为 success 返回
            single(.success(contents))
            return disposable
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // 读取 Copyright.txt 文件
        loadText(from: "Copyright").subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
    


}
