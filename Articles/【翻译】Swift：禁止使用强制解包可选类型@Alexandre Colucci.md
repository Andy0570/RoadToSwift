> 原文：[Swift: Banning force unwrapping optionals @Alexandre Colucci](https://blog.timac.org/2017/0628-swift-banning-force-unwrapping-optionals/)



在这篇文章中，我将讨论强制解包的危害，以及如何避免强制解包。

# Swift 可选类型和强制解包

[Swift 编程语言](https://docs.swift.org/swift-book/index.html)支持可选类型（optional types）用于处理没有值的情况。一个可选性代表两种可能性：要么有值，你可以解包这个可选类型来访问这个值，要么根本就没有值。

以下是如何在 Swift 中声明一个可选类型变量的方式：

```swift
var myOptionalString: String?
```

`myOptionalString` 变量可以包含一个 `String` 类型的字符串值或 `nil`。如果该可选类型有值，你可以通过使用感叹号操作符显式地解包它来访问底层存储的值，比如：

```swift
print("myOptionalString 变量的值是：\(myOptionalString!).")
```



# 强制解包的危害

虽然强制解包看起来很方便，但使用起来却非常危险：如果可选类型没有值，而你试图解包它，就会触发一个运行时错误——通常会导致应用程序崩溃。

我在 Swift 代码中看到的绝大多数应用程序的崩溃都是由一个不正确的显式解包引起的。为什么有人要解开一个值为 `nil` 的可选类型呢？有很多原因：

* 一个可选类型变量的值从来都不是 `nil`，只不过在重构后会变成 `nil`；
* 代码复制和粘贴；
* 可选类型变量很少可能为零，但产生了一些边缘情况；
* ...



# 按我说的做，而不是按我做的做

Swift 文档

Swift 文档在一个[注释](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)中提到，你应该谨慎使用强制解包的方法：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gxl8ffmg1ej30g302e0st.jpg)

---

WWDC session 407：不要滥用强制解包

同样，[WWDC 2017 session  407  "理解未定义行为"](https://developer.apple.com/videos/play/wwdc2017/407/) 在幻灯片125中告诉我们："不要滥用强制解包"。

---

其他 WWDC session 中滥用强行拆包的情况

观看 WWDC 2017 的任何其他 session，你会看到很多（太多了）强制解包。例如，看看 [session 203 "介绍拖放"](https://developer.apple.com/videos/play/wwdc2017/203/)。在120号幻灯片上，你可以看到：

```swift
let dragView = interaction.view!
```

这行代码真的安全吗？在文档中没有任何地方可以看到 `UIDragInteraction` 的视图被保证有一个值。另外，如果它被保证有一个值，为什么它在 API 中是可选类型呢？

---

Apple 滥用强制解包的示例代码

从 [Apple 开发者网站](https://developer.apple.com/library/archive/navigation/#section=Resource%20Types&topic=Sample%20Code)随机下载一个示例代码，看看是否以及如何使用强制解包。在这篇文章中，我下载了最新的 Swift 示例代码。使用 [Photos 框架的示例应用程序](https://developer.apple.com/library/archive/samplecode/UsingPhotosFramework/Introduction/Intro.html)。在搜索强制解包操作符时，你可以找到这样的代码：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/ExampleappusingPhotosframework1_small.png)



这段代码假设 textFields 的 alertController 的数组至少包含一个对象。为什么不使用更安全的东西，比如：

```swift
alertController.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""), style: .default) { _ in
         if let title = alertController.textFields?.first?.text, !title.isEmpty {
```

同一项目中的另一个例子：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/ExampleappusingPhotosframework2.png)

写成这样不是更简洁、更安全吗？

```swift
@IBAction func play(_ sender: AnyObject) {
        if let player = playerLayer.player {
            // An AVPlayerLayer has already been created for this asset; just play it.
            player.play()
        } else {
```

---

Xcode 的 Fix-it 功能希望你插入强制拆包运算符

Xcode的 Fix-it 功能建议插入强制解包操作符...即使它没有意义：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/Playground.png)



# 如何避免强制解包

有多种解决方案，比使用强制解包更简洁、更安全。我还发现这些代码通常更易读。下面是几个例子：

---

可选绑定（`if let`）

下面的代码是正确的，但使用了 2 个强制解包：

```swift
// 先判断数组中的第一个对象不为空，再强制解包获取这个对象并判断它的类型
if myArray.first?.object != nil && myArray.first!.object!.type == .type1 {
    // Do Something
}
```

通过使用可选绑定的方式，这段代码的可读性大大增强：

```swift
if let object = myArray.first?.object, object.type == .type1 {
    // Do Something
}
```

另一个类似的可能会导致应用程序崩溃的例子：

```swift
// 设置 myView 的高度 = myLabel 的高度
// 如果 myLabel 当前还没有被绘制到屏幕上，就会导致应用程序运行崩溃
myView.setHeight((myLabel?.frame.size.height)!)
```

同样，一个 `if let` 语句可以防止可能出现的崩溃。请注意使用相同的变量名来访问解包后的值这一巧妙的技巧：

```swift
if let textLabel = textLabel {
    badgeView.setHeight(textLabel.frame.size.height)
}
```

---

在一个 `if` 语句中的 Guard 语句和多个可选绑定

看看下面这个函数。所有的错误处理都是重复的代码。还要注意 `as!` 操作符的使用，如果 `theObject.value` 的值不是 `NSNumber` 类型，就会导致应用程序运行崩溃：

```swift
func( object inObject: ObjectType ) {
    if inObject.child!.childType == .childType1 {
        if let theObject = inObject.child!.object(forType: .childType2) {
            if inObject != theObject {
                if let theValue = theObject.value as! NSNumber?, theValue != true {
                    // Do something
                }
                else {
                    // Error handling
                }
            }
            else {
                // Error handling
            }
        }
        else {
            // Error handling
        }
    }
    else {
        // Error handling
    }
}
```

相反，使用提前退出，将 `if` 语句分组并使用 `as?`：

```swift
func( object inObject: ObjectType ) {
    // guard 语句判断条件
    guard let child = inObject.child  else {
        return
    }
 		
  	// 在单个 if 语句中同时判断多个条件
    if child.childType == .childType1,
        let theObject = child.object(forType: .childType2), inObject != theObject,
        let theValue = theObject.value as? NSNumber, theValue != true {
            // Do something
    } else {
        // Error handling
    }
```

---

空合运算符（`??`）

尽管以下代码是安全的，但它并不优雅：

```swift
if newState != nil {
    self.state = newState!
}
else {
    self.state = .default
}
```

使用空合运算符要干净得多：

```swift
self.state = newState ?? .default
```

---

用于初始化成员变量的闭包表达式

在下面的例子中，如果 `myFunc2()` 在 `myFunc1()` 之前被调用，你可能会得到一个崩溃：

```swift
var myObject: MyObject?
 
func myFunc1() {
    self.myObject = MyObject.init()
}
 
func myFunc2() {
    self.myObject!.rotate()
}
```

你可以使用一个闭包表达式来初始化变量：

```swift
var myObject: MyObject = {
    return MyObject.init()
}()
 
func myFunc1() {
}
 
func myFunc2() {
    self.myObject.rotate()
}
```



# 隐式解包可选类型

隐式解包可选类型的情况与强制解包非常相似。来自 Swift 文档：

> *An implicitly unwrapped optional is a normal optional behind the scenes, but can also be used like a nonoptional value, without the need to unwrap the optional value each time it is accessed.*
>
> 一个隐式解包的可选类型值在背后是一个普通的可选类型值，但也可以像非可选类型值一样使用，而不需要在每次访问时解包可选类型值。

类似于强制解包可选类型，我看到很多代码危险地使用隐式解包可选类型。这种选项也应该被避免......除了在一种情况下它是非常有用的。当声明一个 `IBOutlet` 类型时，你应该使用一个隐式解包可选类型，因为一旦 `viewDidLoad` 方法被调用，`IBOutlet` 将被初始化。另外在 `viewDidLoad` 方法之前使用 `IBOutlet` 将是一个编程错误。

例如，你可以这样写：

```swift
@IBOutlet weak var myLabel: UILabel!
```



# 总结

Apple 告诉我们要遵守使用强制解包的规则。然而，在 WWDC 的幻灯片以及示例代码中，经常使用强制解包操作。这让人很难过，因为 Apple 重复使用强制解包会让人养成坏习惯，你会很容易忘记强制解包的危险。

在代码中禁止使用强制解包，可以使你的代码更安全，避免一堆崩溃。此外，你的代码将更加可读和简洁。







