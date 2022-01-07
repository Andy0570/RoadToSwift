> 原文：[Getting to Know Enum, Struct and Class Types in Swift](https://www.raywenderlich.com/7320-getting-to-know-enum-struct-and-class-types-in-swift)
>
> 了解 Swift 中枚举、结构和类的所有信息，包括值与引用语义、动态成员查找和协议一致性。



在只有 Objective-C 的时代，封装仅限于与类一起工作。然而，在使用 Swift 的现代 iOS 和 macOS 编程中，有三种选择：枚举、结构和类。

与协议结合起来，这些类型使得创造令人惊奇的东西成为可能。虽然它们有许多共同的能力，但这些类型也有重要的区别。

本教程的目的是：

* 给你一些使用枚举、结构和类的经验。
* 让你对何时使用它们有一些直观的认识。
* 让你了解每种类型的工作原理。

就先决条件而言，本教程假定你至少有 Swift 的基础知识和一些面向对象的编程经验。如果你想学习Swift的基础知识，请查阅我们的《Swift学徒》一书。



## 一切都与类型有关

Swift 的三大卖点是其安全性、速度和简单性。

安全性意味着你很难不小心写出胡乱运行的代码，破坏内存并产生难以发现的错误。Swift使你的工作更加安全，因为它试图通过在编译时向你展示问题，而不是在运行时将你晾在一边，从而使你的错误显而易见。
实现这一目标的关键是 Swift 的类型系统：

![](https://koenig-media.raywenderlich.com/uploads/2015/11/types.png)

Swift 类型很强大，尽管只有六种。这是正确的--与许多其他语言有几十种内置类型不同，Swift 只有六种。

这些类型包括四个命名类型：协议、枚举、结构和类。还有两种复合类型：元组和函数。

还有那些你可能认为是基本类型的东西，如 `Bool`、`Int`、`UInt`、`Float`等。然而，这些实际上是由命名类型建立起来的，并作为 Swift 标准库的一部分提供。

本教程的重点是所谓的**命名模型类型（named model types）**，其中包括枚举、结构和类。



### 使用可扩展矢量图的形状（SVG）

作为一个工作实例，你将建立一个安全、快速和简单的SVG形状（可扩展矢量图形）渲染框架。

SVG 是一种基于 XML 的 2D 图形的矢量图像格式。该规范自1999年以来一直是由W3C开发的一个开放标准。



## 开始

在 Xcode 中创建一个新的 Playground，从菜单中选择 File ▸ New ▸ Playground...来进行操作。接下来，选择平台为 macOS 并选择空白模板。接下来，将其命名为 "Shapes"，并选择一个位置来保存，然后点击 "创建 "来保存操场。完全清除该文件，然后输入以下内容。

```swift
import Foundation
```

你的目标将是呈现这样的东西：

```
<!DOCTYPE html>
<html>
  <body>
    <svg width='250' height='250'>
      <rect x='110.0' y='10.0' width='100.0' height='130.0' stroke='teal' 
        fill='aqua' stroke-width='5' />
      <circle cx='80.0' cy='160.0' r='60.0' stroke='red' fill='yellow' 
        stroke-width='5' />
    </svg>
  </body>
</html>

```

使用Webkit视图，它看起来像这样：

<img src="https://koenig-media.raywenderlich.com/uploads/2016/03/shapes.png" style="zoom:67%;" />



你需要一个颜色的表示方法。SVG 使用 CSS3 的颜色类型，可以指定为名称、RGB 或 HSL。欲了解更多细节，你可以阅读[完整的规范](https://www.w3.org/TR/css-color-3/)。

要在 SVG 中使用一种颜色，你要把它指定为绘图的一部分的属性--例如，`fill = 'gray'`。在Swift中，一个简单的方法是使用一个字符串--比如说，`let fill = "gray"`。

虽然使用 `String` 很容易，也能完成工作，但也有一些主要的缺点。

* 它很容易出错。任何不属于色谱的字符串在编译时都很好，但在运行时不会正确显示。例如，用 "e "拼成的 "grey "就不起作用。
* 自动完成不会帮助你找到有效的颜色名称。
* 当你把颜色作为一个参数传递时，可能并不总是很明显地看到这个字符串是一种颜色。

## 使用枚举类型

使用一个自定义类型可以解决这些问题。如果你是从 Cocoa Touch 来的，你可能会想到实现一个像UIColor 这样的封装类。虽然使用类的设计也可以，但 Swift 在如何定义你的模型方面给了你更多选择。

在不输入任何东西的情况下，先想一想如何将颜色实现为一个枚举。

你可以考虑这样来实现它：

```swift
enum ColorName {
  case black
  case silver
  case gray
  case white
  case maroon
  case red
  // etc.
}
```


以上的工作方式与一组C风格的枚举非常相似。然而，与C风格的枚举不同，Swift让你可以选择指定一种类型来表示每种情况。

明确指定 `backing store` 类型的枚举被称为 `RawRepresentable`，因为它们自动遵守 `RawRepresentable` 协议。

你可以将 `ColorName` 的类型指定为 `String`，并为每种情况赋值，像这样：

```swift
enum ColorName: String {
  case black = "black"
  case silver = "silver"
  case gray = "gray"
  case white = "white"
  case maroon = "maroon"
  case red = "red"
  // etc.
}
```

然而，Swift对有字符串表示的枚举做了一些特别的事情。如果你没有指定case等于什么，编译器会自动使字符串与case的名称相同。这意味着你只需要写出case的名字：

```swift
enum ColorName: String {
  case black
  case silver
  case gray
  case white
  case maroon
  case red
  // etc.
}
```

你可以进一步减少打字，用逗号分隔案例，只需使用一次关键词case。

在你的游乐场的末尾添加以下代码：

```swift
enum ColorName: String {
    case black, silver, gray, white, maroon, red, purple, fuchsia, green,
         lime, olive, yellow, navy, blue, teal, aqua
}
```

现在，你有了一个一流的自定义类型和随之而来的所有好处：

```swift
let fill = ColorName.grey // ERROR: Misspelled color names won't compile. Good!
let fill = ColorName.gray // Correct names autocomplete and compile. Yay!
```



### 可遍历枚举（CaseIterable）

Swift中的枚举非常适用于保存项目列表，比如我们举例的颜色列表。为了使枚举功能更加强大，Swift 4.2增加了一个名为`CaseIterable`的新协议，提供了一个所有符合条件的值的集合。

在编译时，Swift会自动创建一个`allCases`属性，它是你所有枚举案例的数组，按照你定义的顺序。
使用`CaseIterable`是非常简单的。你所要做的就是在`ColorName`的定义中声明一致性，如下所示：

```swift
enum ColorName: String, CaseIterable {
    case black, silver, gray, white, maroon, red, purple, fuchsia, green, 
      lime, olive, yellow, navy, blue, teal, aqua
}
```

然后你可以使用 `allCases` 属性，其类型为 `[ColorName]`。在你的游乐场的末尾添加以下内容：

```swift
for color in ColorName.allCases {
  print("I love the color \(color).")
}
```

在控制台中，你会看到打印了16行--`ColorName` 中每一种颜色都有一行。



### 关联值

`ColorName` 适用于命名的颜色，但你可能记得，CSS 颜色有几种表示方式：命名的、RGB的、HSL的等等。

Swift 中的枚举非常适用于对具有多种表示方法之一的事物进行建模，例如 CSS 颜色，而且每个枚举情况都可以与自己的数据配对使用。这些数据被称为关联值。

使用枚举来定义`CSSColor`，在你的 Playground 的末尾添加以下内容：

```swift
enum CSSColor {
    case named(name: ColorName)
    case rgb(red: UInt8, green: UInt8, blue: UInt8)
}
```

通过这个定义，你给了 `CSSColor` 模型两种状态中的一种。

它可以被命名，在这种情况下，相关数据是一个 `ColorName` 值。
它可以是 rgb，在这种情况下，相关数据是三个 UInt8（0-255）数字，分别代表红、绿和蓝。

注意，为了简洁起见，本例省略了rgba、hsl 和 hsla 的情况。



### 枚举类型的协议和方法

所有的模型都可以遵守协议
<img src="https://koenig-media.raywenderlich.com/uploads/2015/11/protocol.png" style="zoom:50%;" />

因为 CSSColor 有关联值，所以让它符合 `RawRepresentable` 比较困难（虽然不是不可能）。从新枚举中获得字符串表示的最简单方法是使其符合 `CustomStringConvertible`。

与Swift标准库互操作的关键是采用标准库协议。

在你的 Playground 的末尾添加以下 `CSSColor` 的扩展。

```swift
// 让枚举类型遵守协议
extension CSSColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .named(let colorName):
            return colorName.rawValue
        case .rgb(let red, let green, let blue):
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
}
```

在这个实现中，描述会自我切换，以确定底层模型是命名的还是 RGB 类型。在每种情况下，你都要将颜色转换为所需的字符串格式。命名的情况下只返回字符串名称，而 RGB 的情况下则返回所需格式的红、绿、蓝值。

要看这是如何工作的，在你的 Playground 上添加以下内容：

```swift
let color1 = CSSColor.named(name: .red)
let color2 = CSSColor.rgb(red: 0xAA, green: 0xAA, blue: 0xAA)

print("color1 = \(color1), color2 = \(color2)")
// prints color1 = red, color2 = #AAAAAA
```

一切都经过类型检查，并在编译时证明是正确的，不像你只用 `String` 值来表示颜色。



> 注意：虽然你可以回到以前的 `CSSColor` 定义中去修改，但你不必这样做。你已经使用了一个扩展来重新开放颜色类型，并采用了一个新的协议。
>
> 扩展风格很好，因为它使你定义的东西完全明确，以符合特定的协议。在`CustomStringConvertible`的例子中，你需要为 `description` 实现一个`getter` 方法。



### 枚举类型的初始化方法

就像Swift中的类和结构，你也可以为枚举添加自定义初始化方法。例如，你可以为灰度值制作一个自定义初始化方法。
把这个扩展添加到你的 Playground：

```swift
// 为枚举类型添加自定义初始化方法
extension CSSColor {
    init(gray: UInt8) {
        self = .rgb(red: gray, green: gray, blue: gray)
    }
}
```

在你的 Playground 上添加以下内容：

```swift
let color3 = CSSColor(gray: 0xaa)
print(color3) // prints #AAAAAA
```

你现在可以方便地创建灰度颜色了!



### 枚举的命名空间

已命名的类型可以作为一个命名空间，使事情井井有条，尽量减少复杂性。你创建了`ColorName`和`CSSColor`，但是，`ColorName`只在`CSSColor`的上下文中使用。

如果你能在`CSSColor`模型中嵌套`ColorName`，那不是很好吗？

那么，你就可以了 把`ColorName`从你的 Playground 上移走，用下面的代码代替它：

```swift
extension CSSColor {
    enum ColorName: String, CaseIterable {
        case black, silver, gray, white, maroon, red, purple, fuchsia, green,
             lime, olive, yellow, navy, blue, teal, aqua
    }
}
```

这就把`ColorName`移到了`CSSColor`的一个扩展中。现在，`ColorName`被隐藏起来了，而内部类型被定义在`CSSColor`上。

由于它现在是嵌套的，你先前创建的`for`循环也需要更新。把它改成下面的样子：

```swift
for color in CSSColor.ColorName.allCases {
    print("I love the color \(color).")
}
```

> 注意：Swift 的一大特点是，你声明东西的顺序通常并不重要。编译器会多次扫描文件并计算出结果，而不需要像使用C/C++/Objective-C时那样向前声明东西。
> 然而，如果你在 Playground 中收到关于 `ColorName` 是未声明类型的错误，请将上述扩展移到 `CSSColor` 的枚举定义下面，以清除 Playground 错误。
>
> 有时，Playground 对定义的顺序很敏感，即使这并不重要。



### 对枚举的评价

在 Swift 中，枚举比其他语言，如 C 或 Objective-C 中的枚举要强大得多。正如你所看到的，你可以扩展它们，创建自定义的初始化方法，提供命名空间并封装相关操作。

到目前为止，你已经使用枚举来为 CSS 颜色建模。这很好，因为 CSS 颜色是一个很好理解的、固定的W3C规范。

枚举很适合从已知事物的列表中挑选元素，比如一周的日期、硬币的正反面或状态机的状态。Swift 的 **optionals** 是以枚举的形式实现的，其状态为 `.none` 或 `.some`，并有一个关联值，这并不奇怪。

另一方面，如果你希望 `CSSColor` 可以被用户扩展到 W3C 规范中没有定义的其他颜色空间模型，枚举并不是最有用的颜色建模方式。

这就把你带到了下一个名为 Swift 的模型类型：结构或构造。



## 使用结构体

因为你希望你的用户能够在SVG中自定义形状，所以使用枚举来定义形状类型并不是一个好选择。

你不能在以后的扩展中添加新的枚举情况。要启用这种行为，你必须使用一个类或一个结构。

Swift 标准库团队建议，当你创建一个新的模型时，你应该首先使用一个协议来设计接口。你希望你的形状是可画的，所以把这个添加到你的 Playground：

```swift
protocol Drawable {
    func draw(with context: DrawingContext)
}
```

该协议定义了 `Drawable` 的含义。它有一个绘制方法，可以绘制到一个叫做 `DrawingContext` 的东西。
说到`DrawingContext`，它只是另一个协议。把它添加到你的 Playground，如下所示：

```swift
protocol DrawingContext {
    func draw(_ circle: Circle)
}
```

一个 `DrawingContext` 知道如何绘制纯几何类型。圆、矩形和其他基元。请注意这里的内容：实际的绘制技术没有被指定，但你可以用任何东西来实现它--SVG、HTML5 Canvas、Core Graphics、OpenGL、Metal等等。

你已经准备好定义一个遵守 `Drawable` 协议的圆。把它添加到你的 Playground：

```swift
struct Circle: Drawable {
  var strokeWidth = 5
  var strokeColor = CSSColor.named(name: .red)
  var fillColor = CSSColor.named(name: .yellow)
  var center = (x: 80.0, y: 160.0)
  var radius = 60.0

  // Adopting the Drawable protocol.

  func draw(with context: DrawingContext) {
    context.draw(self)
  }
}
```

任何遵守 `DrawingContext` 协议的类型现在都知道如何画一个圆。



### 动态成员查找

Swift 4.2 引入了一种方法，使 Swift 更加接近 Python 等脚本语言。你不会失去任何 Swift 的安全性，但你确实获得了编写你更可能在 Python 中看到的那种代码的能力。

在这个新功能里面有一个新的属性，叫做 `@dynamicMemberLookup`。当试图访问这些属性时，这将调用一个下标方法。

用下面的方法替换你当前的 `Circle` 实现：

```swift
@dynamicMemberLookup
struct Circle: Drawable {
  var strokeWidth = 5
  var strokeColor = CSSColor.named(name: .red)
  var fillColor = CSSColor.named(name: .yellow)
  var center = (x: 80.0, y: 160.0)
  var radius = 60.0

  // Adopting the Drawable protocol.

  func draw(with context: DrawingContext) {
    context.draw(self)
  }
}
```

通过上述内容，你已经为 `Circle` 结构定义了新的 `@dynamicMemberLookup` 属性。这需要 `Circle` 实现 `subscript(dynamicMember:)` 方法来处理你的 `@dynamicMemberLookup` 的实现。

在 `Circle` 结构中添加以下内容：

```swift
subscript(dynamicMember member: String) -> String {
    let properties = ["name": "Mr Circle"]
    return properties[member, default: ""]
}
```

现在你可以通过添加以下代码来访问你的 `Cycle` 的名称，硬编码为 "Mr Circle"：

```swift
let circle = Circle()
let circleName = circle.name
```

毕竟，所有的形状都有名字。 :]

动态成员查询属性可以被添加到类、结构、枚举或协议声明中。

结构的工作方式很像类，但有几个关键的区别。也许最大的区别是，==结构是值类型，而类是引用类型==。现在这意味着什么呢？


### 值类型与引用类型

![](https://koenig-media.raywenderlich.com/uploads/2015/11/value_type.png)

值类型作为独立的和不同的实体。典型的值类型是一个整数，因为它在大多数编程语言中是这样工作的。

如果你想知道一个值类型是如何工作的，可以问一个问题："Int会怎么做？" 比如说。

#### Int 类型

```swift
var a = 10
var b = a
a = 30 // b still has the value of 10
a == b // false
```

#### 对于 `Cycle`（使用结构定义）：

```swift
var a = Circle()
a.radius = 60.0
var b = a
a.radius = 1000.0 // b.radius still has the value 60.0
```

![](https://koenig-media.raywenderlich.com/uploads/2015/11/reference_type.png)

如果你把 `circle` 实现为一个 Class 类型，它将被赋予引用语义。这意味着它引用了一个底层共享对象。

#### 对于 `Cycle`（使用类定义）：

```swift
let a = Circle() // a class based circle
a.radius = 60.0
let b = a
a.radius = 1000.0  // b.radius also becomes 1000.0
```

当使用值类型创建新对象时，会进行复制；当使用引用类型时，新变量会指向同一个对象。这种行为上的差异是类和结构之间的一个关键区别。

### 矩形模型

你的 `Cycle` 目前有点孤单，所以现在是时候添加一个矩形模型了：

```swift
// 矩形
struct Rectangle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .teal)
    var fillColor = CSSColor.named(name: .aqua)
    var origin = (x: 110.0, y: 10.0)
    var size = (width: 100.0, height: 130.0)
    
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
}
```

你还需要更新 `DrawingContext` 协议，以便它知道如何画一个矩形。在你的 Playground 上用以下内容替换 `DrawingContext`：

```swift
protocol DrawingContext {
    func draw(_ circle: Circle)
    func draw(_ rectangle: Rectangle)
}
```

圆和矩形采用了 `drawable` 协议。它们将实际工作推迟到符合 `DrawingContext` 协议的东西上。

现在，是时候做一个具体的模型，以 SVG 风格绘制。把它添加到你的 Playground 上：

```swift
final class SVGContext: DrawingContext {
    private var commands: [String] = []

    var width = 250
    var height = 250

    // 1
    func draw(_ circle: Circle) {
        let command = """
      <circle cx='\(circle.center.x)' cy='\(circle.center.y)\' r='\(circle.radius)' \
      stroke='\(circle.strokeColor)' fill='\(circle.fillColor)' \
      stroke-width='\(circle.strokeWidth)' />
      """
        commands.append(command)
    }

    // 2
    func draw(_ rectangle: Rectangle) {
        let command = """
      <rect x='\(rectangle.origin.x)' y='\(rectangle.origin.y)' \
      width='\(rectangle.size.width)' height='\(rectangle.size.height)' \
      stroke='\(rectangle.strokeColor)' fill='\(rectangle.fillColor)' \
      stroke-width='\(rectangle.strokeWidth)' />
      """
        commands.append(command)
    }

    var svgString: String {
        var output = "<svg width='\(width)' height='\(height)'>"
        for command in commands {
            output += command
        }
        output += "</svg>"
        return output
    }

    var htmlString: String {
        return "<!DOCTYPE html><html><body>" + svgString + "</body></html>"
    }
}
```

`SVGContext` 是一个包裹着命令字符串的私有数组的类。在第1节和第2节中，你遵守 `DrawingContext` 协议，`draw` 方法附加了一个字符串，其中有正确的XML用于渲染形状。

最后，你需要一个可以包含许多 `Drawable` 对象的文档类型，所以要把它添加到你的 Playground。

```swift
struct SVGDocument {
  var drawables: [Drawable] = []

  var htmlString: String {
    let context = SVGContext()
    for drawable in drawables {
      drawable.draw(with: context)
    }
    return context.htmlString
  }

  mutating func append(_ drawable: Drawable) {
    drawables.append(drawable)
  }
}
```

这里，`htmlString` 是 `SVGDocument` 上的一个计算属性，它创建了一个 `SVGContext`，并从上下文中返回带有 HTML 的字符串。



### 展示一些 SVG

你终于画出了一个SVG，怎么样？把这个加到你的 Playground 上：

```swift
var document = SVGDocument()

let rectangle = Rectangle()
document.append(rectangle)

let circle = Circle()
document.append(circle)

let htmlString = document.htmlString
print(htmlString)
```

这段代码创建了一个默认的圆形和矩形，并将它们放入一个文档中。然后它打印出XML。将下面的内容添加到 Playground  的末尾，以看到SVG的运行：

```swift
import WebKit
import PlaygroundSupport
let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.loadHTMLString(htmlString, baseURL: nil)
PlaygroundPage.current.liveView = view
```

这就做了一些游戏的技巧，设置了一个网络视图来查看SVG。按Command-Option-Return键，在辅助编辑器中显示这个web 视图。Ta-da!



## 使用类

到目前为止，你使用了结构（值类型）和协议的组合来实现可绘制模型。

现在，也该是玩玩类的时候了。类让你定义基类和派生类。对于形状问题，比较传统的面向对象的方法是制作一个带有`draw()`方法的`Shape`基类。

尽管你现在不会使用它，但知道它是如何工作的还是有帮助的。它看起来就像这样：

<img src="https://koenig-media.raywenderlich.com/uploads/2015/11/hierarchy.png" style="zoom:50%;" />



而且，在代码中，它看起来像下面的块--这只是供参考，所以**不要**把它添加到你的 Playground：

```swift
// 形状基类
class Shape {
    var strokeWidth = 1
    var strokeColor = CSSColor.named(name: .black)
    var fillColor = CSSColor.named(name: .black)
    var origin = (x: 0.0, y: 0.0)
  
    func draw(with context: DrawingContext) { fatalError("not implemented") }
}

// 圆形
class Circle: Shape {
    override init() {
        super.init()
      
        strokeWidth = 5
        strokeColor = CSSColor.named(name: .red)
        fillColor = CSSColor.named(name: .yellow)
        origin = (x: 80.0, y: 80.0)
    }

    var radius = 60.0
    override func draw(with context: DrawingContext) {
        context.draw(self)
    }
}

// 矩形
class Rectangle: Shape {
    override init() {
        super.init()
      
        strokeWidth = 5
        strokeColor = CSSColor.named(name: .teal)
        fillColor = CSSColor.named(name: .aqua)
        origin = (x: 110.0, y: 10.0)
    }

    var size = (width: 100.0, height: 130.0)
    override func draw(with context: DrawingContext) {
        context.draw(self)
    }
}
```

为了使面向对象的编程更加安全，Swift 引入了 `override` 关键字。它要求你——程序员——承认你在覆盖什么。

<img src="https://koenig-media.raywenderlich.com/uploads/2015/11/line.png" style="zoom:50%;" />



尽管这种模式很常见，但这种面向对象的方法也有一些缺点。

你会注意到的第一个问题是在 `draw` 的基类实现中。`Shape` 想避免被误用，所以它调用`fatalError()`来提醒派生类它们需要覆盖这个方法。不幸的是，这个检查发生在运行时，而不是编译时。

其次，`Circle` 和 `Rectangle` 类必须处理基类数据的初始化问题。虽然这是一个相对容易的情况，但为了保证正确性，类的初始化可能会成为一个有点复杂的过程。

第三，对基类进行未来验证是很困难的。例如，假设你想添加一个可绘制的线条类型。为了与你现有的系统一起工作，它必须派生自 `Shape`，这有点名不副实。

此外，你的 `Line` 类需要初始化基类的 `fillColor` 属性，而这对一条线来说并没有实际意义。

最后，类有前面讨论过的引用（共享）语义。虽然自动引用计数（ARC）在大多数时候都能处理好事情，但你需要注意不要引入引用循环，否则你会出现内存泄露的结果。

如果你把同一个形状添加到一个形状数组中，当你把一个形状的颜色修改为红色时，你可能会感到惊讶，而另一个形状似乎也会随机改变。

### 为什么还要使用类

鉴于上述缺点，你可能会想知道为什么你会想使用类。

首先，它们允许你采用像 Cocoa 和 Cocoa Touch 这样成熟的、经过战斗考验的框架。

此外，类确实有更重要的用途。例如，一个大型的占用内存、复制成本高的对象是用类来包装的绝佳候选者。类可以很好地模拟一个身份。你可能会遇到这样的情况：许多视图都在显示同一个对象。如果该对象被修改，所有的视图也会反映模型的变化。对于一个值类型，同步更新会成为一个问题。

简而言之，类在引用和值的语义发生作用的时候是有帮助的。

请看关于这个主题的两部分教程：[Swift 中的引用与值类型](https://www.raywenderlich.com/9481-reference-vs-value-types-in-swift)。

### 实现计算属性

所有命名的模型类型都允许你创建自定义的设置器和获取器，这些设置器和获取器不一定对应于一个存储属性。

假设你想给你的 Circle 模型添加一个直径的 getter 和 setter。用现有的半径属性来实现它是很容易的。

将下面的代码添加到你的 Playground 的末端：

```swift
extension Circle {
    // 添加计算属性
    var diameter: Double {
        get {
            return radius * 2
        }
        set {
            radius = newValue / 2
        }
    }
}
```

这实现了一个新的计算属性，它纯粹是基于半径的。当你得到直径时，它返回加倍的半径。当你设置直径时，它将半径设置为该值除以2。很简单!

更多时候，你只想实现一个特殊的 getter。在这种情况下，你不需要包括 `get {}` 关键字块，只需要指定主体即可。周长和面积是很好的用例。

在你刚刚添加的 `Circle` 扩展中添加以下内容：

```swift
extension Circle {
    // 计算属性
    var diameter: Double {
        get {
            return radius * 2
        }
        set {
            radius = newValue / 2
        }
    }

    // 只读计算属性
    var area: Double {
      return radius * radius * Double.pi
    }
    var perimeter: Double {
      return 2 * radius * Double.pi
    }
}
```

与类不同，结构方法默认不允许修改或变异（mutate）存储属性的值，但如果你声明它们是变异的，它们就可以。

例如，在 Circle 扩展中添加以下内容：

```swift
func shift(x: Double, y: Double) {
    center.x += x
    center.y += y
}
```

这试图在圆上定义一个 `shift()` 方法，它在空间中移动圆--即改变中心点。

但是这在两行上产生了以下错误，这两行是增加了 `center.x` 和 `center.y` 属性。

```swift
// ERROR: Left side of mutating operator has immutable type ‘Double'
```

这可以通过添加 `mutating` 关键字来解决，就像这样：

```swift
    mutating func shift(x: Double, y: Double) {
        center.x += x
        center.y += y
    }
```

这就告诉 Swift 这个方法是可执行的，因为你的函数异变了这个结构。


## 追溯建模和类型约束

Swift 的一个伟大功能是**追溯建模（retroactive modeling）**。它允许你扩展一个模型类型的行为，即使你没有它的源代码。

这里有一个用例。假设你是 SVG 代码的用户，你想给矩形添加面积和周长，就像圆形一样。

要想知道这一切意味着什么，请在你的 Playground 上添加这个：

```swift
// 追溯建模
extension Rectangle {
    // 面积
    var area: Double {
        return size.width * size.height
    }

    // 周长
    var perimeter: Double {
        return 2 * (size.width + size.height)
    }
}
```

这增加了一个扩展，将面积和周长添加到现有的模型中，而且，现在，你将把这些方法正式变成一个新的协议。

把这个添加到你的 Playground 上：

```swift
protocol ClosedShape {
  var area: Double { get }
  var perimeter: Double { get }
}
```

这给了你一个正式的协议。

接下来，你将通过在你的 Playground 上添加以下内容，告诉圆形和矩形要追溯性地遵守这个协议：

```swift
extension Circle: ClosedShape {}
extension Rectangle: ClosedShape {}
```

你也可以定义一个函数，例如，计算采用 `ClosedShape` 协议的模型阵列（结构体、枚举或类的任何混合）的总周长。

在 Playground 的末尾添加以下内容：

```swift
func totalPerimeter(shapes: [ClosedShape]) -> Double {
  return shapes.reduce(0) { $0 + $1.perimeter }
}

totalPerimeter(shapes: [circle, rectangle])
```

这使用 `reduce` 来计算周长之和。你可以在 [函数式编程入门](https://www.raywenderlich.com/9222-an-introduction-to-functional-programming-in-swift) 中了解更多关于它的工作原理。



## 何去何从？

在本教程中，你了解了 enum、struct 和 class——Swift 的命名模型类型。

这三种类型都有关键的相似之处。它们提供封装，可以有初始化方法，可以有计算属性，可以采用协议，并且可以追溯建模。

我希望你喜欢这个关于 Swift 中命名模型类型的旋风之旅。如果你正在寻找一个挑战，可以考虑建立一个更完整的SVG渲染库。你已经有了一个好的开始。

像往常一样，如果你有问题或者你想分享的见解，请使用下面的论坛!