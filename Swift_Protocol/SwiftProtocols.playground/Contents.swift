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

// 参考：
// <https://www.kodeco.com/6742901-protocol-oriented-programming-tutorial-in-swift-5-1-getting-started>
// <https://chris.eidhof.nl/post/protocol-oriented-programming/>

// MARK: - Bird

protocol Bird: CustomStringConvertible {
    var name: String { get }
    var canFly: Bool { get }
}

// 协议扩展，让自定义协议遵守 Swift 标准库中的其他协议并定义默认行为
extension CustomStringConvertible where Self: Bird {
    var description: String {
        canFly ? "I can fly" : "Guess I'll just sit here :["
    }
}

// 协议扩展，只要类型遵守 Flyable 协议，表明它一定会飞，即默认返回 true
extension Bird {
    // Flyable birds can fly!
    var canFly: Bool { self is Flyable }
}

// MARK: - Flyable

protocol Flyable {
    var airspeedVelocity: Double { get }
}

// FlappyBird 是一个同时遵守 Bird 和 Flyable 协议的结构体类型
struct FlappyBird: Bird, Flyable {
    let name: String
    let flappyAmplitude: Double
    let flappyFrequency: Double

    // 计算属性
    var airspeedVelocity: Double {
        3 * flappyFrequency * flappyAmplitude
    }
}

// 企鹅是鸟，但它不会飞
struct Penguin: Bird {
    let name: String
}

// 雨燕也是鸟，而且会飞，版本（version）越高，飞得越快
struct SwiftBird: Bird, Flyable {
    var name: String { "Swift \(version)" }
    let version: Double
    private var speedFactor = 1000.0

    init(version: Double) {
        self.version = version
    }

    // Swift is FASTER with each version!
    var airspeedVelocity: Double {
        version * speedFactor
    }
}

// 枚举类型也可以遵守协议
enum UnladenSwallow: Bird, Flyable {
    case african
    case european
    case unknown

    var name: String {
        switch self {
        case .african:
            return "African"
        case .european:
            return "European"
        case .unknown:
            return "What do you mean? African or European?"
        }
    }

    var airspeedVelocity: Double {
        switch self {
        case .african:
            return 10.0
        case .european:
            return 9.9
        case .unknown:
            fatalError("You are thrown from the bridge of death!")
        }
    }
}

// 重写默认的行为
extension UnladenSwallow {
    var canFly: Bool {
        self != .unknown
    }
}

UnladenSwallow.unknown.canFly  // false
UnladenSwallow.african.canFly  // true
Penguin(name: "King Penguin").canFly  // false

UnladenSwallow.african



let numbers = [10, 20, 30, 40, 50, 60]
let slice = numbers[1...3]
let reversedSlice = slice.reversed()

let answer = reversedSlice.map { $0 * 10 }
print(answer)

// 摩托车类
class Motorcycle {
    init(name: String) {
        self.name = name
        speed = 200.0
    }

    var name: String
    var speed: Double
}

// MARK: - retroactive modeling 追溯建模

protocol Racer {
    var speed: Double { get }  // speed is the only thing racers care about
}

extension FlappyBird: Racer {
    var speed: Double {
        airspeedVelocity
    }
}

extension SwiftBird: Racer {
    var speed: Double {
        airspeedVelocity
    }
}

extension Penguin: Racer {
    var speed: Double {
        42  // full waddle speed
    }
}

extension UnladenSwallow: Racer {
    var speed: Double {
        canFly ? airspeedVelocity : 0.0
    }
}

extension Motorcycle: Racer {}

let racers: [Racer] =
[UnladenSwallow.african,
 UnladenSwallow.european,
 UnladenSwallow.unknown,
 Penguin(name: "King Penguin"),
 SwiftBird(version: 5.1),
 FlappyBird(name: "Felipe", flappyAmplitude: 3.0, flappyFrequency: 20.0),
 Motorcycle(name: "Giacomo")]

// RacerType 是这个函数的泛型类型，它可以是任何遵守 Swift 标准库的 Sequence 协议的类型。
// where 子句指定 Sequence 的 Element 类型必须遵守 Racer 协议才能使用此功能
func topSpeed<RacerType: Sequence>(of racers: RacerType) -> Double
    where RacerType.Iterator.Element == Racer {
    // 使用 Swift 标准库函数 max 来找到速度最快的赛车手并将其返回
    racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
}

topSpeed(of: racers) // 5100

topSpeed(of: racers[1...3]) // 42

// 借用 Swift 标准库的玩法，你现在已经扩展了Sequence本身，使其具有 topSpeed() 函数。
// 这个函数很容易被发现，而且只在你处理一个Racer类型的Sequence时适用。
extension Sequence where Iterator.Element == Racer {
    func topSpeed() -> Double {
        self.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
    }
}

racers.topSpeed()        // 5100
racers[1...3].topSpeed() // 42

// MARK: - 协议比较器

protocol Score: Comparable {
    var value: Int { get }
}

struct RacingScore: Score {
    let value: Int

    static func <(lhs: RacingScore, rhs: RacingScore) -> Bool {
        lhs.value < rhs.value
    }
}

RacingScore(value: 150) >= RacingScore(value: 130)  // true

// MARK: - 变异函数

protocol Cheat {
    mutating func boost(_ power: Double)
}

extension SwiftBird: Cheat {
    mutating func boost(_ power: Double) {
        speedFactor += power
    }
}

var swiftBird = SwiftBird(version: 5.0)
swiftBird.boost(3.0)
swiftBird.airspeedVelocity // 5015
swiftBird.boost(3.0)
swiftBird.airspeedVelocity // 5030
