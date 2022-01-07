扩展可以给一个现有的类，结构体，枚举，还有协议添加新的功能。它还拥有不需要访问被扩展类型源代码就能完成扩展的能力（即逆向建模）。扩展和 Objective-C 的分类很相似。（与 Objective-C 分类不同的是，Swift 扩展是没有名字的。）


Swift 中的扩展可以：
* 添加计算型实例属性和计算型类属性
* 定义实例方法和类方法
* 提供新的构造器
* 定义下标
* 定义和使用新的嵌套类型
* 使已经存在的类型遵循（``conform``）一个协议

> 注意
> 
> * 扩展可以给一个类型添加新的功能，但是**不能重写已经存在的功能**。
> * 扩展可以添加新的计算属性，但是它们**不能添加存储属性，或向现有的属性添加属性观察者**。


## 1. 扩展的语法

使用 extension 关键字声明扩展：

```swift
extension SomeType {
  // 在这里给 SomeType 添加新的功能
}
```

扩展可以扩充一个现有的类型，给它添加一个或多个协议。协议名称的写法和类或者结构体一样：

```swift
// 扩展某个类的同时，让该类遵守指定的协议
extension SomeType: SomeProtocol, AnotherProtocol {
  // 协议所需要的实现写在这里
}
```


> 注意
> 
> 对一个现有的类型，如果你定义了一个扩展来添加新的功能，那么这个类型的所有实例都可以使用这个新功能，包括那些在扩展定义之前就存在的实例。


## 2. 计算型属性

扩展可以给现有类型添加**计算型实例属性**和**计算型类属性**。

```swift
// 给 Swift 内建的 Double 类型添加 5 个计算型实例属性
// 把一个 Double 值看作是某单位下的长度值。
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("一英寸等于 \(oneInch) 米。")
// 一英寸等于 0.0254 米。

let threeFeet = 3.ft
print("三英寸等于 \(threeFeet) 米。")
// 三英寸等于 0.914399970739201 米。
```


## 3. 构造器

扩展可以给现有的类型添加新的构造器。它使你可以把自定义类型作为参数来供其他类型的构造器使用，或者在类型的原始实现上添加额外的构造选项。

扩展可以给一个类添加新的**便利构造器**，但是它们不能给类添加新的指定构造器或者析构器。**指定构造器和析构器必须始终由类的原始实现提供**。

如果你使用扩展给一个值类型添加构造器，而这个值类型已经为所有存储属性提供默认值，且没有定义任何自定义构造器，那么你可以在该值类型扩展的构造器中使用默认构造器和成员构造器。如果你已经将构造器写在值类型的原始实现中，则不适用于这种情况，如同 值类型的构造器委托 中所描述的那样。
如果你使用扩展给另一个模块中定义的结构体添加构造器，那么新的构造器直到定义模块中使用一个构造器之前，不能访问 `self`。


```swift
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var orgin = Point()
    var size = Size()
}

// 使用默认构造器创建新的实例
let defaultRect = Rect()

// 使用默认的成员构造器创建新的实例
let memberwiseRect = Rect(orgin: Point(x: 2.0, y: 2.0),
                          size: Size(width: 5.0, height: 5.0))

// 扩展 Rect 结构体来提供一个允许指定 point 和 size 的构造器
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(orgin: Point(x: originX, y: originY), size: size)
    }
}

// 使用扩展实现的便捷方法创建一个新的实例
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
```

## 4. 方法

扩展可以给现有类型添加新的**实例方法**和**类方法**。

```swift
extension Int {
    // () -> Void 类型参数，表示一个没有参数没有返回值的方法
    func repetitions(task: () -> Void ) {
        for _ in 0..<self {
            task()
        }
    }
}

3.repetitions {
    print("Hello!")
}
//Hello!
//Hello!
//Hello!
```


### 4.1 可变实例方法（`mutating`）

> 💡 修改实例本身的方法，可以调用 `self`

通过扩展添加的实例方法同样也可以修改（或 mutating（改变））实例本身。结构体和枚举的方法，若是可以修改 `self` 或者它自己的属性，则必须将这个实例方法标记为 `mutating`，就像是改变了方法的原始实现。

```swift
extension Int {
    // 对原始值求平方
    mutating func square() {
        self = self * self
    }
}

var someInt = 3
someInt.square()
// 9
```


## 5. 下标

扩展可以给现有的类型添加新的下标。

```swift
// 通过扩展，为现有类型添加新的下标
// 下标 [n] 从数字右侧开始，返回小数点前的第 n 位
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

746381295[0]
// 返回 5
746381295[1]
// 返回 9
746381295[2]
// 返回 2
746381295[8]
// 返回 7
```


## 6. 内嵌类型

扩展可以给现有的类，结构体，还有枚举添加新的嵌套类型：

```swift
// 给 Int 添加了新的嵌套枚举
// 表示特定整数所代表的数字类型：正数、负数、零
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}

printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
// 打印：+ + - 0 - 0 + 
```