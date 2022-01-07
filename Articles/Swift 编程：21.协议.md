**协议**定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。类、结构体或枚举都可以遵循协议，并为协议定义的这些要求提供具体实现。某个类型能够满足某个协议的要求，就可以说**该类型遵循这个协议**。

除了遵循协议的类型必须实现的要求外，还可以**对协议进行扩展**，通过扩展来实现一部分要求或者实现一些附加功能，这样遵循协议的类型就能够使用这些功能。


### 协议语法

```swift
protocol SomeProtocol {
    // 这里是协议的定义部分
}

// 让某个自定义类型遵循协议
struct SomeStrructure: FirstProtocol, AnotherProtocol {
    // 这里是结构体定义的部分
}

// 如果一个类拥有父类，应该将父类名放在遵循的协议名之前，以逗号分隔
class SomeClass: SuperClass, FirstProtocol, AnotherProtocol {
    // 这里是类定义的部分
}
```


### 属性要求

协议可以要求遵循协议的类型提供特定名称和类型的**实例属性**或**类型属性**。协议不指定属性是存储属性还是计算属性，它只指定属性的**名称**和**类型**。此外，协议还指定属性是**可读**的还是**可读可写**的。

```swift
protocol SomeProtocol {
    // { get set } 表示可读可写属性
    var mustBeSettable: Int { get set }
    // { get } 表示只读属性
    var doesNotNeedToBeSettable: Int { get }
    
    // 类型属性
    static var someTypeProperty: Int { get set }
}
```

示例：

```swift
// 该协议表示：任何遵循 FullyNamed 协议的类型，都必须有一个可读的 String 类型的实例属性 fullName
protocol FullyNamed {
    var fullName: String { get }
}

// -------------------------------------
// 遵循 FullyNamed 协议的简单结构体
struct Person: FullyNamed {
    // fullName 是一个存储属性
    var fullName: String
}

let john = Person(fullName: "John Appleseed")
// john.fullName 为 "John Appleseed"

// -------------------------------------
// 一个更为复杂的类，它遵循 FullyNamed 协议
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    // fullName 是一个只读的计算属性
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

var ncc1701 = Starship(name: "Enterprise", prefix: "UUS")
print("\(ncc1701.fullName)")
// UUS Enterprise
```


### 方法要求

协议可以要求遵循协议的类型实现某些指定的**实例方法**或**类方法**。这些方法作为协议的一部分，像普通方法一样放在协议的定义中，但是不需要大括号和方法体。可以在协议中定义具有可变参数的方法，和普通方法的定义方式相同。但是，不支持为协议中的方法提供默认参数。

```swift
protocols SomeProtocol {
    // 类方法
    static func someTypeMethod()
    
    // 实例方法
    func random() -> Double
}
```

示例：

```swift
protocol RandomNumberGenerator {
    func random() -> Double
}

// 遵循并符合 RandomNumberGenerator 协议的类
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// 打印 “Here's a random number: 0.3746499199817101”
print("And another one: \(generator.random())")
// 打印 “And another one: 0.729023776863283”
```

### 异变方法要求

有时需要在方法中改变（或异变）方法所属的实例。例如，在值类型（即结构体和枚举）的实例方法中，将 `mutating` 关键字作为方法的前缀，写在 `func` 关键字之前，表示**可以在该方法中修改它所属的实例以及实例的任意属性的值**。这一过程在「在实例方法中修改值类型」章节中有详细描述。

如果你在协议中定义了一个实例方法，该方法会改变遵循该协议的类型的实例，那么在定义协议时需要在方法前加 `mutating` 关键字。这使得结构体和枚举能够遵循此协议并满足此方法要求。

> 注意
> 
> 实现协议中的 `mutating` 方法时，若是类类型，则不用写 `mutating` 关键字。而对于结构体和枚举，则必须写 `mutating` 关键字。


```swift
protocol Togglable {
    // 当 toggle() 方法被调用时，会改变遵循协议的类型的实例
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch 现在的值为 .on
```


### 构造器要求

**协议可以要求遵循协议的类型实现指定的构造器**。你可以像编写普通构造器那样，在协议的定义里写下构造器的声明，但不需要写花括号和构造器的实体：

```swift
protocol SomeProtocol {
    init(someParameter: Int)
}
```

#### 协议构造器要求的类实现

你可以在遵循协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器。**无论哪种情况，你都必须为构造器实现标上 `required` 修饰符**。

> 注意
> 
> 如果类已经被标记为 `final`，那么**不需要**在协议构造器的实现中使用 `required` 修饰符，因为 `final` 类不能有子类。


```swift
protocol SomeProtocol {
    init(someParameter: Int)
}

class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // 这里是构造器的实现部分
    }
}
```

使用 `required` 修饰符可以确保所有子类也必须提供此构造器实现，从而也能遵循协议。



如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标注 `required` 和 `override` 修饰符：

```swift
protocol SomeProtocol {
    init()
}

class SomeSuperClass, SomeProtocol {
    init() {
        // 这里是构造器的实现部分
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // 因为遵循协议，需要加上 required
    // 因为继承自父类，需要加上 override
    required override init() {
        // 这里是构造器的实现部分
    }
}
```

#### 可失败构造器要求

协议还可以为遵循协议的类型定义可失败构造器要求。

遵循协议的类型可以通过可失败构造器（`init?`）或非可失败构造器（`init`）来满足协议中定义的可失败构造器要求。协议中定义的非可失败构造器要求可以通过非可失败构造器（`init`）或隐式解包可失败构造器（`init!`）来满足。


### 协议作为类型

尽管协议本身并未实现任何功能，但是协议可以被当做一个功能完备的类型来使用。协议作为类型使用，有时被称作「存在类型」，这个名词来自「存在着一个类型 T，该类型遵循协议 T」。

协议可以像其他普通类型一样使用，使用场景如下：
* 作为函数、方法或构造器中的参数类型或返回值类型；
* 作为常量、变量或属性的类型；
* 作为数组、字典或其他容器中的元素类型；


下面是将协议作为类型使用的例子：

```swift
class Dice {
    let sides: Int
    
    // 任何遵循了 RandomNumberGenerator 协议的类型的实例都可以赋值给 generator
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
```

### 委托

委托是一种设计模式，它允许类或结构体将一些需要它们负责的功能委托给其他类型的实例。

委托模式的实现很简单：定义协议来封装那些需要被委托的功能，这样就能确保遵循协议的类型能提供这些功能。委托模式可以用来响应特定的动作，或者接收外部数据源提供的数据，而无需关心外部数据源的类型。


### 在扩展里添加协议遵循

即便无法修改源代码，依然可以通过扩展令已有类型遵循并符合协议。扩展可以为已有类型添加属性、方法、下标以及构造器，因此可以符合协议中的相应要求。

```swift
protocol TextRepresentable {
    var texturalDescription: String { get }
}

extension Dice: TextRepresentable {
    var texturalDescription: String {
        return "A \(sides)-sided dice"
    }
}
```

通过扩展遵循并采纳协议，和在原始定义中遵循并符合协议的效果完全相同。




### 有条件地遵守协议


泛型类型可能只在某些情况下满足一个协议的要求，比如当类型的泛型形式参数遵循对应协议时。你可以通过**在扩展类型时列出限制让泛型类型有条件地遵循某协议**。在你采纳协议的名字后面写泛型 `where` 分句。


```swift
protocol TextRepresentable {
    var textualDescription: String { get }
}

// 让 Array 类型只要在存储遵循 TextRepresentable 协议的元素时就遵循 TextRepresentable 协议
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

let myDice = [d6, d12]
print(myDice.textualDescription)
// 打印 "[A 6-sided dice, A 12-sided dice]"
```


### 在扩展里声明采纳协议

当一个类型已经遵循了某个协议中的所有要求，却还没有声明采纳该协议时，可以通过空的扩展来让它采纳该协议：

> 注意
> 
> 即使满足了协议的所有要求，类型也不会自动遵循协议，**必须显式地声明遵循协议**。

```swift
struct Hamster {
    var name: String
       // 该类已经实现了 TextRepresentable 协议所需的方法
       var textualDescription: String {
        return "A hamster named \(name)"
    }
}

// 在空的扩展中声明遵守 TextRepresentable 协议
extension Hamster: TextRepresentable {}
```


### 使用合成实现来采纳协议

**Swift 可以自动提供一些简单场景下遵循 `Equatable`、`Hashable` 和 `Comparable` 协议的实现**。在使用这些合成实现之后，无需再编写重复的代码来实现这些协议所要求的方法。

Swift 为以下几种自定义类型提供了 `Equatable` 协议的合成实现：
* 遵循 `Equatable` 协议且只有存储属性的结构体。
* 遵循 `Equatable` 协议且只有关联类型的枚举。
* 没有任何关联类型的枚举。

在包含类型原始声明的文件中声明对 `Equatable` 协议的遵循，可以得到 `==` 操作符的合成实现，且无需自己编写任何关于 `==` 的实现代码。`Equatable` 协议同时包含 `!=` 操作符的默认实现。

```swift
// Vector3D 是一个遵循 Equatable 协议的结构体
// 它只有三个存储属性 x、y、z
// 因此可以自动获得 Swift 对其 Equatable 协议的合成实现
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}

let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)

if twoThreeFour == anotherTwoThreeFour {
    print("These two vectors are also equivalent.")
}
// 打印：These two vectors are also equivalent.
```

Swift 为以下几种自定义类型提供了 `Hashable` 协议的合成实现：
* 遵循 `Hashable` 协议且只有存储属性的结构体。
* 遵循 `Hashable` 协议且只有关联类型的枚举
* 没有任何关联类型的枚举

**在包含类型原始声明的文件中声明对 `Hashable` 协议的遵循，可以得到 `hash(into:)` 的合成实现，且无需自己编写任何关于 `hash(into:)` 的实现代码**。

Swift 为没有原始值的枚举类型提供了 `Comparable` 协议的合成实现。如果枚举类型包含关联类型，那这些关联类型也必须同时遵循 `Comparable` 协议。在包含原始枚举类型声明的文件中声明其对 `Comparable` 协议的遵循，可以得到 `<` 操作符的合成实现，且无需自己编写任何关于 `<` 的实现代码。

**`Comparable` 协议同时包含 `<=`、`>` 和 `>=` 操作符的默认实现**。


### 协议类型的集合

协议类型可以在数组或者字典这样的集合中使用，在 协议类型 提到了这样的用法。


```swift
protocol TextRepresentable {
    var textualDescription: String { get }
}

// 创建一个元素类型为 TextRepresentable 的数组
// 意为：数组中的每一个元素都是遵守 TextRepresentable 的实例
let things: [TextRepresentable] = [game, d12, simonTheHamster];

// thing 常量是 TextRepresentable 类型
// 所以在每次循环中可以安全地访问 thing.textualDescription
for thing in things {
    print(thing.textualDescription)
}
// A game of Snakes and Ladders with 25 squares
// A 12-sided dice
// A hamster named Simon
```


### 协议的继承

**协议能够继承一个或多个其他协议**，可以在继承的协议的基础上增加新的要求。协议的继承语法与类的继承相似，多个被继承的协议间用逗号分隔：

```swift
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // 这里是协议的定义部分
}
```


### 类专属的协议

**通过添加 `AnyObject` 关键字到协议的继承列表，就可以限制协议只能被类类型采纳**（以及非结构体或者非枚举的类型）。


```swift
protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
    // 这里是类专属协议的定义部分
}
```


### 协议合成

要求一个类型同时遵循多个协议是很有用的。你可以使用**协议组合**来复合多个协议到一个要求里。协议组合行为就和你定义的临时局部协议一样拥有构成中所有协议的需求。协议组合不定义任何新的协议类型。

协议组合使用 `SomeProtocol & AnotherProtocol` 的形式。你可以列举任意数量的协议，用和符号（`&`）分开。除了协议列表，协议组合也能包含类类型，这允许你标明一个需要的父类。

```swift
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}

// 函数 wishHappyBirthday 的参数 celebrator 的类型为 Named & Aged
// 表示：任何同时遵循 Named 和 Aged 的协议
// 它不关心参数的具体类型，只要参数遵循这两个协议即可。
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)
// 打印：Happy birthday, Malcolm, you're 21
```


### 检查协议一致性

你可以使用 类型转换 中描述的 `is` 和 `as` 操作符来检查协议一致性，即**是否遵循某协议**，并且可以转换到指定的协议类型。检查和转换协议的语法与检查和转换类型是完全一样的：
* `is` 用来检查实例是否遵循某个协议，若遵循则返回 `true`，否则返回 `false`；
* `as?` 返回一个可选值，当实例遵循某个协议时，返回类型为**协议类型的可选值**，否则返回 `nil`；
* `as!` 将实例强制向下转换到某个协议类型，如果强转失败，将触发运行时错误。



### 可选的协议要求（`optional`）


协议可以定义可选要求，遵循协议的类型可以选择是否实现这些要求。在协议中使用 `optional` 关键字作为前缀来定义可选要求。**可选要求用在你需要和 Objective-C 打交道的代码中**。协议和可选要求都必须带上 `@objc` 属性。标记 `@objc` 特性的协议只能被继承自 Objective-C 类的类或者 `@objc` 类遵循，其他类以及结构体和枚举均不能遵循这种协议。


### 协议扩展

协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以**基于协议本身来实现这些功能**，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数。


#### 提供默认实现

可以通过协议扩展来为协议要求的方法、计算属性提供默认的实现。如果遵循协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。


#### 为协议扩展添加限制条件

在扩展协议的时候，可以指定一些限制条件，只有遵循协议的类型满足这些限制条件时，才能获得协议扩展提供的默认实现。这些限制条件写在协议名之后，使用 `where` 子句来描述，正如 「泛型 Where 子句」 中所描述的。