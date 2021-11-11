**方法** 是关联了特定类型的函数。类，结构体以及枚举都能定义**实例方法**，方法封装了给定类型特定的任务和功能。类，结构体和枚举同样可以定义**类型方法**，这是与类型本身关联的方法。类型方法与 Objective-C 中的类方法相似。

## 实例方法

**实例方法** 是属于特定类实例、结构体实例或者枚举实例的函数。他们为这些实例提供功能性，要么通过提供访问和修改实例属性的方法，要么通过提供与实例目的相关的功能。实例方法与**函数**的语法完全相同。

要写一个实例方法，你需要把它放在对应类的花括号之间。实例方法默认可以访问同类下所有其他实例方法和属性。实例方法只能在类型的具体实例里被调用。它不能在独立于实例而被调用。

```swift
class Counter {
    var count = 0
    // 实例方法1：每次给计数器增加 1
    func increment() {
        count += 1
    }
    // 实例方法2：按照特定的整型数量来增加 计数器
    func increment(by amount: Int) {
        count += amount
    }
    // 实例方法3：把计数器重置为零
    func reset() {
        count = 0
    }
}

let counter = Counter() // count = 0
counter.increment() // count = 1
counter.increment(by: 5) // count = 6
counter.reset() // count = 0
```


### self 属性

每一个类的实例都隐含一个叫做 `self` 的属性，它完完全全与实例本身相等。你可以使用 `self` 属性来在当前实例当中调用它自身的方法。

在上边的例子中， `increment()` 方法可以写成这样：

```swift
func increment() {
    self.count += 1
}
```

实际上，你不需要经常在代码中写 `self`。如果你没有显式地写出 `self`，Swift 会在你于方法中使用已知属性或者方法的时候假定你是调用了当前实例中的属性或者方法。这个假定通过在 `Counter` 的三个实例中使用 `count`（而不是 `self.count`）来做了示范。

对于这个规则的一个重要例外就是**当一个实例方法的形式参数名与实例中某个属性拥有相同的名字的时候**。在这种情况下，**形式参数名具有优先权**，并且调用属性的时候使用更加严谨的方式就很有必要了。你可以使用 `self` 属性来区分形式参数名和属性名。
这时， `self` 就避免了叫做 x 的方法形式参数还是同样叫做 x 的实例属性这样的歧义。


```swift
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}

let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}
// This point is to the right of the line where x == 1.0
```

### 在实例方法中修改值类型（`mutating`）

**结构体**和**枚举**是值类型。**默认情况下，值类型属性不能被自身的实例方法修改**（因为传递值类型时会执行拷贝，而不是引用）。

总之，**如果你需要在特定的方法中修改「结构体」或者「枚举」的属性，你可以选择将这个方法异变**。然后这个方法就可以在方法中异变（嗯，改变）它的属性了，并且任何改变在方法结束的时候都会写入到原始的结构体中。方法同样可以指定一个全新的实例给它隐含的 `self` 属性，并且这个新的实例将会在方法结束的时候替换掉现存的这个实例。

> 💡 通过 `mutating` 关键字在实例方法中修改结构体、枚举属性的值！

你可以选择在 `func` 关键字前放一个 `mutating` 关键字来使用这个行为：

```swift
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var somePoint = Point(x: 1.0, y: 1.0) // (1, 1)
somePoint.moveBy(x: 2.0, y: 3.0) // (3, 4)
print("The point is now at (\(somePoint.x), \(somePoint.y))")
// The point is now at (3.0, 4.0)
```


### 在异变方法里指定自身

异变方法可以指定整个实例给隐含的 `self` 属性。上文中那个 `Point` 的栗子可以用下边的代码代替：

```swift
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaY, y: y + deltaY)
    }
}
```

枚举的异变方法可以设置隐含的 `self` 属性为相同枚举里的不同成员：

```swift
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}

var orenLight = TriStateSwitch.low
orenLight.next()
// ovenLight is now equal to .high
orenLight.next()
// ovenLight is now equal to .off
```

这个栗子定义了一个三种开关状态的枚举。每次调用 `next()` 方法时，这个开关就会在三种不同的电力状态（ `Off` , `low` 和 `high`）下切换。


## 类型方法

实例方法是特定类型实例中调用的方法。你同样可以定义在类型本身调用的方法。这类方法被称作类型方法。你可以通过在 `func` 关键字之前使用 `static` 关键字来明确一个**类型方法**。类同样可以使用 `class` 关键字来**允许子类重写父类对类型方法的实现**。

类型方法和实例方法一样使用点语法调用。不过，你得在类上调用类型方法，而不是这个类的实例。接下来是一个在 `SomeClass` 类里调用类型方法的栗子：

```swift
class SomeClass {
    static func someTypeMethod() {
        // type method implementation goes here
    }
}

SomeClass.someTypeMethod()
```

示例：

```swift
// LevelTracker 结构体持续追踪任意玩家解锁的最高等级
struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    
    // 类型函数 unlock(_:) 在新等级解锁时更新 highestUnlockedLevel
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }
    
    // 类型函数 isUnlocked(_:) 返回特定等级是否解锁
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    // 实例方法 advance(to:) 更新当前游戏中的游戏等级
    // @discardableResult 忽略返回值
    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        // 判断是否已解锁当前等级
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

// LevelTracker 结构体与 Player 类共同使用来追踪和更新每一个玩家的进度
class Player {
    var tracker = LevelTracker()
    let playerName: String
    // 玩家每完成一个特定等级，就解锁下一个等级并更新玩家的进度到下一个等级
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
// highest unlocked level is now 2
```

