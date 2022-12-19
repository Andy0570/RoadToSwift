Swift 使用**自动引用计数**（ARC）机制来跟踪和管理你的应用程序的内存。通常情况下，Swift 内存管理机制会一直起作用，你无须自己来考虑内存的管理。ARC 会在类的实例不再被使用时，自动释放其占用的内存。

然而在少数情况下，为了能帮助你管理内存，ARC 知道需要更多的，代码之间关系的信息。

> 注意
> 
> **引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递的。**


### 自动引用计数的工作机制

...


### 自动引用计数实践

```swift
class Person {
    let name: String
    // 构造器
    init(name: String) {
        self.name = name
        print("\(name) is being initialized.")
    }
    // 析构器
    deinit {
        print("\(name) is being deinitialized.")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "John Appleseed")
// 打印：John Appleseed is being initialized.

reference2 = reference1
reference3 = reference1

reference1 = nil
reference2 = nil

reference3 = nil
// 打印：John Appleseed is being deinitialized.
```


### 类实例之间的循环强引用

如果两个类实例互相持有对方的强引用，因而每个实例都让对方一直存在，就是这种情况。这就是所谓的**循环强引用**。

你可以通过定义类之间的关系为**弱引用**或**无主引用**，来替代强引用，从而解决循环强引用的问题。


### 解决实例之间的循环强引用

Swift 提供了两种办法用来解决你在使用类的属性时所遇到的循环强引用问题：**弱引用**（weak reference）和**无主引用**（unowned reference）。

弱引用和无主引用允许循环引用中的一个实例引用另一个实例而不保持强引用。这样实例能够互相引用而不产生循环强引用。

**当其他的实例有更短的生命周期时，使用弱引用**，也就是说，当其他实例析构在先时。在上面公寓的例子中，很显然一个公寓在它的生命周期内会在某个时间段没有它的主人，所以一个弱引用就加在公寓类里面，避免循环引用。相比之下，**当其他实例有相同的或者更长生命周期时，请使用无主引用**。

#### 弱引用（`weak`）

**弱引用**不会对其引用的实例保持强引用，因而不会阻止 ARC 销毁被引用的实例。这个特性阻止了引用变为循环强引用。声明属性或者变量时，在前面加上 `weak` 关键字表明这是一个弱引用。

因为弱引用不会保持所引用的实例，即使引用存在，实例也有可能被销毁。因此，ARC 会在引用的实例被销毁后自动将其弱引用赋值为 `nil`。并且因为弱引用需要在运行时允许被赋值为 `nil`，所以它们会被定义为**可选类型变量**，而不是**常量**。

> 注意
>
> 在使用**垃圾收集**的系统里，弱指针有时用来实现简单的缓冲机制，因为没有强引用的对象只会在内存压力触发垃圾收集时才被销毁。但是在 ARC 中，一旦值的最后一个强引用被移除，就会被立即销毁，这导致弱引用并不适合上面的用途。


#### 无主引用（`unowned`）

和弱引用类似，无主引用不会牢牢保持住引用的实例。和弱引用不同的是，**无主引用在其他实例有相同或者更长的生命周期时使用**。你可以在声明属性或者变量时，在前面加上关键字 `unowned` 表示这是一个无主引用。
无主引用通常都被期望拥有值。不过 ARC 无法在实例被销毁后将无主引用设为 `nil`，因为非可选类型的变量不允许被赋值为 `nil`。

> 重点
> 使用无主引用，你必须确保引用始终指向一个未销毁的实例。
> 如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。

#### 无主引用和隐式解包可选值属性

```swift
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// 打印“Canada's capital city is called Ottawa”
```

### 闭包的循环强引用

循环强引用还会发生在当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了这个类实例时。

循环强引用的产生，是因为闭包和类相似，都是引用类型。当你把一个闭包赋值给某个属性时，你是将这个闭包的引用赋值给了属性。

Swift 提供了一种优雅的方法来解决这个问题，称之为**闭包捕获列表**（closure capture list）。

> Swift 有如下要求：只要在闭包内使用 `self` 的成员，就要用 `self.someProperty` 或者 `self.someMethod()`（而不只是 `someProperty` 或 `someMethod()`）。这提醒你可能会一不小心就捕获了 `self`。


#### 定义捕获列表

如果闭包**有参数列表和返回类型**，把捕获列表放在它们前面：

```swift
lazy var someClosure = {
    [unowned self, weak delegate = self.delegate]
    (index: Int, stringToProcess: String) -> String in
    // 这里是闭包的函数体
}
```

如果闭包**没有指明参数列表或者返回类型**，它们会通过上下文推断，那么可以把捕获列表和关键字 `in` 放在闭包最开始的地方：

```swift
lazy var someClosure = {
    [unowned self, weak delegate = self.delegate] in
    // 这里是闭包的函数体
}
```

#### 弱引用和无主引用

在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包内的捕获定义为**无主引用**。

相反的，在被捕获的引用可能会变为 `nil` 时，将闭包内的捕获定义为**弱引用**。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为 `nil`。这使我们可以在闭包体内检查它们是否存在。

> 注意
> 
> 如果被捕获的引用绝对不会变为 `nil`，应该用**无主引用**，而不是弱引用。