/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class MainViewController: UIViewController {
    // let user = User(name: "John")

    override func viewDidLoad() {
        super.viewDidLoad()

        runScenario()
    }

    func runScenario() {
        let user = User(name: "John")
        let iPhone = Phone(model: "iPhone Xs")
        user.add(phone: iPhone)

        let subscription = CarrierSubscription(name: "TelBel", countryCode: "0032", number: "31415926", user: user)
        iPhone.provision(carrierSubscription: subscription)

        print(subscription.completePhoneNumber())

        let greetingMaker: () -> String

        do {
            let mermaid = WWDCGreeting(who: "caffeinated mermaid")
            greetingMaker = mermaid.greetingMaker
        } // do 语句结束时，mermaid 引用的对象已经被释放。

        print(greetingMaker()) // 这里再次尝试在闭包中访问 self 所指向的 mermaid 对象，会引发运行时异常。

        do {
            let ernie = Person(name: "Ernie")
            let bert = Person(name: "Bert")

            ernie.friends.append(Unowned(bert))
            bert.friends.append(Unowned(ernie))

            // 通过包装器的 value 属性访问 Unowned 中的 Person 对象
            let firstFriend = bert.friends.first?.value // get ernie
        }
    }
}

/// 用户
class User {
    let name: String
    private(set) var phones: [Phone] = []
    var subscriptions: [CarrierSubscription] = []

    func add(phone: Phone) {
        phones.append(phone)
        phone.owner = self
    }

    init(name: String) {
        self.name = name
        print("User \(name) was initialized")
    }

    deinit {
        print("Deallocating user named: \(name)")
    }
}

/// 手机
class Phone {
    let model: String
    // 💡声明为弱引用，不增加引用计数，打破引用循环
    // 弱引用始终是可选（optional）的，并且当被引用的对象消失时会自动变为 nil。所以你必须将弱属性定义为可选的 var 类型。
    weak var owner: User?

    var carrierSubscription: CarrierSubscription?

    // 在手机上配置运营商
    func provision(carrierSubscription: CarrierSubscription) {
        self.carrierSubscription = carrierSubscription
    }

    // 停用运营商
    func decommission() {
        carrierSubscription = nil
    }

    init(model: String) {
        self.model = model
        print("Phone \(model) was initialized")
    }

    deinit {
        print("Deallocating phone named: \(model)")
    }
}

// 无主引用绝不是可选类型。如果您尝试访问引用已取消初始化对象的无主属性，您将触发运行时错误，类似于强制解包 nil 可选类型
/// 运营商订阅
class CarrierSubscription {
    let name: String
    let countryCode: String
    let number: String
    unowned let user: User // 没有用户的运营商订阅没有存在的意义，因此这里设置为无主引用

    // 将 [unowned self] 添加到闭包捕获列表中
    // [unowned self] 的完整语法 [unowned newID = self]
    // 如果您确定闭包中的引用对象永远不会释放，则可以使用 unowned。
    lazy var completePhoneNumber: () -> String = { [unowned self] in
        self.countryCode + " " + self.number
    }

    init(name: String, countryCode: String, number: String, user: User) {
        self.name = name
        self.countryCode = countryCode
        self.number = number
        self.user = user
        user.subscriptions.append(self)

        print("CarrierSubscription \(name) is initialized")
    }

    deinit {
        print("Deallocating CarrierSubscription named: \(name)")
    }
}

class WWDCGreeting {
    let who: String

    init(who: String) {
        self.who = who
    }

    /// <https://github.com/raywenderlich/swift-style-guide#memory-management>
    lazy var greetingMaker: () -> String = { [weak self] in
        guard let self = self else {
            return "No greeting available."
        }
        return "Hello \(self.who)."
    }
}

// 值类型不能递归调用自身
//struct Node {
//    var payload = 0
//    var next: Node?
//}

class Node {
    var payload = 0
    var next: Node?
}

// 通过 Generics 泛型包装器打破引用循环问题
class Unowned<T: AnyObject> {
    unowned var value: T
    init(_ value: T) {
        self.value = value
    }
}

class Person {
    var name: String

    // 你不能用 unowned 修饰数组，因为 unowned 只适用于 class 类型，而数组是个值类型。
    // var friends: [Person] = []

    var friends: [Unowned<Person>] = []

    init(name: String) {
        self.name = name
        print("New person instance: \(name)")
    }

    deinit {
        print("Person instance \(name) is being deallocated")
    }
}
