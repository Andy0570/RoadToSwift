> 原文：[How to create gradient color using CAGradientLayer @Swift Development Center](https://www.swiftdevcenter.com/how-to-create-gradient-color-using-cagradientlayer/)

`CAGradientLayer` 类定义在 **QuartzCore** 框架下，它继承自 `CALayer`。为了应用渐变色，你只需要写四行代码即可。

```swift
let gradientLayer = CAGradientLayer() // 1
gradientLayer.frame = self.view.bounds // 2
gradientLayer.colors = [UIColor.magenta.cgColor, UIColor.black.cgColor] // 3
self.view.layer.addSublayer(gradientLayer) // 4
```

1. 创建一个 `CAGradientLayer` 对象的实例。
2. 给这个图层设置一个位置和尺寸，在我们的例子中，设置了视图的尺寸。
3. 渐变色属性接受一个 `CGColor` 类型的数组，否则将无法使用。你必须提供至少两个 `CGColor`。
4. 将此渐变层作为子层添加到视图层中。


## 渐变色位置

`Locations` 属性接受一个 `NSNumber` 类型的数组。使用该属性我们可以改变渐变色的位置，默认值为 `[0, 1]`，即从顶部开始到底部结束。`0` 是上，`1` 是下，这意味着它只接受 `0` 到 `1` 之间的值。默认情况下，位置的方向是从上往下。

```swift
let gradientLayer = CAGradientLayer()
gradientLayer.frame = self.view.bounds
gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
gradientLayer.locations = [0.0, 1.0];
self.view.layer.addSublayer(gradientLayer)
```

<img src="https://www.swiftdevcenter.com/wp-content/uploads/2019/03/ColorLocation.jpg" style="zoom: 50%;" />

对于第一张图片，我们使用下面的代码来定位：
```swift
gradientLayer.locations = [0.0, 1.0]
```

对于第二张图片，我们使用下面的代码来定位：
```swift
gradientLayer.locations = [0.6, 1.0]
```

在上面的图片中，第一张图片的默认颜色位置是 `[0.0, 1.0]`，而第二张图片的颜色位置是 `[0.6, 1.0]`，即从顶部的 0.6 开始。在图片中，你可以清楚地看到颜色是如何随着给定的位置而变化的。



## 渐变色方向

如上图所示，默认的渐变色方向是从上到下。`CAGradientLayer` 有两个属性 `startPoint` 和 `endPoint`，利用这个点我们可以改变渐变色的方向，比如从上到下、从下到上、从左到右、从右到左。在进行下一步之前，我们首先要了解坐标系。请看下图。左上角从 `(0, 0)` 开始，右上角是 `(1, 0)`...

<img src="https://www.swiftdevcenter.com/wp-content/uploads/2019/03/newCoordinates.png" style="zoom:50%;" />


### 从上往下

```swift
gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
```

### 从下往上

```swift
gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
```

### 从左往右

```swift
gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
```

### 从右往左

```swift
gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
```

![](https://www.swiftdevcenter.com/wp-content/uploads/2019/03/GradientDirection.jpg)


## CAGradientLayer 的 UIView 扩展

最后使用下面的 `UIView` 扩展来绘制渐变色，只需编写一行代码。

```swift
extension UIView {
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.1, 1.0], direction: Direction = .topToBottom) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        self.layer.addSublayer(gradientLayer)
    }
}
```

**现在，为了在任何视图上绘制渐变色，只需写下下面一行代码，你的渐变色就实现了**

```swift
self.view.applyGradient(colors: [UIColor.red.cgColor, UIColor.blue.cgColor],
                                locations: [0.0, 1.0],
                                direction: .topToBottom)
```

你可以从 [GitHub](https://github.com/swiftdevcenter/GradientColorExample/tree/master/GradientColorExample/GradientColorExample) 下载源代码

阅读下一篇文章：[Create PDF from UIView, WKWebView, and UITableView](https://www.swiftdevcenter.com/create-pdf-from-uiview-wkwebview-and-uitableview/)

