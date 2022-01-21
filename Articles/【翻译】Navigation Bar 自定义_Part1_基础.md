> 原文：[Navigation Bar Customisation. Part 1 - The Basics.](https://dmtopolog.com/navigation-bar-customization/)



导航栏定制是初级 iOS 开发者的首要任务之一。几乎每个应用程序（甚至大多数测试样本和教程）都有一个导航堆栈，没有人愿意坚持默认的系统风格的导航栏。

这里是导航栏定制系列的第一部分。我们将尝试收集和系统化关于这个问题的知识，包括解决这个问题的旧方法以及 iOS 13 中的新的方法。在这篇文章中，我们将回顾基础知识：负责导航栏各个部分的属性，以及根据我们的设计稿改变其行为样式的方法。

（[这里是该系列的第二部分](https://dmtopolog.com/navigation-bar-customisation-2/)，我们谈论关于 `NavigationBar`、`UIAppearance` 和新的 `UINavigationBarAppearance` 的架构问题）



## 导航栏的组成部分

我们的导航栏，默认看起来像这样：

![](https://dmtopolog.com/images-posts/2019-10-26-navigation-bar-customization/navigation-bar-default.png)

而我们（或我们的 UX/UI 设计人员）希望看到这样的东西：

![](https://dmtopolog.com/images-posts/2019-10-26-navigation-bar-customization/navigation-bar-customised-2.png)

让我们来看看我们在屏幕上看到的 UI 元素：

![](https://dmtopolog.com/images-posts/2019-10-26-navigation-bar-customization/navigation-bar-numbers.png)


1. Background
2. Title
3. Bar buttons
4. Back button
5. Shadow/separator



### 1. 背景颜色

改变背景颜色是一项微不足道的工作：

```swift
navigationController.navigationBar.barTintColor = UIColor.yellow
navigationController.navigationBar.isTranslucent = false // 禁用半透明
```

如果你不希望导航栏是半透明（translucent）的，只需禁用相应的属性。

这里最主要的是要选择正确的属性。不要像其他所有的 `UIView` 子类那样选择 `backgroundColor`，这样更符合逻辑，不要选择 `tintColor`，而应该选择 `barTintColor`。



### 2. 标题

改变标题外观（连同状态栏）的第一个也是最原始的方法是改变栏的 style：

```swift
navigationController.navigationBar.barStyle = .black
```

这个属性的 `.default` 值意味着该栏有浅色背景，所以内容（标题和状态栏）是黑色的。将样式改为 `.black` 会使标题和状态栏变成白色。

要正确地设计导航栏的标题（不仅仅是将黑色切换为白色），你必须设置其文本属性：

```swift
// 自定义导航栏标题样式
navigationController.navigationBar.titleTextAttributes = [
    .foregroundColor: UIColor.black,
    .font: UIFont(name: "MarkerFelt-Thin", size: 20)!
]
```

使用文本属性，你不仅可以定制颜色或字体，还可以定制更多，包括基线偏移（baseline offset）、拼写（spelling）、阴影（shadow）或扩展的可访问性设置（整个可能的选项集可以在[文档](https://developer.apple.com/documentation/foundation/nsattributedstring/key)中找到）。

当我们需要更多的时候（例如，设置一个图片作为标题，做一个带副标题的双行标题或做更疯狂的事情），我们可以设置一个自定义视图而不是默认标签作为我们的标题。



### 3. 导航栏按钮

有几种方法来实例化一个 bat button item。

#### 文本按钮

```swift
// left Bar Button Item
navigationItem.leftBarButtonItem = UIBarButtonItem(
    title: "Button",
    style: .plain,
    target: self,
    action: #selector(buttonTappedAction)
)
```

根据不同的 `style`，字体将是普通或粗体。

要改变按钮的颜色（不管它们是文本按钮还是图标按钮），你应该使用 navigationBar 的 `tintColor`。

```swift
// 设置导航栏按钮颜色
navigationController?.navigationBar.tintColor = UIColor.red
```

但如果我们需要更多的东西，我们就求助于对象的文本属性，就像我们对标题所做的那样：

```swift
// left Bar Button Item
navigationItem.leftBarButtonItem = UIBarButtonItem(
    title: "Button",
    style: .plain,
    target: self,
    action: #selector(buttonTappedAction)
)

if let leftButton = self.navigationItem.leftBarButtonItem {
    let regularBarButtonTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.systemOrange,
        .font: UIFont(name: "MarkerFelt-Thin", size: 16)!
    ]

    leftButton.setTitleTextAttributes(regularBarButtonTextAttributes, for: .normal)
    leftButton.setTitleTextAttributes(regularBarButtonTextAttributes, for: .highlighted)
}
```

<img src="https://tva1.sinaimg.cn/large/008i3skNgy1gyiy10raghj30v907zmx5.jpg" style="zoom: 50%;" />



提醒一下，bar buttons 是视图控制器的 navigation item 的属性，而不是 navigation bar 的属性（这是一个重要的问题，将在后面讨论）。另外，别忘了给正常状态和高亮状态都应用一些属性。



#### 默认系统按钮

```swift
navigationItem.rightBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .camera,
    target: nil,
    action: nil
)
```

这可以在几个方面非常有用。首先，使用这个预设，你不需要担心一些频繁的动作的最佳设计，如 "取消"、"保存 "或 "编辑"。如果你使用这个系统枚举，你可以确保你的动作对用户来说是可以理解的和原生的，因为你让平台（iOS）来处理这个问题。其次，对于像 "完成"、"保存"、"取消 "这样的文本按钮，你可以免费获得本地化服务。最后但最不重要的是，这些带有默认系统设计的项目将随着系统的发展而发展。当下一个 iOS 版本的系统图标集被更新后，你的按钮将自动得到这个更新。

这是可能的选项清单—— [UIBarButtonItem.SystemItem](https://developer.apple.com/documentation/uikit/uibarbuttonitem/systemitem)



#### 图标按钮

如果你想让你的自定义图像出现在一个按钮上，你可以这样做：

```swift
// right Bar Button Item
navigationItem.rightBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .camera,
    target: nil,
    action: nil
)
```

请注意，这样一来，bar tint color 就会应用到你的图像上。通常，这正是你希望从你的 bar buttons 中得到的东西。



#### 自定义视图按钮

如果你需要更多的定制，你可以把任何视图放到 bar button 上：

```swift
let button = UIButton()
button.setImage(UIImage(named: "rainbow-circle"), for: .normal)
navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
```

例如，如果你使用一个 `UIButton` 实例，图像将不会受到 bar’s tint color 的影响。如果你需要对按钮的不同状态（`.normal`, `.highlighted`）进行更精细的控制，这也可以帮助你。



### 4. 返回按钮

返回按钮一般是一个 bar button，但它有几个特殊的功能：

* 默认情况下，这个按钮同时具有图像和标题。
* 它在 navigation item 中有一个特殊的属性。
* 它连接到一个导航控制器的 back swipe gesture recogniser。



同样重要的是，当前视图控制器的返回按钮是你在将下一个视图控制器推入堆栈时看到的东西。

![](https://dmtopolog.com/images-posts/2019-10-26-navigation-bar-customization/backbutton-explanation.png)



这里我们有一个导航控制器和两个视图控制器在它的堆栈中。根视图控制器和视图控制器（我称它们为 RootVC 和 VC 以使之更简短）。我们的想法是，当 VC 显示在屏幕上时，RootVC 的返回按钮将是可见的。在 VC 的导航栏中，有 VC 的标题、VC 的 right button items（如果存在的话）和 RootVC 的返回按钮。

当你第一次看到它时，这很令人困惑，但它有其逻辑。

默认情况下，系统会将一个视图控制器的标题（指视图控制器的 `title` 属性）放在其返回按钮项上。在我们的例子中，它是堆栈中第一个视图控制器（RootVC）的 "Root View Controller"。但只有当你在第二个屏幕（VC）中没有任何标题时，你才能在返回按钮项中看到这样一个长字符串。否则这两个元素--VC 的标题和 RootVC 的返回按钮标题--就不适合在屏幕上出现。在这种情况下，系统会优先考虑实际的屏幕标题（有道理，对吧？），并将返回按钮的标题替换为 "Back"。所以不要奇怪为什么有时你会在后退按钮上看到实际的屏幕名称，而有时只是 "Back"。

假设我们想把返回按钮的标题从冗长的 "Root View Controller"（或 "Back"）改成没有任何大写的 "back"。我们可以按以下方法做：

```swift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // ...
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "back",
            style: .plain,
            target: nil,
            action: nil
        )
    }

    // ...
}
```

![](https://dmtopolog.com/images-posts/2019-10-26-navigation-bar-customization/backbutton-explanation-2.png)

如果我们想完全删除标题，我们可以直接设置一个空字符串：

```swift
navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
```

让我们继续改变它，给按钮添加一些自定义动作：

```swift
navigationItem.backBarButtonItem = UIBarButtonItem(
    title: "",
    style: .plain,
    target: self,
    action: #selector(popToPrevious)
)
```

在 `popToPrevious()` 里面，我们先执行我们自己的事情，然后弹出 VC（毕竟这是你按下后退按钮时应该发生的事情）。

```swift
@objc private func popToPrevious() {
    // our custom stuff
    navigationController?.popViewController(animated: true)
}
```

一切顺利。很好! 但是，如果我们决定为后退按钮使用一个自定义的图标（只是一个图标，没有文字）：

```swift
navigationItem.backBarButtonItem = UIBarButtonItem(
    image: UIImage(named: "back"),
    style: .plain,
    target: self,
    action: #selector(popToPrevious)
)
```

这看起来并不漂亮，因为系统会在我们的自定义图片上添加一个默认的图片。所以我们可以用 `leftBarButtonItem` -property来代替，完全取代我们的返回按钮：

```swift
navigationItem.leftBarButtonItem = UIBarButtonItem(
    image: UIImage(named: "back"),
    style: .plain,
    target: self,
    action: #selector(popToPrevious)
)
```

除了我们失去了返回滑动的手势外，一切都很好。但要恢复它，我们只需要重新定义手势识别器的委托（我们甚至不需要实现任何委托的方法）。

```swift
navigationController?.interactivePopGestureRecognizer?.delegate = self
```

让我们用一些自定义的标题和背景颜色来应用它：

![](https://dmtopolog.com/images-posts/2019-10-26-navigation-bar-customization/navigation-bar-customised-2.png)

完成：我们有了我们的自定义图标，我们可以处理按下按钮的事件，向右滑动返回也像预期的那样工作。

### 5. 阴影

阴影，或者说导航栏和视图之间的分隔线，是一个相当隐形的UI元素。但它仍然可以成为我们设计的一个重要部分。
`UINavigationBar`类有一个属性`shadowImage`。如果你查看[文档](https://developer.apple.com/documentation/uikit/uinavigationbar/1624963-shadowimage)，你会看到这样一个简单明了的描述。

> The default value is nil, which corresponds to the default shadow image. When non-nil, this property represents a custom shadow image to show instead of the default.
>
> 默认值为 `nil`，对应于默认的阴影图像。当不为 `nil` 时，该属性代表一个自定义的阴影图像，以代替默认值。

因此，当你想把它替换成自定义的东西时，你只要调用：

```swift
navigationController.navigationBar.shadowImage = yourCustomImage
```

不幸的是，没有合适的 API 可以在需要时改变阴影的颜色。当然，你总是可以使用 [Stack Overflow 讨论](https://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift)中提到的方法之一来创建一个单色图像。

另一个典型的任务是完全删除阴影。为此，你只需设置一个空图像：

```swift
// 删除导航栏阴影
navigationController.navigationBar.shadowImage = UIImage()
```

如果你阅读该属性的文档，直到最后，你会看到第二部分的内容。

> To show a custom shadow image, you must also set a custom background image with the `setBackgroundImage(_:for:)` method. If the default background image is used, then the default shadow image is used regardless of the value of this property.
>
> 要显示一个自定义的阴影图像，你还必须用 `setBackgroundImage(_:for:)` 方法设置一个自定义的背景图像。如果使用默认的背景图像，那么不管这个属性的值如何，都会使用默认的阴影图像。



似乎它只适用于低于 iOS11版本的系统。从 iOS11 开始，只需改变 `shadowImage` 就可以了，不用处理背景。
