import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

// toArray 把一个可观察元素的序列转换成包含这些元素的数组，它返回一个 Single 实例
example(of: "toArray") {
    let disposeBag = DisposeBag()

    Observable.of("A", "B", "C")
        .toArray()
        .subscribe(onSuccess: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "map") {
    let disposeBag = DisposeBag()

    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut

    Observable<Int>.of(123, 4, 56).map {
        formatter.string(for: $0) ?? ""
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}

example(of: "enumerated and map") {
    let disposeBag = DisposeBag()

    Observable.of(1, 2, 3, 4, 5, 6).enumerated().map { index, integer in
        index > 2 ? integer * 2 : integer
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}

// compactMay 操作符是 map 和 filter 操作符的组合，专门过滤掉 nil 值。
example(of: "compactMap") {
    let disposeBag = DisposeBag()

    Observable.of("To", "be", nil, "or", "not", "to", "be", nil)
        .compactMap { $0 }
        .toArray()
        .map { $0.joined(separator: " ") }
        .subscribe(onSuccess: { print($0) })
        .disposed(by: disposeBag)


}
// To be or not to be

struct Student {
    let score: BehaviorSubject<Int>
}

example(of: "flatMap") {
    let disposeBag = DisposeBag()

    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))

    let student = PublishSubject<Student>()

    student
        .flatMap { $0.score }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    student.onNext(laura)
    laura.score.onNext(85)
    student.onNext(charlotte)
    laura.score.onNext(95)
    charlotte.score.onNext(100)
}
// flatMap 会持续跟踪每一个被订阅的可观察序列的变化
// 80 -> 85 -> 90 -> 95 -> 100

// flatMapLatest 操作符实际上是两个操作符的组合：map 和 switchLatest。
// flatMapLatest 的不同之处在于，它会自动切换到最新的可观察序列，并取消对之前旧的 observable 的订阅。类似 switchLatest() 操作符。
// flatMapLatest 适用于网络操作。当一个新的网络请求开始时，它将取消以前订阅的任何网络请求。
example(of: "flatMapLatest") {
    let disposeBag = DisposeBag()

    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))

    let student = PublishSubject<Student>()

    student.flatMapLatest { $0.score }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    student.onNext(laura)
    laura.score.onNext(85)
    student.onNext(charlotte) // 切换订阅最新的 charlotte，同时取消订阅 laura
    laura.score.onNext(95)
    charlotte.score.onNext(100)
}
// 80 -> 85 -> 90 -> 100

// 实物化和非实物化
example(of: "materialize and dematerialize") {
    enum MyError: Error {
        case anError
    }

    let disposeBag = DisposeBag()

    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 100))

    let student = BehaviorSubject(value: laura)

    // let studentScore: Observable<Int> ➡️ let studentScore: Observable<Event<Int>>
    let studentScore = student.flatMapLatest { $0.score.materialize() }

    studentScore
    // 过滤掉 error 事件
        .filter {
            guard $0.error == nil else {
                print($0.error!)
                return false
            }
            return true
        }
        .dematerialize() // 将一个 materialized 的可观察序列转换回它的原始形式
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    laura.score.onNext(85)
    laura.score.onError(MyError.anError) // 当错误没有被处理时，studentScore 可观察变量就会终止
    laura.score.onNext(90)

    student.onNext(charlotte)
}
// 80 -> 85 -> anError -> 100


