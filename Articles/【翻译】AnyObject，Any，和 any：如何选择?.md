> 原文：[AnyObject, Any, and any: When to use which?](https://www.avanderlee.com/swift/anyobject-any/)
>
> 在 Swift 5.6 中引入 any 关键字一开始让我很困惑，因为我们现在有 Any、AnyObject 和 any。我决定深入研究细节，找出我们应该在什么时候使用它们，或者我们是否应该使用它们。



`AnyObject` 和 `Any` 在 [SE-355](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md) 中引入了一个新选项 `any`，这让我们的开发人员更难了解它们的区别。每个选项都有其用例和关于何时不使用它们的陷阱。

`Any` 和 `AnyObject` 是 Swift 中的特殊类型，用于类型擦除（type erasure），与 `any` 没有直接关系。请注意本文中的大写 `A`，因为我将介绍 `Any` 和任何具有不同解释的内容。让我们深入了解细节！



## 何时使用 `AnyObject`?

`AnyObject` 是所有类都隐式遵守的协议。事实上，标准库包含一个表示 `AnyObject.Type` 的类型别名 `AnyClass`。

```swift
print(AnyObject.self) // Prints: AnyObject
print(AnyClass.self) // Prints: AnyObject.Type
```

所有 class、class type 或 class-only protocols（纯类协议）都可以使用 `AnyObject` 作为它们的具体类型。基于演示目的，你可以创建一个包含不同类型的数组：

```swift
let imageView = UIImageView(image: nil)
let viewController = UIViewController(nibName: nil, bundle: nil)

let mixedArray: [AnyObject] = [
    // 我们可以将 `UIImageView` 和 `UIViewController` 添加到同一个数组中
    // 因为它们都可以转换为 `AnyObject`。
    imageView,
    viewController,

    // `UIViewController` 类型隐式遵守 `AnyObject` 协议，因此也可以添加。
    UIViewController.self
]
```

只有类遵守 `AnyObject`，这意味着你可以使用它来限制仅由引用类型实现的协议：

```swift
protocol MyProtocol: AnyObject { }
// 这也意味着，结构体、枚举类型等值类型无法遵守该协议
```

如果你需要无类型对象的灵活性，你可以使用 `AnyObject`。我可以给出使用任何对象集合的示例，这些对象在使用时可以转换回具体类型，但我想建议一些不同的东西。

我不记得在我的任何项目中使用过 `AnyObject`，因为我总是能够使用具体类型来代替。这样做还会产生更易读的代码，让其他开发人员更容易理解。为了向你展示这一点，我创建了这个示例方法，它将图像配置到目标容器中：

```swift
func configureImage(_ image: UIImage, in imageDestinations: [AnyObject]) {
    for imageDestination in imageDestinations {
        switch imageDestination {
        case let button as UIButton:
            button.setImage(image, for: .normal)
        case let imageView as UIImageView:
            imageView.image = image
        default:
            print("Unsupported image destination")
            break
        }
    }
}
```

通过使用 `AnyObject` 作为我们的目标，我们总是需要使用默认实现进行转换并考虑转换失败。我的偏好是总是使用具体协议重写它：

```swift
// Create a protocol to act as an image destination.
protocol ImageContainer {
    func configureImage(_ image: UIImage)
}

// Make both `UIButton` and `UIImageView` conform to the protocol.
extension UIButton: ImageContainer {
    func configureImage(_ image: UIImage) {
        setImage(image, for: .normal)
    }
}

extension UIImageView: ImageContainer {
    func configureImage(_ image: UIImage) {
        self.image = image
    }
}

// Create a new method using the protocol as a destination.
func configureImage(_ image: UIImage, into destinations: [ImageContainer]) {
    for destination in destinations {
        destination.configureImage(image)
    }
}
```

生成的代码更干净、可读，并且不再需要处理不受支持的容器。实例需要符合 `ImageContainer` 协议才能接收配置的图像。

## 何时使用 `Any`?

`Any` 可以表示任何类型的实例，包括函数类型：

```swift
let arrayOfAny: [Any] = [
    0,
    "string",
    { (message: String) -> Void in print(message) }
]
```

对我来说，与 `AnyObject` 相比，相同的规则适用于 `Any`，这意味着您应该始终寻求使用具体类型。 `Any` 通过允许您转换任何类型的实例而更加灵活，与使用具体类型相比，使代码更难预测。



## 何时使用 `any`?

`any` 是在 [SE-335](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md#any-and-anyobject) 中引入的，看起来与 `Any` 和 `AnyObject` 相似，但用途不同，因为您使用它来指示存在的使用。以下示例代码使用本文前面示例中的示例代码演示了图像配置器：

```swift
struct ImageConfigurator {
    var imageContainer: any ImageContainer

    func configureImage(using url: URL) {
        // 注：这不是有效下载图像的方法，这里只是用作一个简单的例子。
        let image = UIImage(data: try! Data(contentsOf: url))!
        imageContainer.configureImage(image)
    }
}

let iconImageView = UIImageView()
var configurator = ImageConfigurator(imageContainer: iconImageView)
configurator.configureImage(using: URL(string: "https://picsum.photos/200/300")!)
let image = iconImageView.image
```

如您所见，我们通过使用 `any` 关键字标记我们的 `imageContainer` 属性来指示使用存在的 `ImageContainer`。使用 `any` 标记协议将从 Swift 6 开始强制执行，因为它将表明以这种方式使用协议对性能的影响。

存在类型具有重大限制和性能影响，并且比使用具体类型更昂贵，因为你可以动态更改它们。以下代码是此类更改的示例：

```swift
let button = UIButton()
configurator.imageContainer = button
```

我们的 `imageContainer` 属性可以表示遵守 `ImageContainer` 协议的任何值，并允许我们将其从 `UIImageView` 实例更改为 `UIButton` 实例。需要动态内存才能使这成为可能，从而消除了编译器优化这段代码的可能性。在引入 `any` 关键字之前，没有明确的指示向开发人员表明这种性能成本。



## 远离 `any`

在某种程度上，您可以争辩 `any`、`Any` 和 `AnyObject` 有一些共同点：谨慎使用它们。

您可以使用泛型重写上面的代码示例并消除对动态内存的需求：

```swift
struct ImageConfigurator<Destination: ImageContainer> {
    var imageContainer: Destination
}
```

意识到性能影响并知道如何改写代码是作为 Swift 开发人员必须具备的一项基本技能。



## 总结

`Any`、`any` 和 `AnyObject` 看起来很相似，但有重要的区别。在我看来，最好重写你的代码并消除使用这些关键字的需要。这样做通常会产生更具可读性和可预测性的代码。

如果您想进一步提高 Swift 知识，请查看 Swift 类别页面。如果您有任何其他提示或反馈，请随时与我联系或在 Twitter 上向我发送推文。

谢谢！





