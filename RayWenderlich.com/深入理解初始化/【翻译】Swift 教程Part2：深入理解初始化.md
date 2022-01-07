> 原文：[Swift Tutorial: Initialization In Depth, Part 2/2](https://www.raywenderlich.com/1219-swift-tutorial-initialization-in-depth-part-)
>
> 继续学习初始化，涵盖类的初始化、子类和便捷初始化方法，使你的 Swift 技能更上一层楼。



在本教程的第一部分，你学习了 Swift 中结构体的初始化，并通过为NASA的火星载人任务创建一个发射序列数据模块来应用它。你实现了结构体的初始化，尝试了初始化委托，并了解了何时以及为何使用可失败和可抛出错误的初始化。

但还有更多要学的，NASA仍然需要你的帮助！在本教程的第二部分，你将学习Swift中类的初始化。类的初始化与Objective-C中的类初始化有很大不同，当第一次在Swift中编写类的初始化器时，你会遇到许多不同的编译器错误。本教程将带领你了解潜在的问题，并向你提供所有必要的解释，以避免这些编译器错误。

在本教程的这一部分，你会

* 看到类的初始化委托等价物。
* 学习关于类的可失败和可抛出错误初始化器的额外规则。
* 学习类是如何在类的层次结构中委托初始化的，以及
* 学习类是如何继承初始化器的

请确保先完成第一部分，因为这里你将在你所学的基础上进行学习。


## 开始

你可以继续在第一部分的Playground上工作，或者创建一个新的Playground。本部分的代码不依赖于第一部分的任何代码，但本教程需要 Foundation，所以要确保Playground导入Foundation。导入UIKit或AppKit符合这一要求。

## 初始化委托

距离火星升空只有一年时间了，在发送发射系统代码之前，你已经完成了所有的任务，只有一项非常重要的任务：你需要实现代表不同火箭组件的模型。具体来说，就是存放火箭燃料和液态氧的罐子。
在这一过程中，你会看到初始化器委托与类的工作方式的不同。

### 指定初始化方法

将 `RocketComponent` 类添加到你的Playground的末尾：

```swift
// 火箭组件
class RocketComponent {
    let model: String
    let serialNumber: String
    let reusable: Bool

    // Init #1a - Designated
    init(model: String, serialNumber: String, reusable: Bool) {
        self.model = model
        self.serialNumber = serialNumber
        self.reusable = reusable
    }
}
```

`RocketComponent` 是另一个简单类。它有三个常量存储属性和一个指定初始化方法。

还记得本教程第一部分中的委托初始化方法吗？记得一个委托初始化方法链最终会以调用一个非委托初始化方法结束。在类的世界里，指定初始化方法只是非委托初始化方法的一个高级术语。就像对待结构一样，这些初始化器负责为所有声明的没有默认值的非可选类型的存储属性提供初始值。

注释`"// Init #1a - Designated"`不是必须的，但随着你在本教程中的进一步深入，这些类型的注释将有助于保持你的初始化器的条理性。

在Playground的底部，添加如下代码，看看指定初始化方法在运行：

```swift
// 指定初始化方法
let payload = RocketComponent(model: "RT-1", serialNumber: "234", reusable: false)
```



### 便捷初始化方法

那么委托初始化方法呢？它们在类的世界里也有一个漂亮的名字 :]。在 `RocketComponent` 中实现以下便捷初始化方法：

```swift
// Init #1b - Convenience
convenience init(model: String, serialNumber: String) {
    self.init(model: model, serialNumber: serialNumber, reusable: false)
}
```

注意这看起来就像结构体中的委托初始化方法。唯一不同的是，你必须在声明前加上关键字 `convenience`。

在Playground的最后，使用便捷初始化方法来创建另一个`RocketComponent`的实例：

```swift
// 便捷初始化方法
let fairing = RocketComponent(model: "Serpent", serialNumber: "0")
```

与结构体的工作方式类似，便捷初始化方法让你拥有更简单的初始化方法，只需在内部调用它自身的指定初始化方法。



## 失败和抛出异常策略

设计可失败和抛出异常的初始化器是一门艺术——幸好它不需要绘画。一开始，你可能会发现自己写的代码难以阅读，所以下面是一些策略，可以最大限度地提高可失败和抛出异常的初始化器的可读性。

### 从指定初始化方法中失败和抛出异常

比方说，这次任务中的所有火箭部件都以格式化的字符串报告它们的型号和序列号：型号后面有一个连字符，然后是序列号。例如，"Athena-003"。实现一个新的`RocketComponent` 可失败指定初始化方法，它接收这个格式化的标识符字符串：

```swift
// Init #1c - Designated
init?(identifier: String, reusable: Bool) {
    let identifierComponents = identifier.components(separatedBy: "-")
    guard identifierComponents.count == 2 else {
        return nil
    }

    self.reusable = reusable
    self.model = identifierComponents[0]
    self.serialNumber = identifierComponents[1]
}
```

在继续之前，请实例化以下常量，看看这个初始化器的工作情况：

```swift
// 可失败初始化器
let component = RocketComponent(identifier: "R2-D21", reusable: true)
let nocomponent = RocketComponent(identifier: "", reusable: true)
```

请注意侧边栏中的 `nonComponent` 是如何被正确设置为 `nil` 的，因为这个标识符并不遵循 model-serial 的格式。



### 从便捷初始化方法中失败和抛出异常

用下面的实现代替你刚才写的初始化器：

```swift
// Init #1c - Convenience
convenience init?(identifier: String, reusable: Bool) {
    let identifierComponents = identifier.components(separatedBy: "-")
    guard identifierComponents.count == 2 else {
        return nil
    }
    self.init(model: identifierComponents[0], serialNumber: identifierComponents[1],
              reusable: reusable)
}
```

<img src="https://koenig-media.raywenderlich.com/uploads/2015/12/thumbsup.jpg" style="zoom:50%;" />

这个版本更加简明。

在编写初始化程序时，使指定初始化程序不失败，并让它们设置所有的属性。然后你的便捷初始化方法可以有失败逻辑，并将实际的初始化委托给指定初始化方法。

注意，这种方法有一个缺点，与继承有关。别担心，我们将在本教程的最后一节探讨如何克服这个缺点。


## 子类

这就是关于根类初始化的所有知识。根类是不继承其他类的，就是你到目前为止一直在使用的。本教程的其余部分将重点介绍继承类的初始化。

公平的警告：这就是事情变得颠簸的地方! 类的初始化要比结构的初始化复杂得多，因为只有类支持继承。

### 与Objective-C的不同

> 注意：如果你以前从未见过 Objective-C 代码，不要担心--你仍然可以阅读本节内容。

如果你用过 Objective-C 编程，Swift 的类初始化会感觉很受限制。在类和继承方面，Swift 定义了许多新的、不那么明显的初始化规则。如果你遇到执行这些初始化规则的意外编译器错误，请不要感到惊讶。

不要在你的Playground上写任何这些 Objective-C 代码--你很快就会跳回你的 Swift Playground，但首先我将讨论 Objective-C，以展示初始化的天真方法。

为什么 Swift 会有这么多规则？考虑一下下面这个 Objective-C 的头文件：

```objective-c
@interface RocketComponent : NSObject

@property(nonatomic, copy) NSString *model;
@property(nonatomic, copy) NSString *serialNumber;
@property(nonatomic, assign) BOOL reusable;

- (instancetype)init;

@end
```

假设初始化器没有设置 `RocketComponent` 的任何属性。Objective-C 会自动将所有属性初始化为一个类似于空的值，比如 NO 或 0 或 `nil`。底线：这段代码能够创建一个完全初始化的实例。

请注意，带有非可选类型属性的等价类在 Swift 中不会被编译，因为编译器不知道用什么值来初始化属性。Swift 不会将属性自动初始化为空值；它只会将可选类型的属性自动初始化为 `nil`。正如你在本教程的第一部分所看到的，程序员有责任为所有非可选的存储属性定义初始值；否则 Swift 编译器会抱怨。

Objective-C 和 Swift 初始化行为之间的这种区别是理解一长串 Swift 类初始化规则的基础。假设你更新了 Objective-C 的初始化器，为每个属性设置初始值：

```objective-c
@interface RocketComponent : NSObject

@property(nonatomic, copy) NSString *model;
@property(nonatomic, copy) NSString *serialNumber;
@property(nonatomic, assign) BOOL reusable;

- (instancetype)initWithModel:(NSString *)model
                 serialNumber:(NSString *)serialNumber
                     reusable:(BOOL)reusable;

@end

```

`RocketComponent` 现在知道如何在不使用空值的情况下初始化一个实例。这一次，Swift 的等价物会编译成功。



### 添加属性到子类

请看下面的 `RocketComponent` 在 Objective-C 子类和它的实例化：

```objective-c
@interface Tank : RocketComponent

@property(nonatomic, copy) NSString *encasingMaterial;

@end

Tank *fuelTank = [[Tank alloc] initWithModel:@"Athena" serialNumber:@"003" reusable:YES];
```

`Tank` 引入了一个新的属性，但没有定义一个新的初始化器。这没关系，因为根据 Objective-C 的行为，新属性将被初始化为 `nil`。注意 `fuelTank` 是一个由`RocketComponent`（超类）实现的初始化器初始化的 `Tank`。`Tank`继承了`RocketComponent`的`initWithModel:serialNumber:reusable:` 方法。

这就是事情在 Swift 中真正开始崩溃的地方。要看到这一点，请在你的Playground上用 Swift 写出上面的 Tank 子类的对应代码。请注意，这段代码将不会被编译通过：

```swift
class Tank: RocketComponent {
    let encasingMaterial: String
}
```

![](https://koenig-media.raywenderlich.com/uploads/2015/12/SwiftInitClassError3.png)

注意这个子类如何引入了一个新的存储属性，`encasingMaterial`。这段代码不能编译，因为 Swift 不知道如何完全初始化 Tank 的一个实例。Swift 需要知道应该用什么值来初始化新的`encasingMaterial`属性。

你有三个选择来解决这个编译器错误：
1. 添加一个指定初始化方法，调用或重写超类 `RocketComponent` 的指定初始化方法。
2. 添加一个便捷初始化方法，调用超类 `RocketComponent` 的指定初始化方法。
3. 为存储的属性添加一个默认值。

让我们选择方案3，因为它是最简单的。更新 `Tank` 子类，将 "Aluminum" 声明为`encasingMaterial` 的默认属性值。

```swift
class Tank: RocketComponent {
    let encasingMaterial: String = "Aluminum"
}
```

它可以编译和运行! 不仅如此，你的努力还得到了回报：你可以利用从 `RocketComponent` 继承来的初始化器，而不需要给 `Tank` 自定义一个。



### 使用继承的初始化器

用这个代码实例化一个 `Tank`：

```swift
let fuelTank = Tank(model: "Athena", serialNumber:"003", reusable: true)
let liquidOxygenTank = Tank(identifier: "LOX-012", reusable: true)
```

这是解决缺少初始化器的编译器错误的简单方法。这和 Objective-C 中的工作一样。然而，大多数情况下，你的子类不会自动继承其超类的初始化器。你将在后面看到这个动作。

了解在子类中添加存储属性的影响对于避免编译器错误至关重要。在为下一节做准备时，注释掉 `fuelTank` 和 `liquidOxygenTank` 的实例：

```swift
//let fuelTank = Tank(model: "Athena", serialNumber:"003", reusable: true)
//let liquidOxygenTank = Tank(identifier: "LOX-012", reusable: true)
```



### 为子类添加指定初始化方法

`Tank` 的 `encasingMaterial` 是一个常量属性，默认值为 "Aluminum"。如果你需要实例化另一个不是用铝包裹的坦克，该怎么办？为了适应这个要求，移除默认的属性值，使其成为一个变量而不是常量：

```swift
class Tank: RocketComponent {
    var encasingMaterial: String
}
```

编译器的错误是："Class ‘Tank’ has no initializers"。每个引入新的没有默认值的非可选存储属性的子类都需要至少一个指定初始化方法。这个初始化器应该接收`encasingMaterial`的初始值，以及`RocketComponent`超类中声明的所有属性的初始值。你已经为根类建立了指定初始化方法，现在是时候为子类建立一个了。

让我们在 "为子类添加属性 "一节中建立方案1：添加一个指定初始化方法，调用或覆盖超类 `RocketComponent` 的指定初始化方法。

你的第一个冲动可能是像这样写指定初始化方法：

```swift
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  self.model = model
  self.serialNumber = serialNumber
  self.reusable = reusable
  self.encasingMaterial = encasingMaterial
}
```

这看起来像你在本教程中建立的所有指定初始化方法。然而，这段代码不会被编译，因为 `Tank` 是一个子类。**在 Swift 中，子类只能初始化它引入的属性。子类不能初始化超类引入的属性**。正因为如此，子类的指定初始化方法必须委托给超类的指定初始化方法来获得所有超类属性的初始化。

在 `Tank` 中添加以下指定初始化方法：

```swift
// Init #2a - Designated
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  self.encasingMaterial = encasingMaterial
  super.init(model: model, serialNumber: serialNumber, reusable: reusable)
}
```

代码又开始成功编译了! 这个指定初始化方法有两个重要部分。

1. 初始化该类自己的属性。在本例中，这只是 `encasingMaterial`。
2. 将其余的工作委托给超类指定初始化方法，`init(model:serialNumber:reusable:)`。



## 类层级的两阶段初始化

回想一下，两阶段初始化是为了确保委托初始化方法在设置属性、委托和使用新实例方面以正确的顺序进行工作。到目前为止，你已经看到了结构体的委托初始化方法和类的便捷初始化方法的情况，它们在本质上是一样的。

还有一种委托初始化方法：子类指定初始化方法。你在上一节中建立了一个这样的初始化器。这方面的规则超级简单：==在调用委托初始化方法之前，你只能设置子类引入的属性，而且在第二阶段之前，你不能使用新的实例==。

为了看看编译器是如何执行两阶段初始化的，将 `Tank` 的初始化器#2a更新如下：

```swift
// Init #2a - Designated
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  super.init(model: model, serialNumber: serialNumber, reusable: reusable)
  self.encasingMaterial = encasingMaterial
}
```

![](https://koenig-media.raywenderlich.com/uploads/2015/12/SwiftInitClassError4.png)

编译失败是因为指定初始化方法没有初始化该子类在第一阶段引入的所有存储属性。



像这样更新同一初始化器：

```swift
// Init #2a - Designated
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  self.encasingMaterial = encasingMaterial
  self.model = model + "-X"
  super.init(model: model, serialNumber: serialNumber, reusable: reusable)
}
```

编译器会抱怨说 `model` 不是变量。实际上不要这样做，但如果你要把这个属性从常量改为变量，那么你就会看到这个编译器错误：

![](https://koenig-media.raywenderlich.com/uploads/2015/12/SwiftInitClassError5.png)

这就出错了，因为==子类的指定初始化方法不允许初始化任何不是由同一子类引入的属性==。这段代码试图初始化 `model` 属性，它是由 `RocketComponent` 引入的，而不是 `Tank`。

你现在应该能够很好地识别和修复这个编译器错误。

为了准备下一章节，将 Tank 的 2a 初始化器更新为本节之前一开始编写的样子：

```swift
// Init #2a - Designated
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  self.encasingMaterial = encasingMaterial
  super.init(model: model, serialNumber: serialNumber, reusable: reusable)
}
```



### 取消继承初始化方法

现在你已经回到了 `Tank` 的编译版本，取消之前的 `fuelTank` 和 `liquidOxygenTank` 实例的注释：

```swift
let fuelTank = Tank(model: "Athena", serialNumber:"003", reusable: true)
let liquidOxygenTank = Tank(identifier: "LOX-012", reusable: true)
```

`fuelTank` 和 `liquidOxygenTank` 不再实例化成功，所以这段代码导致了一个编译器错误。回顾一下，在给 `Tank` 添加指定初始化方法之前，这段代码编译和运行都很好。发生了什么事？

两个实例化方法都试图使用属于 `RocketComponent` 的初始化器来创建一个 `Tank` 实例，而 `RocketComponent` 是 `Tank` 的超类。问题是，`RocketComponent` 的初始化器只知道如何初始化 `RocketComponent` 所引入的属性。这些初始化器对子类引入的属性没有预见性。因此，`RocketComponent` 的初始化器不能完全初始化 `Tank`，尽管 `Tank` 是一个子类。

这段代码在 Objective-C 中可以正常工作，因为 `Tank` 的 `encasingMaterial` 属性在调用任何初始化器之前会被运行时初始化为 `nil`。所以在 Objective-C 中，`Tank` 继承 `RocketComponent` 的所有初始化器并无大碍，因为它们能够完全初始化 `Tank`。

尽管在 Objective-C 中允许自动继承初始化器，但这显然是不理想的，因为 `Tank` 可能认为 `encasingMaterial` 总是被设置为一个真实的字符串值。虽然这可能不会导致崩溃，但它可能会造成意想不到的副作用。Swift 不允许这种情况，因为这不安全，所以==一旦你为子类创建了一个指定初始化方法，子类就会停止继承（父类）所有的初始化方法，包括指定和便捷初始化方法==。

为了准备下一节，再次注释 `fuelTank` 和 `liquidOxygenTank` 的实例。

```swift
//let fuelTank = Tank(model: "Athena", serialNumber:"003", reusable: true)
//let liquidOxygenTank = Tank(identifier: "LOX-012", reusable: true)
```



### 初始化方法的调用流

简而言之：便捷初始化方法委托给其他便捷初始化方法，直到委托给指定初始化方法。

![](https://koenig-media.raywenderlich.com/uploads/2015/12/ClassInitDelegationUp.png)

子类中的指定初始化方法必须委托给来自直接继承的父类的指定初始化方法。

![](https://koenig-media.raywenderlich.com/uploads/2015/12/ClassInitDelegationAcross.png)

请记住，子类中的指定初始化方法不能委托给父类的便捷初始化方法：

![](https://koenig-media.raywenderlich.com/uploads/2015/12/ConvenienceToConvenienceCannot.png)

另外，子类中的便捷初始化方法不能委托给父类的便捷初始化方法。便捷初始化方法只能在它们被定义的类中进行委托：

![](https://koenig-media.raywenderlich.com/uploads/2015/12/DesignatedToConvenienceCannot.png)


在一个类的层次结构中，每个类要么：

* 没有初始化器；
* 一个或多个指定初始化方法；
* 一个或多个便捷初始化方法和一个或多个指定初始化方法；

请考虑以下类图：

![](https://koenig-media.raywenderlich.com/uploads/2015/12/ExampleClassHierarchy.png)

假设你想用 D 的指定初始化方法来初始化 D 类的一个实例。初始化将调用 C 的指定初始化方法向上输送到 A 的指定初始化方法。

或者说你想用 E 的第二个便捷初始化方法来初始化 E 的一个实例。初始化将移到 E 的第一个便捷初始化方法，然后移到 E 的指定初始化方法。在这一点上，初始化将调用 D 和 C 的指定初始化方法，最后到 A 的指定初始化方法。

如果有的话，类的初始化开始通过便捷初始化方法，然后进入指定初始化方法，最后通过每个父类的指定初始化方法。



### 向上委托的调用流

将以下 `LiquidTank` 子类添加到你的游乐场的末尾：

```swift
class LiquidTank: Tank {
    let liquidType: String
    
    // Init #3a - Designated
    init(model: String, serialNumber: String, reusable: Bool,
         encasingMaterial: String, liquidType: String) {
        self.liquidType = liquidType
        super.init(model: model, serialNumber: serialNumber, reusable: reusable,
                   encasingMaterial: encasingMaterial)
    }
}
```

你将使用这个类的调用流追踪初始化方法的执行。它有标准的子类初始化器：设置自己的属性，然后调用 `super` 上的初始化器。

给`LiquidTank`添加以下两个便捷初始化方法：

```swift
// Init #3b - Convenience
convenience init(model: String, serialNumberInt: Int, reusable: Bool,
                 encasingMaterial: String, liquidType: String) {
    let serialNumber = String(serialNumberInt)
    self.init(model: model, serialNumber: serialNumber, reusable: reusable,
              encasingMaterial: encasingMaterial, liquidType: liquidType)
}

// Init #3c - Convenience
convenience init(model: String, serialNumberInt: Int, reusable: Int,
                 encasingMaterial: String, liquidType: String) {
    let reusable = reusable > 0
    self.init(model: model, serialNumberInt: serialNumberInt, reusable: reusable,
              encasingMaterial: encasingMaterial, liquidType: liquidType)
}
```

现在使用`LiquidTank`的便捷初始化方法#3c来实例化一个新的火箭推进剂燃料箱：

```swift
let rp1Tank = LiquidTank(model: "Hermes", serialNumberInt: 5, reusable: 1, encasingMaterial: "Aluminum", liquidType: "LOX")
```

这种初始化遵循以下流程，通过初始化器的漏斗：3c > 3b > 3a > 2a > 1a。它首先穿过 `LiquidTank` 的两个便捷初始化方法；然后继续委托给 `LiquidTank` 的指定初始化方法。从那里开始，初始化被委托给所有的父类、`Tank`和`RocketComponent`。这也是利用了你在本教程第一部分学到的相同的设计决定：两个初始化器可以使用相同的参数名称集，运行时足够聪明，可以根据每个参数的类型找出要使用的参数。在这种情况下，初始化器被调用时用一个整数来表示可重复使用的次数，这意味着编译器会选择初始化器#3c。



### 重新继承初始化方法（重写父类指定初始化方法）

请记住，一旦子类定义了它们自己的指定初始化方法，它们就不再继承初始化器。如果你想使用父类的初始化器来初始化一个子类，该怎么办？==在子类中重写父类的指定初始化方法==。

在 `Tank` 中添加以下指定初始化方法：

```swift
// 重写父类的指定初始化方法，内部调用父类的指定初始化方法
// Init #2b - Designated
override init(model: String, serialNumber: String, reusable: Bool) {
    self.encasingMaterial = "Aluminum"
    super.init(model: model, serialNumber: serialNumber, reusable: reusable)
}
```

这使得 `RocketComponent` 的一个初始化方法可用于实例化 `Tank` 实例。当你想使用一个父类的非继承的指定初始化方法来实例化一个子类时，你可以像上面的例子一样覆写它。

现在给 `LiquidTank` 添加以下指定的初始化方法：

```swift
// 重写父类的指定初始化方法，内部调用父类的指定初始化方法
// Init #3d - Designated
override init(model: String, serialNumber: String, reusable: Bool) {
    self.liquidType = "LOX"
    super.init(model: model, serialNumber: serialNumber,
               reusable: reusable, encasingMaterial: "Aluminum")
}

// 重写父类的指定初始化方法，内部调用父类的指定初始化方法
// Init #3e - Designated
override init(model: String, serialNumber: String, reusable: Bool,
              encasingMaterial: String) {
    self.liquidType = "LOX"
    super.init(model: model, serialNumber: serialNumber, reusable:
                reusable, encasingMaterial: encasingMaterial)
}
```

这使得 `RocketComponent` 和 `Tank` 的指定初始化方法都可以用来实例化 `LiquidTank` 实例。
现在，这些指定初始化方法又开始工作了，取消之前的`fuelTank`和`liquidOxygenTank`实例的注释：

```swift
// 如果子类自己实现了指定初始化方法，系统就不会默认继承父类的指定初始化方法和便捷初始化方法。
// 这时，如果子类还想继续使用父类的指定初始化方法，就必须在子类中重写父类的指定初始化方法
let fuelTank = Tank(model: "Athena", serialNumber:"003", reusable: true)
// 当你把父类所有的指定初始化方法都重写后，你也就自动继承了父类所有的便捷初始化方法了。
let liquidOxygenTank = Tank(identifier: "LOX-012", reusable: true)
```

第一行调用重写的 `RocketComponent` 的指定初始化方法来实例化一个 `Tank`。但是看看第二行：它是用 `RocketComponent` 的便捷初始化方法来实例化 `Tank` 的！你并没有覆写它。这就是你如何让子类继承其父类的便捷初始化方法。

覆写一个父类的所有指定初始化方法，以便重新继承超类的便捷初始化方法。

为了更进一步，使用 `RocketComponent` 的便捷初始化方法在你的Playground底部实例化一个 `LiquidTank`：

```swift
// LiquidTank 重写了父类所有的指定初始化方法，它也就自动获得了父类的所有便捷初始化方法。
let loxTank = LiquidTank(identifier: "LOX-1", reusable: true)
```

因为 `LiquidTank` 覆写了 `Tank` 的所有指定初始化方法。这意味着 `LiquidTank` 也就自动继承了 `RocketComponents` 的所有便捷初始化方法。



### 使用便捷初始化方法来重写

指定初始化方法应该对所有的存储属性进行非常基本的赋值，并且通常为每个属性设置一个初始值。任何时候你需要一个初始化方法，通过减少参数和/或对属性值做一些预处理来简化初始化，你应该把它变成一个便捷初始化方法。这就是为什么它们被称为便捷初始化方法，毕竟：它们使初始化比使用指定初始化方法更方便。

在上一节中，你用 `Tank` 中的指定初始化方法重写了 `RocketComponent` 的指定初始化方法。想想这个覆写在做什么：它覆盖了`RocketComponent`的指定初始化方法，使初始化 `Tank` 实例更加方便。初始化更方便，因为这个覆写不需要设置 `encasingMaterial` 的值。

当覆写一个父类的指定初始化方法时，你可以把它变成一个指定初始化方法或一个便捷初始化方法。要把 `LiquidTank` 中被覆写的初始化方法变成便捷初始化方法，把初始化器#3d和#3e的代码替换为：

```swift
// 重写父类的指定初始化方法，并将其设置为便捷初始化方法，内部调用本类的指定初始化方法
// Init #3d - Convenience
convenience override init(model: String, serialNumber: String, reusable: Bool) {
    self.init(model: model, serialNumber: serialNumber, reusable: reusable,
              encasingMaterial: "Aluminum", liquidType: "LOX")
}

// 重写父类的指定初始化方法，并将其设置为便捷初始化方法，内部调用本类的指定初始化方法
// Init #3e - Convenience
convenience override init(model: String, serialNumber: String, reusable: Bool,
                          encasingMaterial: String) {
    self.init(model: model, serialNumber: serialNumber,
              reusable: reusable, encasingMaterial: encasingMaterial, liquidType: "LOX")
}
```

用子类的指定初始化方法来覆写父类指定初始化方法有一个坏处。如果子类的指定初始化方法有逻辑，你就不能把一个便捷初始化方法委托给它。相反，你可以用便捷初始化方法覆写父类的指定初始化方法；这允许你委托给子类的指定初始化方法逻辑。接下来你将尝试这个：


## 继承层级的失败和抛出异常策略

给 `LiquidTank` 添加以下便捷初始化方法：

```swift
// 可失败的便捷初始化方法，调用自身的指定初始化方法
// Init #3f - Convenience
convenience init?(identifier: String, reusable: Bool, encasingMaterial: String,
                  liquidType: String) {
    let identifierComponents = identifier.components(separatedBy: "-")
    guard identifierComponents.count == 2 else {
        return nil
    }

    self.init(model: identifierComponents[0], serialNumber: identifierComponents[1],
              reusable: reusable, encasingMaterial: encasingMaterial, liquidType: liquidType)
}
```

这个初始化方法看起来与 `RocketComponent` 的便捷初始化方法几乎相同。

使用这个新的便捷初始化方法来实例化一个新的 `LiquidTank`：

```swift
let athenaFuelTank = LiquidTank(identifier: "Athena-9", reusable: true,
  encasingMaterial: "Aluminum", liquidType: "RP-1")
```

很成功，但 `LiquidTank` 和 `RocketComponent` 的初始化方法中存在重复的代码。重复的代码会带来错误的可能性，所以这是不可取的。

![](https://koenig-media.raywenderlich.com/uploads/2016/01/tiger-beetle-562041_640.jpg)

为了遵循 DRY（Don't Repeat Yourself）原则，给 `RocketComponent` 添加以下类方法：

```swift
static func decompose(identifier: String) -> (model: String, serialNumber: String)? {
    let identifierComponents = identifier.components(separatedBy: "-")
    guard identifierComponents.count == 2 else {
        return nil
    }

    return (model: identifierComponents[0], serialNumber: identifierComponents[1])
}
```

这段代码重构了初始化方法中的重复代码，并将其放在两个初始化方法都可访问的地方。

> 注意：类方法被标记为 `static` 关键字。它们是在类型本身而不是在实例上调用的。你可能以前没有这样想过，但是在类的实现中调用一个方法实际上是在调用一个实例方法。例如，`self.doSomething()`。而这里，你需要使用一个类方法，因为 `decompose(identifier:)` 作为一个实例方法，要到第二阶段，即所有属性都被初始化之后才能使用。你在使用 `decompose(identifier:)` 作为一个工具来计算初始化的属性值。我建议在你自己的类的初始化方法中玩玩调用方法，以掌握这个概念。



现在更新 `RocketComponent` 和 `LiquidTank` 的两个便捷初始化方法，以调用新的静态方法：

```swift
// 可失败的指定初始化方法
// Init #1c - Convenience
convenience init?(identifier: String, reusable: Bool) {
    // 重复代码使用类方法优化
    guard let (model, serialNumber) = RocketComponent.decompose(identifier: identifier) else {
        return nil
    }

    self.init(model: model, serialNumber: serialNumber, reusable: reusable)
}
```

和：

```swift
// 可失败的便捷初始化方法，调用自身的指定初始化方法
// Init #3f - Convenience
convenience init?(identifier: String, reusable: Bool, encasingMaterial: String,
                  liquidType: String) {
    // 重复代码使用类方法优化
    guard let (model, serialNumber) = RocketComponent.decompose(identifier: identifier) else {
        return nil
    }

    self.init(model: model, serialNumber: serialNumber, reusable: reusable, encasingMaterial: encasingMaterial, liquidType: liquidType)
}
```

这是利用可失败便捷初始化方法的一个很好的示例，同时消除了任何冗余。你仍然可以让初始化方法在需要时返回 `nil`，而且你已经将普通代码重构到类方法中，以避免重复。



## 何去何从？

呼，要讲的东西太多了! 在这个两段式的教程中，你已经学到了很多关于初始化的知识......而且多亏了你，第一个前往火星的载人任务已经准备好起飞了。伟大的工作!

如果你想比较代码或只是想看看最终的代码，可以在这里下载第二部分的完整 Playground。

要回顾你在这里学到的东西，并阅读所有的初始化规则和编译器安全检查，请阅读苹果的 [Swift编程语言](https://swiftgg.gitbook.io/swift/)。

要想获得更多的练习，并在更广泛的结构和类的背景下看到初始化，请查看我们的书《Swift Apprentice》。我们也有一个很好的关于 [Swift 中面向对象设计](https://www.raywenderlich.com/2123-intro-to-object-oriented-design-in-swift-part-1-2) 的教程，其中涉及到初始化。

现在 Swift 是开源的，你可以在 [Swift GitHub repo](https://github.com/apple/swift) 的 docs 文件夹下找到很多与初始化有关的有趣文档。通过阅读这些文档，你可以了解到 Swift 团队对初始化功能和安全检查的理由。关注 Swift-evolution 和 Swift-evolution-announce 邮件列表，可以了解到即将到来的内容。

我们希望你喜欢这个教程，如果你有任何问题或意见，请加入下面的论坛讨论!
