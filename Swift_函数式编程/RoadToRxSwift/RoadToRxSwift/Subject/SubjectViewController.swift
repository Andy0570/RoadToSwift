//
//  SubjectViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/17.
//

import UIKit
import RxSwift
import RxRelay

/**
 ## Subject

 Observable 是 RxSwift 的基础部分，但它本质上是**只读**的。你只能通过订阅它来获得它产生新事件的通知。
 在开发应用程序时，一个常见的需求是在运行时将新的值手动添加到一个可观察序列上，以发射给订阅者。
 你所需要的是一个既能作为可观察序列又能作为观察者的东西。这种东西被称为 Subject。

 * Subject 既是 Observable，又是 Observer。
 * Subject 一旦终止，就会向未来的订阅者再次发出停止事件（Completed 事件或者 Error 事件）。

 ## Relay

 与其他 Subject（以及一般可观察对象）不同，你可以使用 accept(_:) 方法将值添加到 Relay 上。
 换句话说，你不能使用 onNext(_:)。这是因为 Relay 只能接受值，也就是说，你不能向它们添加 error 或 completed 事件。

 */
class SubjectViewController: UIViewController {
    enum MyError: Error {
        case anError
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // PublishSubject: 开始为空，仅向订阅者发送新元素。
        example(of: "PublishSubject") {
            let subject = PublishSubject<String>()

            subject.onNext("Is anyone listening?")

            let subscriptionOne = subject.subscribe(onNext: { string in
                print(string)
            })

            subject.onNext("1")
            subject.onNext("2")

            let subscriptionTwo = subject.subscribe { event in
                print("2⃣️", event.element ?? event)
            }

            subject.onNext("3")

            subscriptionOne.dispose()

            subject.onNext("4")

            subject.onCompleted()

            subject.onNext("5")

            subscriptionTwo.dispose()

            let disposeBag = DisposeBag()
            subject.subscribe { event in
                print("3⃣️", event.element ?? event)
            }.disposed(by: disposeBag)
            
            subject.onNext("?")
        }

        // BehaviorSubject：以初始值开始，向新的订阅者重播初始值或最新元素。
        example(of: "BehaviorSubject") {
            let subject = BehaviorSubject(value: "初始值")
            let disposeBag = DisposeBag()

            subject.onNext("X")

            subject.subscribe { event in
                print("1⃣️", event.element ?? event)
            }.disposed(by: disposeBag)

            subject.onError(MyError.anError)

            subject.subscribe { event in
                print("2⃣️", event.element ?? event)
            }.disposed(by: disposeBag)
        }

        // ReplaySubject: 以缓冲区大小初始化，并将保持缓冲区中的元素达到该大小，然后重放给新的订阅者。
        example(of: "ReplaySubject") {
            let subject = ReplaySubject<String>.create(bufferSize: 2)
            let disposeBag = DisposeBag()

            subject.onNext("1")
            subject.onNext("2")
            subject.onNext("3")

            // --2--3--4--X
            subject.subscribe { event in
                print("1⃣️", event.element ?? event)
            }.disposed(by: disposeBag)

            // --2--3--4--X
            subject.subscribe { event in
                print("2⃣️", event.element ?? event)
            }.disposed(by: disposeBag)

            subject.onNext("4")
            subject.onError(MyError.anError)
            subject.dispose()

            // Object `RxSwift.(unknown context at $10bc06a80).ReplayMany<Swift.String>` was already disposed.
            // 注：ReplayMany 是用于创建 ReplaySubject 的内部类型
            subject.subscribe { event in
                print("3⃣️", event.element ?? event)
            }.disposed(by: disposeBag)
        }

        // AsyncSubject: 仅当主体接收到一个已完成的事件时，才会发出序列中最后一个下一个事件。

        // PublishRelay 包装了 PublishSubject。
        example(of: "PublishRelay") {
            let relay = PublishRelay<String>()
            let disposeBag = DisposeBag()

            relay.accept("Knock knock, anyone home?")

            // --1--->
            relay.subscribe { event in
                print("1⃣️", event.element ?? event)
            }.disposed(by: disposeBag)

            relay.accept("1")
        }

        // BehaviorRelay 包装了 BehaviorSubject。
        example(of: "BehaviorRelay") {
            let relay = BehaviorRelay(value: "初始值")
            let disposeBag = DisposeBag()

            relay.accept("新的初始值")

            // --新的初始值--1--2--->
            relay.subscribe { event in
                print("1⃣️", event.element ?? event)
            }.disposed(by: disposeBag)

            relay.accept("1")

            // --1--2--->
            relay.subscribe { event in
                print("2⃣️", event.element ?? event)
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

            // Crreate userSession BehaviorRelay of type UserSession with initial value of .loggedOut
            let userSession = BehaviorRelay<UserSession>(value: UserSession.loggedOut)
            
            // Subscribe to reactive next events from userSession
            userSession.subscribe(onNext: {
                print("user Session changed:", $0)
            }).disposed(by: disposeBag)

            // 登录
            func logInWith(username: String, password: String, completion: (Error?) -> Void) {
                guard username == "johnny@appleseed.com", password == "appleseed" else {
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

            // for-in 循环模拟尝试使用无效、有效的登录凭据登录并执行操作
            for i in 1...2 {
                let password = (i % 2 == 0) ? "appleseed" : "password"

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
    }
}
