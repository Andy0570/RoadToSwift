## 存储属性

* 在最简单的形式下，存储属性是一个（作为特定类和结构体实例一部分的）常量或变量。
* 存储属性要么是**变量存储属性**（由 `var`  关键字引入）要么是**常量存储属性**（由 `let`  关键字引入）。
* 默认属性值：你可以为存储属性提供一个默认值作为它定义的一部分。
* 初始化属性值：你也可以在初始化的过程中设置和修改存储属性的初始值。

```Swift
// 定义一个名为 FixedLengthRange 固定长度范围的结构体
struct FixedLengthRange {
    var firstValue: Int // 变量存储属性
    let length: Int    // 常量存储属性
}

var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
// 该范围代表了整形值 0，1 和 2
rangeOfThreeItems.firstValue = 6
// 现在，该范围代表了整形值 6，7 和 8
```

### 常量结构体实例的存储属性

**如果你创建了一个结构体的实例并且把这个实例赋给常量，你不能修改这个实例的属性，即使是声明为变量的属性**：

```Swift
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

let rangeofFourItems = FixedLengthRange(firstValue: 0, length: 4)
// 该范围代表了整形值 0，1，2 和 3
rangeofFourItems.firstValue = 6
// error: cannot assign to property: 'rangeofFourItems' is a 'let' constant
```

由于 `rangeOfFourItems` 被声明为常量（用 `let` 关键字），我们不能改变其 `firstValue` 属性，即使 `firstValue` 是一个变量属性。

这是由于**结构体是值类型**。当一个值类型的实例被标记为常量时，该实例的其他属性也均为常量。

对于类来说则不同，它是引用类型。如果你给一个常量赋值引用类型实例，你仍然可以修改那个实例的变量属性。


### 延迟存储属性（`lazy`）

延迟存储属性的初始值在其第一次使用时才进行计算。你可以通过在其声明前标注 `lazy` 修饰语来表示一个延迟存储属性。

你必须把**延迟存储属性**声明为**变量**（使用 `var` 关键字），因为它的初始值可能在实例初始化完成之前无法取得。常量属性则必须在初始化完成之前有值，因此不能声明为延迟属性。

* 一个属性的*初始值可能依赖于某些外部因素*，当这些外部因素的值只有在实例的初始化完成后才能得到时，延迟属性就可以发挥作用了。
* 当属性的初始值需要*执行复杂或代价高昂的配置*才能获得，你又想要在需要时才执行，延迟属性就能够派上用场了。

> 💡 类似 Objective-C 中的 Lazy Loading 机制（通过重写属性的 `Getter` 方法实现），很显然，Swift 中的语法更简洁。

```Swift
// DataImporter 是一个用于从外部文件中导入数据的类
// 假定该类需要花费大量的时间来初始化
class DataImporter {    
    var fileNmae = "data.txt"
    // DataImporter 类将在这里提供数据导入功能
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]() // 存储属性，初始化为一个包含 String 类型的空数组
    // DataManager 类将在这里提供数据管理功能
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// 尚未创建导入程序属性的 DataImporter 实例
```

类 `DataManager` 有一个名为 `data` 的存储属性，它被初始化为一个空的新 `String` 数组。尽管它的其余功能没有展示出来，还是可以知道类 `DataManager` 的目的是管理并提供访问这个 `String` 数组的方法。

`DataManager` 类的功能之一是从文件导入数据。此功能由 `DataImporter` 类提供，它假定为需要一定时间来进行初始化。这大概是因为 `DataImporter` 实例在进行初始化的时候需要打开文件并读取其内容到内存中。

`DataManager` 实例并不要从文件导入数据就可以管理其数据的情况是有可能发生的，所以当 `DataManager` 本身创建的时候没有必要去再创建一个新的 `DataImporter` 实例。反之，在 `DataImporter` 第一次被使用的时候再创建它才更有意义。

因为它被 `lazy` 修饰符所标记，只有在 `importer` 属性第一次被访问时才会创建 `DataImporter` 实例，比如当查询它的 `fileName` 属性时：

```Swift
print(manager.importer.fileName)
// importer 属性的 DataImporter 实例现在已经被创建了
// 打印 “data.txt”
```

> 注意
> 
> 如果被标记为 `lazy` 修饰符的属性同时被多个线程访问并且属性还没有被初始化，则无法保证属性只初始化一次。

### 存储属性与实例变量

如果你有 Objective-C 的开发经验，那你应该知道在类实例里有两种方法来存储值和引用（instance 实例变量和 `@property` 属性）。另外，你还可以使用实例变量作为属性中所储存的值的备份存储。

Swift 把这些概念都统一到了属性声明里。**Swift 属性没有与之相对应的实例变量，并且属性的后备存储不能被直接访问**。这避免了不同环境中对值的访问的混淆并且将属性的声明简化为一条单一的、限定的语句。所有关于属性的信息 —— 包括它的名字，类型和内存管理特征 —— 都作为类的定义放在了同一个地方。


## 计算属性

除了存储属性，类、结构体和枚举也能够定义**计算属性**，而它实际并不存储值。相反，他们提供一个读取器和一个可选的设置器来间接得到和设置其他的属性和值。

> 💡 一个属性的值是通过其他属性的值，间接计算或推导获得的。比如说，矩形的面积、订单的合计金额、考试成绩的平均分...

```swift
// Point 结构体，封装了一个 (x, y) 坐标
struct Point {
    var x = 0.0, y = 0.0
}

// Size 结构体，封装了一个矩形的宽、高尺寸
struct Size {
    var width = 0.0, height = 0.0
}

// Rect 结构体，封装了一个长方形，包括原点坐标和大小
// Rect 结构还有个名为 center 的计算属性
struct Rect {
    var origin = Point() // 原点坐标
    var size = Size()    // 尺寸大小
  
    // center 是一个计算属性
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

// 矩形：(0.0, 0.0, 10.0, 10.0)
var square = Rect(origin: Point(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
// prints "square.origin is now at (10.0, 10.0)"
// 修改中心点后，矩形：(10.0, 10.0, 10.0, 10.0)
```



### 简写设置器（setter）声明

如果一个计算属性的设置器没有为将要被设置的值定义一个名字，那么他将被默认命名为 `newValue` 。下面是结构体 `Rect` 的另一种写法，其中利用了简写设置器声明的特性。

> 💡 `set` 方法中，形式参数的默认名称为 `newValue`。

```swift
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}
```


### 缩写读取器（getter）声明

如果整个 `getter` 的函数体是一个单一的表达式，那么 `getter` 隐式返回这个表达式。这里是另一个版本的 `Rect` 结构体，它利用 `getter` 和 `setter` 应用了缩写标记：

> 💡 单行表达式中，可以省略 `return` 关键字。

```swift
struct CompactRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {   
            Point(x: origin.x + (size.width / 2),
                  y: origin.y + (size.height / 2))
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}
```

在 `getter` 里省略 `return` 与在函数里省略 `return` 规则相同。


### 只读计算属性

一个有读取器但是没有设置器的计算属性就是所谓的**只读计算属性**。只读计算属性返回一个值，也可以通过点语法访问，但是不能被修改为另一个值。

> ⚠️
> 
> 你必须用 `var` 关键字定义计算属性 —— 包括只读计算属性 —— 为变量属性，因为它们的值不是固定的。 `let` 关键字只用于常量属性，用于明确那些值一旦作为实例初始化就不能更改。

你可以通过去掉 `get` 关键字和它的大扩号来简化只读计算属性的声明：

```swift
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
  
    // 该长方体的体积（volume）是一个只读计算属性
    var volume: Double {
        return width * height * depth
    }
}

let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
// prints "the volume of fourByFiveByTwo is 40.0"
```


## 属性观察者

属性观察者会观察并对属性值的变化做出回应。每当一个属性的值被**设置**时，属性观察者都会被调用，即使这个值与该属性当前的值相同。

你可以在如下地方添加属性观察者：

* 你定义的存储属性；
* 你继承的存储属性；
* 你继承的计算属性。

对于继承的属性，你可以通过在子类里重写属性来添加属性观察者。对于你定义的计算属性，使用属性的设置器来观察和响应值的变化，而不是创建观察者。

你可以选择将这些观察者或其中之一定义在属性上：

* `willSet` 会在该值被存储之前被调用。
* `didSet` 会在一个新值被存储后被调用。

如果你实现了一个 `willSet` 观察者，新的属性值会以常量形式参数传递。你可以在你的 `willSet` 实现中为这个参数定义名字。如果你没有为它命名，那么它会使用默认的名字 `newValue` 。

同样，如果你实现了一个 `didSet` 观察者，一个包含旧属性值的常量形式参数将会被传递。你可以为它命名，也可以使用默认的形式参数名 `oldValue` 。如果你在属性自己的 `didSet` 观察者里给自己赋值，你赋值的新值就会取代刚刚设置的值。

> 💡 属性观察器这个特性也很好用，在 Objective-C 中只能通过重写 setter 方法模仿 Swift 中的 `didSet` 的功能，实现一些设置模型后渲染 UI 或者设置 NSURL 之后发起网络请求功能。

```swift
// 定义一个 StepCounter 类，它追踪人散步的总数量
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalStpes) {
            print("About to set totalSteps to \(newTotalStpes)")
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps
```

> ⚠️
> 
> 如果你以输入输出形式参数传一个拥有观察者的属性给函数， `willSet` 和 `didSet` 观察者一定会被调用。这是由于输入输出形式参数的拷贝入拷贝出存储模型导致的：值一定会在函数结束后写回属性。


## 属性包装（`@propertyWrapper`）

属性包装给代码之间添加了一层分离层，它用来管理**属性如何存储数据**以及**代码如何定义属性**。比如说，如果你有一个提供线程安全检查或者把自身数据存入数据库的属性，你必须在每个属性里写相关代码。当你使用属性包装，你只需要在定义包装时写一遍就好了，然后把管理代码应用到多个属性上。

> 💡 用于封装属性通用功能的一段代码块。

要定义一个包装，你可创建一个**结构体**、**枚举**或者**定义了 `wrappedValue` 属性的类**。

```swift
// 声明该结构体遵守 @propertyWrapper 协议，并定义 wrappedValue 属性。
// 定义一个 TwelveOrLess 结构体，它确保内部的数字永远小于 12.
@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}
```

你可在属性前以特性的方式写包装的名字。这里有一个保存小四边形的结构体，使用了和 `TwelveOrLess` 中相同（而不是绝对）的对于 “小” 的定义包装实现：

```swift
// 一个保存四边形的结构体
struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
print(rectangle.height)
// Prints "0"

rectangle.height = 10
print(rectangle.height)
// Prints "10"

rectangle.height = 24
print(rectangle.height)
// Prints "12"
```

当你给属性应用包装时，编译器会**为包装生成提供存储的代码**以及**通过包装访问属性**的代码。（属性包装负责存储包装了的值，所以不需要合成代码。）你也可以自己写应用属性包装行为的代码，不使用特殊特性语法带来的优势。比如，这里有一个前面 `SmallRectangle` 的例子，它在 `TwelveOrLess` 结构体中显式地包装了自己的属性，而不是用 `@TwelveOrLess` 这个特性：

```swift
// 自己实现属性包装行为，不使用 @propertyWrapper 特性

// 一个保存四边形的结构体
struct SmallRectangle {
    // 计算属性
    // _height、_width 属性存储了一个属性包装的实例 TwelveOrLess
    private var _height = TwelveOrLess()
    private var _width = TwelveOrLess()
    
    // 存储属性
    // height、width 的 getter 和 setter 包装了 wrappedValue 属性的值
    var height: Int {
        get { return _height.wrappedValue }
        set { _height.wrappedValue = newValue }
    }
    var width: Int {
        get { return _width.wrappedValue }
        set { _width.wrappedValue = newValue }
    }
}
```

### 设定包装属性的初始值

上面例子中的代码通过在结构体 `TwelveOrLess` 的定义中给 `number` 初始值来给包装属性设定初始值。使用属性包装的代码，不能为被 `TwelveOrLess` 包装的属性设置不同的初始值 —— 比如说， `SmallRectangle` 的定义中，不能给 `height` 或者 `width` 初始值。要支持设置初始值或者其他自定义，属性包装必须**添加初始化器**。这里有一个 `TwelveOrLess` 的扩展版本叫做 `SmallNumber` ，它定义了一个初始化器来设置包装了的最大值：

> 💡 为「属性包装」添加初始化方法。

```swift
@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int
    
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }
    
    // 为「属性包装」添加初始化器
    init() {
        maximum = 12
        number = 0
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}
```

当你给属性应用包装但并不指定初始值时，Swift 使用 `init()` 初始化器来设置包装。比如说：

```swift
struct ZeroRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
}

var zeroRectangle = ZeroRectangle()
print(zeroRectangle.height, zeroRectangle.width)
// Prints "0 0"
```

当你为属性指定一个初始值时，Swift 使用 `init(wrappedValue:)` 初始化器来设置包装。比如：

```swift
struct UnitRectangle {
    // 为属性指定一个初始值
    @SmallNumber var height: Int = 1
    @SmallNumber var width: Int = 1
}

var unitRectangle = UnitRectangle()
print(unitRectangle.height, unitRectangle.width)
// Prints "1 1"
```

当你在应用了包装的属性上使用 = 1 时，它被翻译成调用 `init(wrappedValue:)` 初始化器。包装了 `height` 和 `width` 的实例 `SmallNumber` 通过调用 `SmallNumber(wrappedValue: 1)` 生成。初始化器使用这里指定的包装值，也就是使用默认 12 最大值。

当你在自定义特性后的括号中写实际参数时，Swift 使用接受那些实际参数的初始化器来设置包装。比如说，如果你提供初始值和最大值，Swift 使用 `init(wrappedValue:maximum:)` 初始化器：

```swift
struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
}

var narrowRectangle = NarrowRectangle()
print(narrowRectangle.height, narrowRectangle.width)
// Prints "2 3"

narrowRectangle.height = 100
narrowRectangle.width = 100
print(narrowRectangle.height, narrowRectangle.width)
// Prints "5 4"
```

* 包装 `height` 的 `SmallNumber` 实例通过调用 `SmallNumber(wrappedValue: 2, maximum: 5)` 生成；
* 包装 `width` 的 `SmallNumber` 实例通过调用 `SmallNumber(wrappedValue: 3, maximum: 4)` 生成；

当你包含属性包装实际参数时，你也可以通过赋值来指定初始值。Swift 把赋值看作是 `wrappedValue` 实际参数并且使用接受你包含的实际参数的初始化器来初始化。比如说：

```swift
struct MixedRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber(maximum: 9) var width: Int = 2
}

var mixedRectangle = MixedRectangle()
print(mixedRectangle.height)
// Prints "1"

mixedRectangle.height = 20
print(mixedRectangle.height)
// Prints "12"
```

* 包装 `height` 的 `SmallNumber` 实例通过调用 `SmallNumber(wrappedValue: 1)` 生成
* 包装 `width` 的 `SmallNumber` 实例通过调用 `SmallNumber(wrappedValue: 2, maximum: 9)` 生成。其中，赋值 2 被当作了 `wrappedValue` 的实际参数



### 通过属性包装映射值

对于包装值来说，包装属性可以通过定义映射值来暴露额外功能 —— 比如说，管理访问数据库的属性包装可以给它映射的值暴露一个 `flushDatabaseConnection()` 方法。映射值的名称和包装的值一样，除了它起始于一个美元符号（ `$` ）。因为你的代码不能定义 `$` 开头的属性，所以映射值不可能影响到你定义的属性。

在上面 `SmallNumber` 的例子中，如果你尝试设置一个过大的值给属性，属性包装就会在保存值之前调整。下面的代码给 `SmallNumber` 结构体添加了 `projectedValue` 属性以追踪属性包装是否在保存新值之前调整了新值的大小。

> 💡 给属性包装关联额外属性，然后通过 `$` 关键字访问。

```swift
@propertyWrapper
struct SmallNumber {
    private var number = 0
    var projectedValue = false
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
}

struct SomeStructure {
    @SmallNumber var someNumber: Int
}

var someStructure = SomeStructure()

someStructure.someNumber = 4
print(someStructure.$someNumber)
// Prints "false"

someStructure.someNumber = 55
print(someStructure.$someNumber)
// Prints "true"
```

使用 `s.$someNumber` 来访问包装的映射值。

属性包装可以返回它映射的任意类型值。在这个例子中，属性包装只暴露了一点信息 —— 数字是否被调整过 —— 所以它暴露了布尔值作为它映射的值。需要暴露更多信息的包装可以返回一个某种数据类型的实例，或者可以返回 `self` 来暴露包装自身实例作为映射值。

当你从某类型访问映射值，比如属性的 `getter` 或者实例方法，你可以在属性名前面省略 `self.` ，就像访问其他属性一样。下面例子中的代码将包装的 `height` 和 `width` 作为 `$height` 和 `$width` 来访问：

```swift
@propertyWrapper
struct SmallNumber {
    private var number = 0
    var projectedValue = false
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
}

enum Size {
    case small, large
}

struct SizeRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
    
    mutating func resize(to size: Size) -> Bool {
        switch size {
        case .small:
            height = 10
            width = 20
        case .large:
            height = 100
            width = 100
        }
        // $height 和 $width 返回的是关联的 Bool 类型变量 projectedValue
        return $height || $width
    }
}
```

由于属性包装语法仅仅是属性 `getter` 和 `setter` 的语法糖，访问 `height` 和 `width` 的行为和访问其他任意属性相同。比如说， `resize(to:)` 里的代码使用他们的属性包装访问 `height` 和 `width` 。如果你调用 `resize(to: .large)` ，`switch` 情况 `.large` 就会设置长方形的高和宽到 `100`. 包装这些属性的值大于 `12`，然后它设置映射值为 `true` ，以记录它调整了它们值这个事实。在 `resize(to:)` 结尾，返回语句检查 `$height` 和 `$width` 来决定属性包装是否调整了 `height` 或 `width` 。


## 全局和局部变量

上边描述的计算属性和观察属性的能力同样对全局变量和局部变量有效。**全局变量是定义在任何函数、方法、闭包或者类型环境之外的变量**。**局部变量是定义在函数、方法或者闭包环境之中的变量**。

你在之前章节中所遇到的全局和局部变量都是**存储变量**。存储变量，类似于存储属性，为特定类型的值提供存储并且允许这个值被设置和取回。

总之，你同样可以定义计算属性以及给存储变量定义观察者，无论是全局还是局部环境。计算变量计算而不是存储值，并且与计算属性的写法一致。

> ⚠️
> 
> **全局常量和变量永远是延迟计算的，与延迟存储属性有着相同的行为**。不同于延迟存储属性，全局常量和变量不需要标记 `lazy` 修饰符。

## 类型属性

实例属性是属于特定类型实例的属性。每次你创建这个类型的新实例，它就拥有一堆属性值，与其他实例不同。

你同样可以定义**属于类型本身的属性**，它不是这个类型的某一个实例的属性。这个属性只有一个拷贝，无论你创建了多少个类对应的实例。这样的属性叫做**类型属性**。

类型属性在定义那些对特定类型的所有实例都通用的值的时候很有用，比如实例要使用的常量属性（类似 C 里的静态常量），或者储存对这个类型的所有实例全局可见的值的存储属性（类似 C 里的静态变量）。

存储类型属性可以是变量或者常量。计算类型属性总要被声明为变量属性，与计算实例属性一致。

> 💡 区分：实例属性、类型属性。

### 类型属性语法（`static`）

在 C 和  Objective-C 中，你使用**全局静态变量**来定义一个与类型关联的静态常量和变量。在 Swift 中，总之，类型属性是写在类型的定义之中的，在类型的花括号里，并且每一个类型属性都显式地放在它支持的类型范围内。

**使用 `static` 关键字来声明类型属性**。对于类类型的计算类型属性，你可以使用 `class` 关键字来允许子类重写父类的实现。下面的栗子展示了存储和计算类型属性的语法：

```swift
// 结构体
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    // 声明一个只读计算属性
    static var computedTypeProperty: Int {
        return 1
    }
}

// 枚举类型
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}

// 类
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
```


### 查询和设置类型属性

类型属性使用点语法来查询和设置，与实例属性一致。总之，**类型属性在类里查询和设置，而不是这个类型的实例**。举例来说：

```swift
print(SomeStructure.storedTypeProperty)
// Prints "Some value."
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)
// Prints "Another value."

print(SomeEnumeration.computedTypeProperty)
// Prints "6"

print(SomeClass.computedTypeProperty)
// Prints "27"
```

