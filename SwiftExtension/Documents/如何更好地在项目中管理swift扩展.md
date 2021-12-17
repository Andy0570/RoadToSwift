> 原文：[Medium: Better way to manage swift extensions in your project](https://kaushalelsewhere.medium.com/better-way-to-manage-swift-extensions-in-ios-project-78dc34221bc8)

![Photo by Natalia Y on Unsplash](https://upload-images.jianshu.io/upload_images/2648731-d474dfb54c374e23.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

该如何管理项目中的扩展（extension）？下面是我项目的截图，它说明了一切。

![](https://upload-images.jianshu.io/upload_images/2648731-dcb14aa523e266d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

例如，我有一个简单的扩展 `UIColor+Image.swift`，它用于通过颜色生成图像。

```swift
extension UIColor {
    func toImage() -> UIImage {
        // 通过颜色生成图片的方法
    }
}
```

用法：
```swift
let redImage = UIColor.red.toImage()
```

完美，不是吗？

## 问题
可读性。
1. 没有人可以轻易地猜到这个函数是来自于原生的 `UIColor` 类还是来自于我定制的扩展（除非你去阅读源码）。
2. 这些扩展在不同的项目中是可以重用的，所以我们很可能希望它们能延续到下一个项目中。要猜测它属于哪个命名空间很困难。


## 解决办法
一个简单而古老的方法是，在我们的扩展中，在所有函数名前添加 `_` (下划线)作为前缀。
例如: `my_` 或 `abc_`

```swift
extension UIColor {
    func my_toImage() -> UIImage {
        // 通过颜色生成图片的方法
    }
}
```

用法：
```swift
let redImage = UIColor.red.my_toImage()
```

但是这个解决方案难以管理，因为我们必须确保所有的函数都以 `my_` 为前缀。


## Swift 协议为我们提供了解决方案
要是我们用 `my.toImage()` 来代替 `my_toImage()` 会怎么样？

所以我们的想法是做一个单独的类/结构模块，叫做 `MyHelper`，它将包含所有的扩展方法。如果你愿意，你也可以将函数分组为扩展方法。

`MyHelper.swift`：
```swift
import UIKit

public protocol MyHelperCompatible {
    associatedtype someType
    var my: someType { get }
}

public extension MyHelperCompatible {
    var my: MyHelper<Self> {
        get { return MyHelper(self) }
    }
}

public struct MyHelper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// All conformance here
extension UIColor: MyHelperCompatible {}
```

`MyHelperCompatible` 协议有一个 "my "变量，它保存了整个 `MyHelper` 类/结构体对象。

现在，可以根据我们的需求来扩展 `MyHelper`。

例如，`UIImage+myHelper.swift`：

```swift
import Foundation
import UIKit

extension MyHelper where Base: UIColor {
    func toImage() -> UIImage {
        // 通过颜色生成图片的方法
    }
}
```

在上面的文件中，我们可以添加与 `UIColor` 相关的其他辅助函数。同样，我们也可以将所有的函数归入 `MyHelper` 扩展。

最后，可以像下面这样使用 `toImage()` 方法：

```swift
let redImage = UIColor.red.my.toImage()
```

从现在开始，我们只需要创建像上面一样的扩展和方法。

在任何情况下，如果你想禁用该扩展，可以直接注释/删除一致性部分的代码。

```swift
// extension UIColor: MyHelperCompatible {}
```

*提示*：最好把所有的一致性代码都放在一个地方，而不是分散在项目的各个地方，这样你就可以有更多的控制权。

### 最后的结论

我知道这似乎有点棘手，需要额外的精力来设置，但相信我，当你的项目增长时，它有很大的帮助。
