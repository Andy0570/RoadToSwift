**枚举**为一组相关的值定义了一个共同的类型，使你可以在你的代码中以类型安全的方式来使用这些值。

Swift 中的枚举更加灵活，不必给每一个枚举成员提供一个值。如果给枚举成员提供一个值（称为原始值），则该值的类型可以是字符串、字符，或是一个整型值或浮点数。


## 枚举语法

使用 `enum` 关键词来创建枚举并且把它们的整个定义放在一对大括号内：

```swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}

// 每个枚举定义了一个全新的类型。
var directionToHead = CompassPoint.west
// 当 directionToHead 的类型已知时，再次为其赋值可以省略枚举类型名。
directionToHead = .east
```


## 使用 Switch 语句匹配枚举值

```swift
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
// 打印“Watch out for penguins”
```

当不需要匹配每个枚举成员的时候，你可以提供一个 `default` 分支来涵盖所有未明确处理的枚举成员：

```swift
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}
// 打印“Mostly harmless”
```

## 枚举成员的遍历

令枚举遵循 `CaseIterable` 协议。Swift 会生成一个 `allCases` 属性，用于表示一个包含枚举所有成员的集合。

```swift
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")
// 打印“3 beverages available”

for beverage in Beverage.allCases {
    print(beverage)
}
// coffee
// tea
// juice
```

## 关联值

在 Swift 中，使用如下方式定义表示两种商品条形码的枚举：

```swift
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// 打印“QR code: ABCDEFGHIJKLMNOP.”

switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
// 打印“QR code: ABCDEFGHIJKLMNOP.”
```

以上代码可以这么理解：

“定义一个名为 Barcode 的枚举类型，它的一个成员值是具有 `(Int，Int，Int，Int)` 类型关联值的 `upc`，另一个成员值是具有 `String` 类型关联值的 `qrCode`。”


## 原始值

```swift
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
```


> 原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。


### 原始值的隐式赋值

使用枚举成员的 `rawValue` 属性可以访问该枚举成员的原始值：

```swift
// 声明了枚举的数据类型 Int
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

let earthsOrder = Planet.earth.rawValue
// earthsOrder 值为 3

// 当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。
enum CompassPoint: String {
    case north, south, east, west
}

let sunsetDirection = CompassPoint.west.rawValue
// sunsetDirection 值为 "west"
```

### 使用原始值初始化枚举实例


### 递归枚举*

递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。使用递归枚举时，编译器会插入一个间接层。你可以在枚举成员前加上 `indirect` 来表示该成员可递归。

```swift
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

你也可以在枚举类型开头加上 `indirect` 关键字来表明它的所有成员都是可递归的：

```swift
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```



