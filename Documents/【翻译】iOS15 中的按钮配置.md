> 原文：[Button Configuration in iOS 15](https://useyourloaf.com/blog/button-configuration-in-ios-15/)

苹果在 iOS 15 中给了按钮一个很大的升级。你现在可以创建和更新按钮配置，就像苹果在 iOS 14 中为集合和列表视图单元格引入的变化。

### 四种基础样式

从 Xcode 13 开始，一个按钮有四种基本的预定义样式。当你从对象库中拖动一个按钮到 Interface Builder 时，它有一个普通的样式。使用属性检查器来选择其他的样式之一：

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/001.png)

如果你需要支持 iOS 14 或更早的版本，你需要将按钮的样式改为 "Default"。然后你可以在属性检查器或代码中进一步定制按钮配置。

### 按钮配置

如果你在代码中创建你的按钮，在 iOS 15 中的新功能，按钮配置取代了 `UIButton` 的许多旧方法和属性。你可以直接在按钮上设置配置：

```swift
let button = UIButton(type: .system)
button.configuration = .plain()
button.configuration = .gray()
button.configuration = .tinted()
button.configuration = .filled()   
```

要定制一个预定义的配置，首先要制作一个副本：

```swift
var config = UIButton.Configuration.filled()
config.title = "Custom Filled Button"
...
button.configuration = config
```

如果你已经采用了iOS 13的基于 `UIAction` 闭包的动作，那么在创建按钮时要传递配置：

```swift
let button = UIButton(configuration: config,
  primaryAction: UIAction() { _ in
    print("Go")
   })
```



### 定制按钮

当定制按钮时，你改变 `configuration`，而不是直接在按钮上设置 properties。让我们来看看其中的一些选项：

#### Title 和 Subtitle

按钮的标题和副标题可以是纯文本或属性字符串。

```swift
var config = UIButton.Configuration.filled()
config.title = "Start"
config.subtitle = "Both Engines"
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/002.png)

如果你使用的是副标题，你可以改变与标题的对齐和填充样式：

```swift
config.titleAlignment = .center
config.titlePadding = 4.0
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/003.png)

#### 按钮颜色

你可以设置按钮的基本背景和前景颜色。当处于不同的状态时（例如高亮时），按钮可能会改变这些基础颜色：

```swift
config.baseBackgroundColor = .green
config.baseForegroundColor = .black
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/004.png)

为了更好地控制背景，`UIButton` 支持 iOS14 中为表格和集合视图单元格引入的 `UIBackgroundConfiguration`：

```swift
config.background.backgroundColor = .systemYellow
config.background.strokeColor = .systemRed
config.background.strokeWidth = 4.0
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/005.png)

#### 圆角样式

默认的圆角样式是 `dynamic`，它为动态类型的大小调整角落半径。你也可以选择固定、小、中、大和 `capsule`：

```swift
config.cornerStyle = .capsule
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/006.png)


#### 图片位置

当你为按钮添加 foreground image 时，你可以控制对标题的填充、位置（top, trailing, bottom, leading）和符号配置。

```swift
config.image = UIImage(systemName: "car",
  withConfiguration: UIImage.SymbolConfiguration(scale: .large))
config.imagePlacement = .trailing
config.imagePadding = 8.0
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/007.png)



#### 活动指示器

设置`showsActivityIndicator`属性可以用一个活动指示器替换图像。

```swift
config.showsActivityIndicator = true
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/012.png)

#### 按钮大小

你可以为按钮申请一个首选尺寸。Interface Builder 在尺寸检查器中隐藏了这一点。

```swift
config.buttonSize = .large
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/008.png)

#### Content Insets

内容嵌入给你在按钮和内容（标题和图片）的边界之间提供填充。

```swift
config.contentInsets = NSDirectionalEdgeInsets(top: 10,
  leading: 20, bottom: 10, trailing: 20)
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/009.png)

#### 配置更新处理程序

要改变按钮的外观以响应状态的变化，注册一个配置更新处理程序。例如，当按钮处于高亮状态时，在填充和轮廓图像之间切换。

```swift
button.configurationUpdateHandler = { button in
  var config = button.configuration
  config?.image = button.isHighlighted ?
    UIImage(systemName: "car.fill") :
    UIImage(systemName: "car")
  button.configuration = config
}
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/010.png)

为了扩展这个例子，假设我有一个持有我的汽车的范围的属性，我想在按钮的副标题中显示：

```swift
private var range = Measurement(value: 100,
                                 unit: UnitLength.miles)
private lazy var formatter = MeasurementFormatter()
```



在我的配置更新处理程序中添加 `subtitle`：

```swift
button.configurationUpdateHandler = { [unowned self] button in
  var config = button.configuration
  ...            
  config?.subtitle = self.formatter.string(from: self.range)
  button.configuration = config
}
```



然后我们在`didSet`属性观察者中对按钮调用`setNeedsUpdateConfiguration`，以便在范围变化时更新副标题。

```swift
private var range = Measurement(value: 100,
  unit: UnitLength.miles) {
  didSet {
    button.setNeedsUpdateConfiguration()
  }
}
```

![](https://useyourloaf.com/blog/button-configuration-in-ios-15/011.png)

### 更多详情

[WWDC: Meet the UIKit button system](https://developer.apple.com/videos/play/wwdc2021/10064/)

