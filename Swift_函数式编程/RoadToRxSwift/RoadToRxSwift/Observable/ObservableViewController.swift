//
//  ObservableViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/15.
//

import UIKit
import RxSwift
import RxCocoa

enum myError: Error {
    case errorA
    case errorB
}

// 创建、订阅可观察序列
class ObservableViewController: UIViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // just 创建一个“只包含一个元素”的可观察序列；它会发出一个元素和一个 .completed 事件。
        example(of: "just") {
            let one = 1
            let two = 2
            let three = 3

            // --1--|
            let observable = Observable<Int>.just(one)
            observable.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)

            // --[1,2,3]--|
            let observable2 = Observable<[Int]>.just([one, two, three])
            observable2.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
        }

        example(of: "of") {
            let one = 1
            let two = 2
            let three = 3

            // --1--2--3--|
            let observable1 = Observable.of(one, two, three)
            observable1.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)

            // 创建一个可观察数组
            // --[1,2,3]--|
            let observable2 = Observable.of([one, two, three])
            observable2.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
        }

        // from 从一个数组中创建一个单个元素的可观察序列。
        example(of: "from") {
            let one = 1
            let two = 2
            let three = 3

            // --1--2--3--|
            let observable = Observable.from([one, two, three])
            observable.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
        }

        // empty 创建了一个零个元素的空可观察序列；它只会发出一个 .completed 事件。
        example(of: "empty") {
            // --|
            let observable = Observable<Void>.empty()
            observable.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
        }

        // never 创建了一个不发射任何事件并且永远不会终止的可观察序列。它可以用来表示一个无限的持续时间。
        example(of: "never") {
            // ------
            let observable = Observable<Void>.never()
            observable.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
        }

        // Observable.error(_): 不输出任何元素，仅输出一个 .error 事件。
        example(of: "error") {
            let observable = Observable<Int>.error(myError.errorA)
            observable.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
        }

        // range 从一系列的值中生成一个可观察变量。
        example(of: "range") {
            // --1--2--3--...--9--10--|
            let observable = Observable<Int>.range(start: 1, count: 10)
            // 连续打印10个斐波那契序列值
            observable.subscribe(onNext: { i in
                let n = Double(i)
                let fibonacci = Int(
                    ((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded()
                )
                print(fibonacci)
            }).disposed(by: disposeBag)
        }

        /**
         在有订阅者之前，Observable 不会发送事件或执行任何工作！
         正是“订阅”触发了 Observable 开始工作，使其发出 next 事件，直到 error 或 completed 事件终止可观察序列！
         不过，你也可以通过**取消对可观察序列的订阅**来手动提前终止可观察序列
         */
        example(of: "dispose") {
            let observable = Observable.of("A", "B", "C")
            let subscription = observable.subscribe { event in
                print(event)
            }
            subscription.dispose()
        }

        // create 可以指定一个可观察序列将要向订阅者发出的所有事件
        example(of: "create") {
            enum MyError: Error {
                case anError
            }

            // --1--X
            Observable<String>.create { observer in
                observer.onNext("1")
                observer.onError(MyError.anError)
                observer.onCompleted()
                observer.onNext("?")

                return Disposables.create()
            }
            .subscribe(
                onNext: { print($0) },
                onError: { print($0) },
                onCompleted: { print("Completed") },
                onDisposed: { print("Disposed") }
            )
            .disposed(by: disposeBag)
        }

        /**
         与其创建一个等待订阅者的 Observable，不如**创建 Observable 工厂**，向每个订阅者提供一个新的 Observable 实例
         */
        example(of: "deferred") {
            var flip = false

            let factory: Observable<Int> = Observable.deferred {
                flip.toggle()

                if flip {
                    return Observable.of(1, 2, 3)
                } else {
                    return Observable.of(4, 5, 6)
                }
            }

            // for 循环的每一次迭代都创建了一个新的可观察序列实例
            for _ in 0...3 {
                factory.subscribe(onNext: {
                    print($0, terminator: "")
                }).disposed(by: disposeBag)

                print()
            }
        }

        // do 执行副作用
        example(of: "do") {
            let observable = Observable<Any>.never()

            observable.do(onSubscribe: {
                print("Subscribed")
            }).subscribe(onNext: { element in
                print(element)
            }, onCompleted: {
                print("Completed")
            }, onDisposed: {
                print("Disposed")
            }).disposed(by: disposeBag)
        }

        // debug 打印调试信息
        example(of: "debug") {
            let observable = Observable<Any>.never()

            observable
                .debug("🐛") // 添加标识符字符串
                .subscribe(onNext: { element in
                    print(element)
                }, onCompleted: {
                    print("Completed")
                }, onDisposed: {
                    print("Disposed")
                })
                .disposed(by: disposeBag)
        }

        // RxSwift.Resources.total
        // 查看当前 RxSwift 申请的所有资源数量，检查内存泄露的时候非常有用。
        example(of: "RxSwift.Resources.total") {
            print(RxSwift.Resources.total)

            Observable.of("B", "C")
                .startWith("A")
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)

            print(RxSwift.Resources.total)
        }

        // 比较 map 与 compactMap 之间的区别
        // <https://www.avanderlee.com/swift/compactmap-flatmap-differences-explained/>
        example(of: "map & compactMap") {
            let scores = ["1", "2", "three", "four", "5"]

            let mapped: [Int?] = scores.map { str in Int(str) }
            print(mapped) // [Optional(1), Optional(2), nil, nil, Optional(5)]

            // 将包含“可选类型”的数组转换为包含“非可选类型”的数组，且过滤 nil 值
            let compactMapped: [Int] = scores.compactMap { str in Int(str) }
            print(compactMapped) // [1, 2, 5]
        }

        // 比较 map 与 flatMap 之间的区别
        example(of: "map & flatMap") {
            let scoresByName: [String : [Int]] = ["Andy": [0, 5, 8], "Bob": [2, 5, 8]]

            let mapped = scoresByName.map { $0.value }
            print(mapped)
            // [[0, 5, 8], [2, 5, 8]] - 数组中的元素本身也是数组

            let flatMapped = scoresByName.flatMap { $0.value }
            print(flatMapped)
            // [0, 5, 8, 2, 5, 8] - 将元素“扁平化”
        }
    }
}
