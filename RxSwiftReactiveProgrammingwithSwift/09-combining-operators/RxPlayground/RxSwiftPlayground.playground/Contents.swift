import Foundation
import RxSwift
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// startWith: 在可观察序列上添加前缀初始值
example(of: "startWith") {
    let number = Observable.of(2, 3, 4)

    let observable = number.startWith(1)
    _ = observable.subscribe(onNext: {
        print($0)
    })
}
// 1 -> 2 -> 3 -> 4 -|

// Observable.concat(_:) 静态函数连接了两个可观察序列
example(of: "Observable.concat") {
    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)

    let observable = Observable.concat([first, second])
    observable.subscribe(onNext: {
        print($0)
    })
}
// 1 -> 2 -> 3 -> 4 -> 5 -> 6

example(of: "concat") {
    let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
    let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")

    let observable = germanCities.concat(spanishCities)
    _ = observable.subscribe(onNext: {
        print($0)
    })
}
// Berlin -> Munich -> Frankfurt -> Madrid -> Barcelona -> Valencia

// 区别于 flatMap(_:) 的异步性
// concatMap(_:) 保证闭包产生的每个序列在订阅下一个序列之前都运行完毕。
example(of: "concatMap") {
    let sequences = [
        "German cities": Observable.of("Berlin", "Munich", "Frankfurt"),
        "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
    ]

    let observable = Observable.of("German cities", "Spanish cities").concatMap { country in
        sequences[country] ?? .empty()
    }

    _ = observable.subscribe(onNext: {
        print($0)
    })
}
// Berlin -> Munich -> Frankfurt -> Madrid -> Barcelona -> Valencia

// merge 会订阅它收到的每一个可观察序列，并在元素到达时立即发射，不区分订阅顺序！
example(of: "merge") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()

    let source = Observable.of(left.asObserver(), right.asObserver())

    let observable = source.merge()
    _ = observable.subscribe(onNext: {
        print($0)
    })

    var leftValues = ["Berlin", "Munich", "Frankfurt"]
    var rightValues = ["Madrid", "Barcelona", "Valencia"]
    repeat {
        switch Bool.random() {
        case true where !leftValues.isEmpty:
            left.onNext("Left:  " + leftValues.removeFirst())
        case false where !rightValues.isEmpty:
            right.onNext("Right: " + rightValues.removeFirst())
        default:
    break
        }
    } while !leftValues.isEmpty || !rightValues.isEmpty

    left.onCompleted()
    right.onCompleted()
}
// Right: Madrid
// Right: Barcelona
// Left:  Berlin
// Left:  Munich
// Right: Valencia
// Left:  Frankfurt

// 你可以使用 merge(maxConcurrent:) 来限制一次订阅的序列的数量


// 注意，combineLatest 在开始调用你的闭包之前，会等待它的所有可观察序列发出一个元素。
example(of: "combineLatest") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()

    let observable = Observable.combineLatest(left, right) { lastLeft, lastRight in
        "\(lastLeft) \(lastRight)"
    }
    _ = observable.subscribe(onNext: {
        print($0)
    })
    print("> Sending a value to Left")
    left.onNext("Hello,")
    print("> Sending a value to Right")
    right.onNext("world")
    print("> Sending another value to Right")
    right.onNext("RxSwift")
    print("> Sending another value to Left")
    left.onNext("Have a good day,")

    left.onCompleted()
    right.onCompleted()
}
// Hello, world
// Hello, RxSwift
// Have a good day, RxSwift

// combineLatest 的变体，你可以组合不同类型的元素
example(of: "combine user choice and value") {
    let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
    let dates = Observable.of(Date())

    let observable = Observable.combineLatest(choice, dates) { format, date -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = format
        return formatter.string(from: date)
    }

    _ = observable.subscribe(onNext: {
        print($0)
    })
}
// 11/29/22
// November 29, 2022

// zip 是一种以锁步方式行走序列的方法
example(of: "zip") {
    enum Weather {
        case cloudy
        case sunny
    }

    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
    let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")

    let observable = Observable.zip(left, right) { weather, city in
        return "It's \(weather) in \(city)"
    }
    _ = observable.subscribe(onNext: {
        print($0)
    })
}
// It's sunny in Lisbon
// It's cloudy in Copenhagen
// It's cloudy in London
// It's sunny in Madrid


// MARK: - Triggers

// 从一个可观察序列上获取当前（最新）的值，但只在特定的触发器发生时才获取
example(of: "withLatestFrom") {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()

    let observable = button.withLatestFrom(textField)
    _ = observable.subscribe(onNext: {
        print($0)
    })

    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext(())
    button.onNext(())
}
// Paris
// Paris

// sample 的功能类似于 withLatestFrom() + distinctUntilChanged()
// 虽然按钮点击了两次，但是文本输入框的最新值没有更新，因此控制台只输出了一次
example(of: "sample") {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()

    let observable = textField.sample(button)
    _ = observable.subscribe(onNext: {
        print($0)
    })

    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext(())
    button.onNext(())
}
// Paris

// MARK: - Switches

// amb() 操作符同时订阅 left 和 right 可观察序列，它等待它们中的任何一个发出一个元素，然后取消对另一个的订阅。
// 使用场景：连接两个相互冗余的服务器，并始终使用最先响应的那个。
example(of: "amb") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()

    let observable = left.amb(right)
    _ = observable.subscribe(onNext: {
        print($0)
    })

    left.onNext("Lisbon")
    right.onNext("Copenhagen")

    left.onNext("London")
    left.onNext("Madrid")
    right.onNext("Vienna")

    left.onCompleted()
    right.onCompleted()
}
// Lisbon -> London -> Madrid

// switchLatest 始终切换到最后一次响应的可观察序列，并取消观察旧的序列
example(of: "switchLatest") {
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()

    let source = PublishSubject<Observable<String>>()
    let observable = source.switchLatest()
    let disposable = observable.subscribe(onNext: {
        print($0)
    })

    source.onNext(one)
    one.onNext("Some text from sequence one")
    two.onNext("Some text from sequence two")

    source.onNext(two)
    two.onNext("More text from sequence two")
    one.onNext("and also from sequence one")

    source.onNext(three)
    two.onNext("Why don't you see me?")
    one.onNext("I'm alone, help me")
    three.onNext("Hey it's three. I win.")
    source.onNext(one)
    one.onNext("Nope. It's me, one!")

    disposable.dispose()
}
// Some text from sequence one
// More text from sequence two
// Hey it's three. I win.
// Nope. It's me, one!

// reduce() 只有当源可观察序列 completed 时才会产生累积值。也就是说，对从未 complete 的序列应用这个操作符，将不会发出任何东西。
example(of: "reduce") {
    let source = Observable.of(1, 3, 5, 7, 9)

    let observable = source.reduce(0, accumulator: +)
    _ = observable.subscribe(onNext: {
        print($0)
    })
}
// 25

// 每次源可观察序列发出一个元素时，scan(_:accumulator:) 都会调用你的闭包。
// 你可以用它来计算运行总数、统计输入字数、状态等等。
example(of: "scan") {
    let source = Observable.of(1, 3, 5, 7, 9)

    let observable = source.scan(0, accumulator: +)
    _ = observable.subscribe(onNext: {
        print($0)
    })
}
// 1 -> 4 -> 9 -> 16 -> 25
