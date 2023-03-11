import Foundation
import RxSwift

example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3

    // just 操作符创建一个只包含单个元素的可观察序列
    let observable = Observable<Int>.just(one)
    let observable2 = Observable.of(one, two, three)
    // 创建一个可观察的数组
    let observable3 = Observable.of([one, two, three])
    // from 操作符从一个类型元素的数组中创建一个单个元素的可观察序列
    let observable4 = Observable.from([one, two, three])
}

// 订阅可观察变量
example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3

    let observable = Observable.of(one, two, three)
    observable.subscribe(onNext: { element in
        print(element)
    })
}

// empty 操作符创建了一个零元素的空的可观察序列；它只会发出一个 completed 事件。
example(of: "empty") {
    let observable = Observable<Void>.empty()

    observable.subscribe { element in
        print(element)
    } onCompleted: {
        print("Completed")
    }
}

// never 操作符创建了一个不发射任何东西并且永远不会终止的可观察对象。它可以用来表示一个无限的持续时间。
example(of: "never") {
    let observable = Observable<Void>.never()
    let disposeBag = DisposeBag()

    observable
        .subscribe { element in
            print(element)
        } onCompleted: {
            print("Completed")
        } onDisposed: {
            print("Disposed")
        }
        .disposed(by: disposeBag)
}

// 从一系列的值中生成一个可观察变量
example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)

    observable.subscribe(onNext: { i in
        let n = Double(i)

        let fibonacci = Int(
            ((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded()
        )

        print(fibonacci)
    })
}

// 通过取消对可观察序列的订阅来手动提前终止可观察序列
example(of: "dispose") {
    let observable = Observable.of("A", "B", "C")

    let subscription = observable.subscribe { event in
        print(event)
    }

    subscription.dispose()
}

example(of: "DisposeBag") {
    let disposeBag = DisposeBag()

    Observable.of("A", "B", "C").subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
}

// create 操作符可以指定一个可观察序列将要向订阅者发出的所有事件
example(of: "create") {
    enum MyError: Error {
        case anError
    }

    let disposeBag = DisposeBag()

    Observable<String>.create { observer in
        observer.onNext("1")
        observer.onError(MyError.anError)
        observer.onCompleted()
        observer.onNext("?")

        return Disposables.create()
    }
    .subscribe {
        print($0)
    } onError: {
        print($0)
    } onCompleted: {
        print("Completed")
    } onDisposed: {
        print("Disposed")
    }
}

// 与其创建一个等待订阅者的 Observable，不如创建 Observable 工厂，向每个订阅者提供一个新的 Observable。
example(of: "deferred") {
    let disposeBag = DisposeBag()

    var flip = false

    let factory: Observable<Int> = Observable.deferred {
        flip.toggle()

        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }

    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
        .disposed(by: disposeBag)

        print()
    }
}

example(of: "Single") {
    let disposeBag = DisposeBag()

    // Error 枚举类型，模拟从磁盘上的文件读取数据时可能发生的错误类型
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }

    func loadText(from name: String) -> Single<String> {
        return Single.create { single in
            let disposable = Disposables.create()

            // 获取文件名路径，否则返回文件未找到错误
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }

            // 从指定路径中读取数据，否则返回文件不可读错误
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }

            // 将数据转换为字符串，否则返回编码错误
            guard let contens = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }

            // 数据读取成功，将数据内容作为 success 返回
            single(.success(contens))
            return disposable
        }
    }

    // 读取 Copyright.txt 文件
    loadText(from: "Copyright").subscribe {
        switch $0 {
        case .success(let string):
            print(string)
        case .error(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
}

// Challenge 1: 执行副作用
example(of: "do") {
    let observable = Observable<Any>.never()
    let disposeBag = DisposeBag()

    observable.do(onSubscribe: {
        print("Subscribed")
    }).subscribe { element in
        print(element)
    } onCompleted: {
        print("Completed")
    } onDisposed: {
        print("Disposed")
    }
    .disposed(by: disposeBag)
}

// Challenge 2: 打印调试信息
example(of: "debug") {
    let observable = Observable<Any>.never()
    let disposeBag = DisposeBag()

    observable
        .debug("observable")
        .subscribe { element in
            print(element)
        } onCompleted: {
            print("Completed")
        } onDisposed: {
            print("Disposed")
        }
        .disposed(by: disposeBag)
}
