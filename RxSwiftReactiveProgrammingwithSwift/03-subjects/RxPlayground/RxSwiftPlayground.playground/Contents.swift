import Foundation
import RxRelay
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()

    subject.onNext("Is anyone listening?")

    let subscriptionOne = subject.subscribe(onNext: { string in
        print(string)
    })

    subject.onNext("1")
    subject.onNext("2")

    let subscriptionTwo = subject.subscribe { event in
        print("2)", event.element ?? event)
    }

    subject.onNext("3")

    subscriptionOne.dispose()

    subject.onNext("4")

    subject.onCompleted()

    subject.onNext("5")

    subscriptionTwo.dispose()

    let disposeBag = DisposeBag()
    subject.subscribe { event in
        print("3)", event.element ?? event)
    }.disposed(by: disposeBag)

    subject.onNext("?")
}

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}

example(of: "BehaviorSubject") {
    let subject = BehaviorSubject(value: "初始值")
    let disposeBag = DisposeBag()

    subject.onNext("X")

    subject.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)

    subject.onError(MyError.anError)

    subject.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
}

example(of: "ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()

    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")

    subject.subscribe {
        print(label: "A)", event: $0)
    }.disposed(by: disposeBag)

    subject.subscribe {
        print(label: "B)", event: $0)
    }.disposed(by: disposeBag)

    subject.onNext("4")
    subject.onError(MyError.anError)
    subject.dispose()

    subject.subscribe {
        print(label: "C)", event: $0)
    }.disposed(by: disposeBag)
}

example(of: "PublishRelay") {
    let relay = PublishRelay<String>()
    let disposeBag = DisposeBag()

    relay.accept("knock knock, anyone home?")

    relay.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)

    relay.accept("1")
}

example(of: "BehaviorRelay") {
    let relay = BehaviorRelay(value: "初始值")
    let disposeBag = DisposeBag()

    relay.accept("新初始值")

    relay.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)

    relay.accept("1")

    relay.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)

    relay.accept("2")

    // 使用 BehaviorRelay 时，你可以直接访问当前值
    print(relay.value)
}

// MARK: Challenge 2 使用 BehaviorRelay 观察和检查用户会话状态

example(of: "BehaviorRelay") {
    enum UserSession: String {
        case loggedIn, loggedOut
    }

    enum LoginError: Error {
        case invalidCredentials
    }

    let disposeBag = DisposeBag()

    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    let userSession = BehaviorRelay<UserSession>(value: UserSession.loggedOut)

    // Subscribe to receive next events from userSession
    userSession.subscribe(onNext: {
        print("userSession changed:", $0)
    }).disposed(by: disposeBag)

    // 登录
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
        guard username == "johnny@appleseed.com",
              password == "appleseed" else {
            completion(LoginError.invalidCredentials)
            return
        }

        // Update userSession
        userSession.accept(UserSession.loggedIn)
    }

    // 退出登录
    func logOut() {
        // Update userSession
        userSession.accept(UserSession.loggedOut)
    }

    // 需要用户处于登录状态才可以执行的操作
    func performActionRequiringLoggedInUser(_ action: () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
        guard userSession.value == .loggedIn else {
            print("You can't do that!")
            return
        }

        action()
    }

    // for-in 循环模拟尝试使用无效然后有效的登录凭据登录并执行操作
    for i in 1...2 {
        let password = i % 2 == 0 ? "appleseed" : "password"

        logInWith(username: "johnny@appleseed.com", password: password) { error in
            guard error == nil else {
                print(error!)
                return
            }

            print("User logged in.")
        }

        performActionRequiringLoggedInUser {
            print("Successfully did something only a logged in user can do.")
        }
    }
}
