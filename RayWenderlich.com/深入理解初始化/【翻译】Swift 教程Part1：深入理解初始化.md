> 原文：[Swift Tutorial: Initialization In Depth, Part 1/2](https://www.raywenderlich.com/1220-swift-tutorial-initialization-in-depth-part-1-2)


在这个关于深入探讨初始化的两部分教程中，通过了解你的实例是如何被初始化的，将你的 Swift 技能提高到一个新的水平!

有些东西天生就很厉害：火箭、火星任务、Swift 的初始化。本教程将这三者结合在一起，让你了解到初始化的威力。
Swift 中的初始化是关于当你命名并创建一个新的实例类型时会发生什么：

```swift
let number = Float()
```

初始化是管理命名类型的存储属性的初始值的时候：类、结构和枚举。由于 Swift 内置的安全特性，初始化可能很棘手。有很多规则，其中一些并不明显。

按照本教程的两部分内容，你将学会为你的 Swift 类型设计初始化器的内涵和外延。在第一部分，你将从包括结构初始化在内的基础知识开始，在第二部分，你将继续学习类的初始化。

在开始之前，你应该熟悉 Swift 中初始化的基础知识，并对一些概念感到满意，如可选类型，抛出和处理错误，以及声明默认的存储属性值。此外，请确保你安装了Xcode 8.0或更高版本。

如果你需要复习一下基础知识，或者你刚开始学习 Swift，可以看看我们的书《Swift 学徒》或者我们的许多 [Swift 入门教程](https://www.raywenderlich.com/ios)。



## 开始

让我们设定一个场景：这是你在 NASA 担任发射软件工程师的第一天（加油！）。你的任务是设计数据模型，该模型将驱动首次火星载人任务的发射序列，即 Mars Unum。当然，你做的第一件事就是说服团队使用 Swift。然后......

打开 Xcode，创建一个名为 BlastOff 的新Playground。你可以选择任何平台，因为本教程中的代码是不分平台的，只依赖于Foundation。

在整个教程中，请记住这条黄金规则：在一个实例完全初始化之前，你不能使用它。对一个实例的"使用"包括访问属性、设置属性和调用方法。除非另有说明，本章节的所有内容都特别适用于结构。


## 基于默认初始化器

为了开始对发射序列进行建模，在你的Playground上声明一个名为 `RocketConfiguration` 的新结构：

```swift
struct RocketConfiguration {

}
```

在 `RocketConfiguration` 定义的结尾大括号下面，初始化一个名为 `athena9Heavy` 的常量实例。

```swift
let athena9Heavy = RocketConfiguration()
```

这里使用了一个**默认初始化器（default initializer）**来实例化 `athena9Heavy`。在默认初始化器中，类型的名称后面是空括号。当你的类型没有任何存储属性，或者类型的所有存储属性都有默认值时，你可以使用默认初始化器。这对结构和类都是如此。

在结构体定义中添加以下三个存储属性：

```swift
let name: String = "Athena 9 Heavy"
let numberOfFirstStageCores: Int = 3
let numberOfSecondStageCores: Int = 1
```

注意到默认的初始化器仍在工作。代码继续运行，因为所有存储的属性都有默认值。这意味着默认初始化器并没有太多的工作要做，因为你已经提供了默认值。

那么可选类型呢？在结构定义中添加一个名为 `numberOfStageReuseLandingLegs` 的可变存储属性：

```swift
var numberOfStageReuseLandingLegs: Int?
```

在我们的NASA方案中，一些火箭是可重复使用的，而另一些则不是。这就是为什么 `numberOfStageReuseLandingLegs` 是一个可选的 `Int`。默认初始化器继续正常运行，因为可选的存储属性变量在默认情况下被初始化为 `nil`。然而，对于常量来说，情况就不是这样了。

把`numberOfStageReuseLandingLegs`从一个变量类型改为常量类型：

```swift
// 如果结构体的存储属性是可选常量，且没有赋初始值，编译器报错
let numberOfStageReuseLandingLegs: Int?
```

注意Playground如何报告一个编译器错误：

![](https://koenig-media.raywenderlich.com/uploads/2015/11/SwiftInitInDepth-0.png)

你不会经常遇到这种情况，因为很少需要可选常量类型。为了解决编译器的错误，给 `numberOfStageReuseLandingLegs` 指定一个默认值为 `nil`。

```swift
let numberOfStageReuseLandingLegs: Int? = nil
```

万岁! 编译器又高兴了，初始化也成功了。通过这样的设置，`numberOfStageReuseLandingLegs`永远不会有一个非零的值。你不能在初始化后改变它，因为它被声明为一个常量。



## 基于成员初始化器

火箭通常是由几个级组成的，这就是接下来要建模的内容。在 Playground 的底部声明一个名为 `RocketStageConfiguration` 的新结构：

```swift
struct RocketStageConfiguration {
    let propellantMass: Double
    let liquidOxygenMass: Double
    let nominalBurnTime: Int
}
```

这一次，你有三个存储属性 `propellantMass`、`liquidOxygenMass`和`nominalBurnTime`，没有默认值。
为火箭的第一级创建一个`RocketStageConfiguration`的实例：

```swift
let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1, liquidOxygenMass: 276.0, nominalBurnTime: 180)
```

`RocketStageConfiguration` 的存储属性都没有默认值。另外，`RocketStageConfiguration`也没有实现初始化器。为什么没有出现编译器错误？因为 Swift 结构体（而且只有结构体）会自动生成一个**成员初始化器（memberwise initializer）**。这意味着你可以为所有没有默认值的存储属性得到一个现成的初始化器。这真是太方便了，但也有几个问题。

想象一下，当你提交这个代码片段进行审查时，你的开发团队领导告诉你所有的属性应该按字母顺序排列。
更新 `RocketStageConfiguration` 以重新排列存储的属性：

```swift
struct RocketStageConfiguration {
  let liquidOxygenMass: Double
  let nominalBurnTime: Int
  let propellantMass: Double
}
```

![](https://koenig-media.raywenderlich.com/uploads/2015/11/SwiftInitInDepth-3.png)

发生了什么？`stageOneConfiguaration` 初始化器的调用不再有效，因为自动成员初始化器参数列表的顺序反映了存储的属性列表的顺序。要小心，因为当重新排列结构体中属性的顺序时，你可能会破坏实例初始化。值得庆幸的是，编译器应该能捕捉到这个错误，但这绝对是一个需要注意的问题。

撤消对存储属性的重新排序操作，使 Playground 重新编译和运行：

```swift
struct RocketStageConfiguration {
    let propellantMass: Double
    let liquidOxygenMass: Double
    let nominalBurnTime: Int
}
```

你所有的火箭都会燃烧180秒，所以每次实例化阶段配置时传递名义燃烧时间是没有用的。将`nominalBurnTime`的默认属性值设置为`180`：

```swift
let nominalBurnTime: Int = 180
```

现在又出现了一个编译器错误：

![](https://koenig-media.raywenderlich.com/uploads/2015/11/SwiftInitInDepth-2.png)

编译失败是因为成员初始化器只为没有默认值的存储属性提供参数。在这种情况下，成员式初始化器只接受推进剂质量和液氧质量，因为已经有了燃烧时间的默认值。

删除`nominalBurnTime`的默认值，这样就不会出现编译器错误。

```swift
let nominalBurnTime: Int
```

接下来，给结构定义添加一个自定义初始化器，为燃烧时间提供一个默认值：

```swift
init(propellantMass: Double, liquidOxygenMass: Double) {
    self.propellantMass = propellantMass
    self.liquidOxygenMass = liquidOxygenMass
    self.nominalBurnTime = 180
}
```

请注意，同样的编译器错误又出现在 `stageOneConfiguration` 上。

![](https://koenig-media.raywenderlich.com/uploads/2015/11/SwiftInitInDepth-2.png)

等等，这不是应该工作吗？你所做的只是提供了一个替代的初始化器，但是原始的 `stageOneConfiguration` 初始化应该工作，因为它使用的是自动的成员初始化器。这就是问题所在：只有当一个结构没有定义任何初始化器时，你才能得到一个成员初始化器。一旦你定义了一个初始化器，你就失去了自动成员初始化器。

换句话说，Swift 会在开始时帮助你。但是一旦你添加了你自己的初始化器，它就会认为你想让它离开这里。

从`stageOneConfiguration`的初始化中移除`nominalBurnTime`参数。

```swift
let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1, liquidOxygenMass: 276.0)
```

一切又都好了! :]

但是如果你仍然需要自动生成的成员初始化器呢？你当然可以写相应的初始化器，但那是一个很大的工作。相反，在实例化之前将自定义初始化器移到扩展中。

现在你的结构将分为两部分：主定义，以及带有双参数初始化器的扩展：

```swift
struct RocketStageConfiguration {
    let propellantMass: Double
    let liquidOxygenMass: Double
    let nominalBurnTime: Int
}

// 如果你自定义了一个初始化器，系统就不再提供默认的成员初始化器了
// 但如果你把自定义初始化器写在 extension 里面，鱼和熊掌兼得
extension RocketStageConfiguration {
    init(propellantMass: Double, liquidOxygenMass: Double) {
        self.propellantMass = propellantMass
        self.liquidOxygenMass = liquidOxygenMass
        self.nominalBurnTime = 180
    }
}
```

注意`stageOneConfiguration`如何继续用两个参数成功初始化。现在把`nominalBurnTime`参数重新添加到`stageOneConfiguration`的初始化中：

```swift
let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1,
  liquidOxygenMass: 276.0, nominalBurnTime: 180)
```

这也是可行的! 如果主结构定义不包括任何初始化器，Swift 仍会自动生成默认的成员初始化器。然后你可以通过扩展添加你的自定义初始化器，以获得两全其美的效果。

![](https://koenig-media.raywenderlich.com/uploads/2015/11/SwiftInit-r0.png)


## 实现自定义初始化器

天气在发射火箭中起着关键作用，所以你需要在数据模型中解决这个问题。声明一个名为 `Weather` 的新结构，如下所示：

```swift
struct Weather {
    let temperatureCelsius: Double
    let windSpeedKilometersPerHour: Double
}
```

该结构已经存储了温度（摄氏度）和风速（公里/小时）的属性。

为 `Weather` 实现一个自定义的初始化器，输入温度（华氏度）和风速（英里/小时）。在存储属性下面添加这段代码：

```swift
init(temperatureFahrenheit: Double, windSpeedMilesPerHour: Double) {
  self.temperatureCelsius = (temperatureFahrenheit - 32) / 1.8
  self.windSpeedKilometersPerHour = windSpeedMilesPerHour * 1.609344
}
```

定义一个自定义的初始化器与定义一个方法非常相似，因为初始化器的参数列表与方法的参数列表的行为完全相同。例如，你可以为任何一个初始化器参数定义一个默认参数值。

将初始化器的定义改为：

```swift
init(temperatureFahrenheit: Double = 72, windSpeedMilesPerHour: Double = 5) {
  self.temperatureCelsius = (temperatureFahrenheit - 32) / 1.8
  self.windSpeedKilometersPerHour = windSpeedMilesPerHour * 1.609344
}
```

现在，如果你调用没有参数的初始化器，你会得到一些合理的默认值。在你的Playground文件的最后，创建一个 `Weather`的实例并检查它的值：

```swift
let currentWeather = Weather()
currentWeather.temperatureCelsius
currentWeather.windSpeedKilometersPerHour
```

很酷，对吗？默认初始化器使用自定义初始化器提供的默认值。自定义初始化器的实现将这些值转换为公制等价物，并存储这些值。当你在Playground边栏检查存储属性值时，你会得到正确的摄氏度（22.2222）和每小时公里数（8.047）的值。

初始化器必须为每一个没有默认值的存储属性赋值，否则你会得到一个编译器错误。记住，可选变量的默认值是 `nil`。

接下来，改变`currentWeather`，使用你的自定义初始化器，并添加新的值：

```swift
let currentWeather = Weather(temperatureFahrenheit: 87, windSpeedMilesPerHour: 2)
currentWeather.temperatureCelsius
currentWeather.windSpeedKilometersPerHour
```

正如你所看到的，自定义值在初始化器中和默认值一样好用。Playground 侧边栏现在应该显示30.556度和3.219公里/小时。
这就是你如何实现和调用自定义初始化器。你的天气结构已经准备好为你向火星发射人类的任务做出贡献。干得好!

![](https://koenig-media.raywenderlich.com/uploads/2016/04/Mars_Hubble.jpg)



## 使用初始化器委托避免重复工作

现在是时候考虑火箭的制导问题了。火箭需要花哨的制导系统来保持它们完美的直线飞行。声明一个名为`GuidanceSensorStatus`的新结构，代码如下：

```swift
struct GuidanceSensorStatus {
    var currentZAngularVelocityRadiansPerMinute: Double
    let initialZAngularVelocityRadiansPerMinute: Double
    var needsCorrection: Bool

    init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Bool) {
        let radiansPerMinute = zAngularVelocityDegreesPerMinute * 0.01745329251994
        self.currentZAngularVelocityRadiansPerMinute = radiansPerMinute
        self.initialZAngularVelocityRadiansPerMinute = radiansPerMinute
        self.needsCorrection = needsCorrection
    }
}
```

该结构持有火箭在Z轴上的当前和初始角速度（火箭的旋转程度）。该结构还记录了火箭是否需要修正以保持在其目标轨迹上。

自定义初始化器持有重要的业务逻辑：如何将每分钟的度数转换为每分钟的弧度。初始化器还设置了角速度的初始值，以备参考。

当指导工程师出现的时候，你正在愉快地编码。他们告诉你，新版本的火箭会给你一个 `Int` 类型的 `needsCorrection`，而不是一个 `Bool`。工程师说，正整数应该被解释为真，而零和负应该被解释为假。你的团队还没有准备好改变代码的其他部分，因为这个改变是未来功能的一部分。那么，你怎样才能在保持结构定义不变的情况下适应指导工程师的要求呢？
不用担心——在第一个初始化器下面添加以下自定义初始化器：

```swift
init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Int) {
    let radiansPerMinute = zAngularVelocityDegreesPerMinute * 0.01745329251994
    self.currentZAngularVelocityRadiansPerMinute = radiansPerMinute
    self.initialZAngularVelocityRadiansPerMinute = radiansPerMinute
    self.needsCorrection = (needsCorrection > 0)
}
```

这个新的初始化器使用一个`Int`而不是`Bool`作为最终参数。然而，存储的`needsCorrection`属性仍然是`Bool`，你可以根据他们的规则正确设置。

不过在你写完这段代码后，内心的一些东西告诉你，一定有更好的方法。初始化器其他部分的代码有太多的重复了！而且，如果初始化器中有错误的话，就会影响到我们的工作。而且，如果在计算度数和弧度的转换中出现了错误，你将不得不在多个地方修复它--这是一个可以避免的错误。这就是初始化器授权的用武之地。

把你刚才写的初始化器替换成下面的内容：

```swift
init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Int) {
  self.init(zAngularVelocityDegreesPerMinute: zAngularVelocityDegreesPerMinute,
   needsCorrection: (needsCorrection > 0))
}
```

这个初始化器是一个**委托初始化器（delegating initializer）**，和它听起来一样，它将初始化委托给另一个初始化器。要进行委托，只需在`self`上调用任何其他初始化器。

当你想提供一个备用的初始化器参数列表，但又不想重复自定义初始化器中的逻辑时，初始化委托就很有用。而且，使用委托初始化器有助于减少你所要写的代码量。

为了测试初始化器，实例化一个名为`guideStatus`的变量：

```swift
let guidanceStatus = GuidanceSensorStatus(zAngularVelocityDegreesPerMinute: 2.2, needsCorrection: 0)
guidanceStatus.currentZAngularVelocityRadiansPerMinute // 0.038
guidanceStatus.needsCorrection // false
```

Playground应该编译并运行，你为`guidelinesStatus`属性检查的两个值将出现在侧边栏中。

还有一件事——你被要求提供另一个初始化器，将 `needsCorrection` 默认为 `false`。这应该很简单，只要创建一个新的委托初始化器，并在委托初始化之前设置里面的`needsCorrection`属性即可。试着在该结构中添加以下初始化器，注意它不会被编译：

```swift
init(zAngularVelocityDegreesPerMinute: Double) {
  self.needsCorrection = false
  self.init(zAngularVelocityDegreesPerMinute: zAngularVelocityDegreesPerMinute,
    needsCorrection: self.needsCorrection)
}
```

![](https://koenig-media.raywenderlich.com/uploads/2015/11/SwiftInitInDepth-5.png)

编译失败是因为委托初始化器实际上不能初始化任何属性。这是有原因的：你所委托的初始化器很可能覆盖你所设置的值，这是不安全的。委托的初始化器唯一能做的就是操作传递给另一个初始化器的值。
知道这一点后，删除新的初始化器，给主初始化器的`needsCorrection`参数一个默认值`false`。

```swift
init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Bool = false) {
    let radiansPerMinute = zAngularVelocityDegreesPerMinute * 0.01745329251994
    self.currentZAngularVelocityRadiansPerMinute = radiansPerMinute
    self.initialZAngularVelocityRadiansPerMinute = radiansPerMinute
    self.needsCorrection = needsCorrection
}
```

通过移除`needsCorrection`参数来更新`governanceStatus`的初始化：

```swift
let guidanceStatus = GuidanceSensorStatus(zAngularVelocityDegreesPerMinute: 2.2)
guidanceStatus.currentZAngularVelocityRadiansPerMinute // 0.038
guidanceStatus.needsCorrection // false
```

👍干得好! 现在你可以把那些 DRY（Don’t Repeat Yourself）原则付诸实践了。



## 介绍两阶段初始化

到目前为止，你的初始化程序中的代码一直在设置你的属性和调用其他初始化程序。这是初始化的第一阶段，但实际上，初始化一个 Swift 类型有两个阶段。

第一阶段从初始化开始，在所有存储的属性都被赋值后结束。剩下的初始化执行是第2阶段。你不能在第一阶段使用你正在初始化的实例，但你可以在第二阶段使用该实例。如果你有一个委托初始化器链，第1阶段跨越调用栈，直到非委托初始化器。第2阶段跨越了从调用栈返回的过程。


![](https://koenig-media.raywenderlich.com/uploads/2015/12/Struct2PhaseInit.png)



## 将两阶段初始化付诸实施

现在你了解了两阶段初始化，让我们把它应用到我们的场景中。每个火箭发动机都有一个燃烧室，燃料与氧化剂注入其中，产生可控的爆炸，推动火箭。设置这些参数是第一阶段的工作，为爆炸做准备。

实现下面的`CombustionChamberStatus`结构，看看Swift的两阶段初始化是如何进行的。请确保显示 Xcode 的 Debug 区域，以看到打印语句的输出：

```swift
struct CombustionChamberStatus {
    var temperatureKelvin: Double
    var pressureKiloPascals: Double

    init(temperatureKelvin: Double, pressureKiloPascals: Double) {
        print("Phase 1 init")
        self.temperatureKelvin = temperatureKelvin
        self.pressureKiloPascals = pressureKiloPascals
        print("CombustionChamberStatus fully initialized")
        print("Phase 2 init")
    }

    init(temperatureCelsius: Double, pressureAtmospheric: Double) {
        print("Phase 1 delegating init")
        let temperatureKelvin = temperatureCelsius + 273.15
        let pressureKiloPascals = pressureAtmospheric * 101.325
        self.init(temperatureKelvin: temperatureKelvin, pressureKiloPascals: pressureKiloPascals)
        print("Phase 2 delegating init")
    }
}

CombustionChamberStatus(temperatureCelsius: 32, pressureAtmospheric: 0.96)
```

你应该在调试区看到以下输出：

```swift
Phase 1 delegating init
Phase 1 init
CombustionChamberStatus fully initialized
Phase 2 init
Phase 2 delegating init
```

正如你所看到的，第一阶段从调用委托初始化器 `init(temperatureCelsius:pressureAtmospheric:)` 开始，在此期间不能使用 `self`。阶段1在 `self.pressureKiloPascals` 在非委托初始化器中被赋值后结束。每个初始化器在每个阶段都扮演着一个角色。

编译器不是超级疯狂的聪明吗？它知道如何执行所有这些规则。起初，这些规则可能看起来很麻烦，但请记住，它们提供了大量的安全性。



## 如果事情出了差错怎么办？

你已经被告知，发射序列将是完全自主的，并且序列将执行大量的测试，以确保所有的系统都能在发射时正常运行。如果一个无效的值被传入初始化器，发射系统应该能够知道并作出反应。

在 Swift 中，有两种方法来处理初始化失败：使用可失败的初始化器，以及从初始化器中抛出错误。初始化失败的原因有很多，包括无效的输入、缺失的系统资源（如文件）以及可能的网络故障。



### 使用可失败的初始化器

普通初始化器和可失败初始化器之间有两个区别。一个是可失败初始化器返回可选类型，另一个是可失败初始化器可以返回`nil`来表示初始化失败。这可能非常有用--让我们把它应用于我们的数据模型中的火箭罐。

每个火箭级都有两个大罐子；一个装燃料，而另一个装氧化剂。为了跟踪每个油箱，实现一个名为`TankStatus`的新结构，如下所示：

```swift
struct TankStatus {
    var currentVolume: Double
    var currentLiquidType: String?

    init(currentVolume: Double, currentLiquidType: String?) {
        self.currentVolume = currentVolume
        self.currentLiquidType = currentLiquidType
    }
}

let tankStatus = TankStatus(currentVolume: 0.0, currentLiquidType: nil)
```

这段代码没有什么问题，只是它不承认失败。如果你传入一个负的体积，会发生什么？如果你传入一个正的体积值但没有液体类型呢？这些都是失败的情况。你如何使用可失败的初始化器来模拟这些情况？

首先，将`TankStatus`的初始化器改为可失败初始化器，在`init`上加一个 `?`

```swift
init?(currentVolume: Double, currentLiquidType: String?) {
```

选择点击`tankStatus`，注意初始化器现在如何返回一个可选的`TankStatus`。

更新`tankStatus`的实例化，使之与以下内容一致：

```swift
if let tankStatus = TankStatus(currentVolume: 0.0, currentLiquidType: nil) {
    print("Nice, tank status created.") // Printed!
} else {
    print("Oh no, an initialization failure occurred.")
}
```

实例化逻辑通过评估返回的`optional`类型是否包含一个值来检查是否失败。

当然，还缺少一些东西：初始化器实际上还没有检查出无效的值。把可失败的初始化器更新为以下内容：

```swift
init?(currentVolume: Double, currentLiquidType: String?) {
    if currentVolume < 0 {
        return nil
    }
    if currentVolume > 0 && currentLiquidType == nil {
        return nil
    }
    self.currentVolume = currentVolume
    self.currentLiquidType = currentLiquidType
}
```

一旦检测到无效的输入，可失败初始化器就会返回`nil`。在一个结构的可失败初始化器中，你可以在任何时候返回`nil`。而类的可失败初始化器则不然，你将在本教程的第二部分看到。

要看到实例化失败，请在`tankStatus`的实例化中传递一个无效的值：

```swift
if let tankStatus = TankStatus(currentVolume: -10.0, currentLiquidType: nil) {
```

注意Playground是如何打印的："Oh no, an initialization failure occurred."。因为初始化失败了，失败的初始化器返回了一个`nil`值，`if let`语句执行了`else`子句。



### 从初始化器中抛出错误

当返回`nil`是一种选择时，可失败的初始化器是很好的。对于更严重的错误，处理失败的另一种方式是从初始化器中抛出错误。

你还有最后一个结构需要实现：一个代表每个宇航员的结构。从写下面的代码开始：

```swift
// 宇航员
struct Astronaut {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
```

管理员告诉你一个宇航员应该有一个非空的`String`作为他或她的名字属性，并且应该有一个从18到70的年龄。
为了表示可能的错误，在`Astronaut`的实现之前添加以下错误枚举：

```swift
enum InvalidAstronautDataError: Error {
    case EmptyName
    case InvalidAge
}
```

这里的枚举案例涵盖了你在初始化一个新的`Astronaut`实例时可能遇到的问题。
接下来，用下面的实现替换`Astronaut`的初始化器：

```swift
init(name: String, age: Int) throws {
    if name.isEmpty {
        throw InvalidAstronautDataError.EmptyName
    }
    if age < 18 || age > 70 {
        throw InvalidAstronautDataError.InvalidAge
    }
    self.name = name
    self.age = age
}
```

请注意，初始化器现在被标记为 `throws`，让调用者知道会有错误。

如果检测到一个无效的输入值--要么是一个空字符串的名字，要么是一个超出可接受范围的年龄--初始化器现在将抛出适当的错误。

通过实例化一个新的宇航员来试试这个：

```swift
let johnny = try? Astronaut(name: "Johnny Cosmoseed", age: 42)
```

这正是你处理任何旧的抛出方法或函数的方式。抛出初始化器的行为就像抛出方法和函数一样。你也可以传播抛出式初始化器的错误，并用 `do-catch` 语句来处理错误。这里没有什么新东西。

要看到初始化器抛出一个错误，把`johnny`的年龄改为17岁：

```swift
let johnny = try? Astronaut(name: "Johnny Cosmoseed", age: 17)
```

当你调用一个抛出的初始化器时，你写下 `try` 关键字--或者`try?`或`try！`的变体--来确定它可以抛出一个错误。在本例中，你使用了`try?` 所以在错误情况下返回的值是`nil`。注意`johnny`的值是`nil`。遗憾的是，17岁对于太空飞行来说太年轻了。明年会有更好的运气，Johnny!

![](https://koenig-media.raywenderlich.com/uploads/2015/11/SwiftInit-r2-433x320.png)


### 可失败还是抛异常

使用抛出错误的初始化器并与 `try?` 语句结合使用看起来非常像使用可失败初始化器。那么你应该使用哪一种呢？

考虑使用抛出错误的初始化器。可失败初始化器只能表达一种二进制的失败/成功情况。通过使用抛出错误的初始化器，你不仅可以表示失败，还可以通过抛出特定的错误来表示原因。另一个好处是，调用代码可以传播初始化器抛出的任何错误。

不过，可失败初始化器要简单得多，因为你不需要定义错误类型，而且你可以避免所有那些额外的 `try?` 关键字。

为什么 Swift 会有可失败初始化器？因为 Swift 的第一个版本不包括 throw 函数，所以该语言需要一种方法来管理初始化失败的情况。

![](https://koenig-media.raywenderlich.com/uploads/2016/01/mars-surface-700x303.jpg)

## 何去何从？

哇--你不仅完成了将人类送上火星的一半任务，你现在还是一个 Swift 结构体的初始化大师了！你可以在这里下载第一部分的最终 Playground。

要了解所有关于Swift类初始化的知识，请继续阅读本教程的第二部分。

你可以在苹果《Swift编程语言指南》的[初始化章节](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID203)中找到更多关于初始化的信息。如果你有任何问题或意见，请在下面的论坛中加入讨论!





