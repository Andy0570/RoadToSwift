> 原文：[iOS Text Field Built-in Animated Character Counter](https://stasost.medium.com/ios-text-field-built-in-animated-character-counter-25c97110fc7e)



> 译者注：我在代码中重构了字符计数器的实现方式，使用 Notification 注册通知，以支持中文输入法、并在截取字符串后恢复光标位置。




在我最近的应用程序中，我需要限制 `UITextField` 的文本长度。

在 `UITextFieldDelegate` 方法 `ShouldReturnCharacterInRange` 中，有一个直接的方法，只有几行代码：

```swift
func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }

    let newLength = text.characters.count + string.characters.count  
                    - range.length
    return newLength <= yourTextLimit
}
```

完整版本，缺点是不支持中午输入法：

```swift
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text, lengthLimit != 0 else {
        return true
    }

    // 当前文本长度 = 编辑前的字符数 + 将要添加的字符数 - 将要删除的字符数
    let newLength = text.utf16.count + string.utf16.count - range.length

    if newLength <= lengthLimit {
        countLabel.text = "\(newLength)/\(lengthLimit)"
    } else {
        UIView.animate(withDuration: 0.1) {
            self.countLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { (finish) in
            UIView.animate(withDuration: 0.1) {
                self.countLabel.transform = CGAffineTransform.identity
            }
        }
    }

    return newLength <= lengthLimit
}
```



我们稍后将逐行解释这段代码。

> 这将会起到神奇的作用，但 iOS 应用程序是关于用户体验的。从用户的角度来看，这种方法并没有提供任何反馈。它还提出了几个问题。
> 
> 1. 为什么我不能输入更多的字符？
> 2. 字符的限制是什么？
> 3. 我还能增加多少个字符？



那么，我们如何才能使其更具有互动性呢？

在本教程中，我将向你展示如何在你的文本输入框中整合一个交互式的字符计数器。最后，你将拥有这个漂亮的动画计数器：

![](https://miro.medium.com/max/320/1*uAtK0BWtl2IofuVz7LJLTA.gif)

让我们开始吧。

## Part 1: 基础设置

首先，启动一个新项目。

创建一个新的类作为 `UITextField` 的子类。

> 让你的类可重复使用总是一个好的做法，所以基于这个原因，子类将是一个很好的选择。

![](https://miro.medium.com/max/700/1*ye7AMfe9OPUQ5gIh0Meyew.png)


如果你是一个 storyboard-type 的 iOS 开发者，或者你希望你的类可以从界面生成器中访问，你应该在类的声明前添加 `@IBDesignable` 关键字：

```swift
@IBDesignable class DRHTextFieldWithCharacterCount: UITextField {

}
```

我们需要显示字符数，所以继续创建一个 `UILabel`。

```swift
private let countLabel = UILabel()
```

> 另一个好的 iOS 开发实践是将你所有的属性和方法创建为 `private`，除非你需要从类的外部使用它们（在这种情况下，你可以随时将其改回为 `public`）。

再创建几个属性，这些属性将定义计数器的外观。添加 `@IBInspectable`，如果你想从 Interface Builder 中访问这些属性。

```swift
@IBInspectable var lengthLimit: Int = 0
@IBInspectable var countLabelTextColor: UIColor = UIColor.black
```

> 如果你想在 Interface Builder 中访问 `@IBInspectable` 属性，请确保你明确地设置该属性的类型。由于类型推断，即使你不这样做，编译器耶不会向你显示任何警告，但你将不会在 Interface Builder  中看到这个属性。

我们将使用 `lengthLimit` 来设置我们的限制，可以从 Interface Builder 构造函数中设置，也可以通过在代码中访问这个属性。

`countLabelTextColor` 将设置默认的计数器文本颜色为黑色。

我们准备为我们的项目添加新的标签。进入你的 storyboard，添加一个新的 `UITextField`。使用 AutoLayout 将其定位在屏幕的正中央，并设置宽度为150。

<img src="https://miro.medium.com/max/700/1*d02KHvNQyVJRMVI71mdIIQ.png" style="zoom: 67%;" />

![](https://miro.medium.com/max/496/1*m47oeU1TG0vi7XLNCSydEw.png)



切换到 Identity Inspector，将 `UITextField` 类改为我们自定义的 `DRHTextFieldWithCharacterCount`：

![](https://miro.medium.com/max/514/1*A_jQZhAdQ9F_3bTt40TCfQ.png)

回到 Attributes Inspector，并设置长度限制和计数标签文本颜色：

![](https://miro.medium.com/max/508/1*SaUxNF8WPBlJnPBQRWHXkQ.png)

这就是我们在 storyboard 中需要做的所有事情，所以回到你的自定义类文件。
接下来，我们需要设置我们的标签，并在 `UITextField` 中显示它。


## Part 2: 设置 Counter Label

在你的类中创建一个方法：

```swift
private func setCountLabel() {

}
```

我们将使用 `rightView` 来显示我们的标签。`RightView` 是一个现有的 `UITextField` 子视图，它默认位于右侧。

首先，我们使这个视图可见：

```swift
rightViewMode = .always
```

在这个例子中，我们想一直显示计数标签（如果你不想在文本字段未激活时显示标签，只需将模式改为 `whileEditing`）。

设置默认的计数器标签文本字体。对于这个项目，我们将把它设置为10：

```swift
countLabel.font = font?.withSize(10)
```

用用户定义的属性设置计数器标签文本的颜色：

```swift
countLabel.textColor = countLabelTextColor
```

在标签的左边对齐文本：

```swift
countLabel.textAlignment = .left
```

默认情况下，`rightView` 是空的，所以我们需要用我们的标签来初始化它：

```
rightView = countLabel
```

> 我们怎么可以用一个 `UILabel`（counterLabel）来初始化一个 `UIView`（rightView）呢？事实上，`UILabel` 是 `UIView` 的子类，所以这里的赋值语句是完全可行的。

现在，我们需要设置初始计数器文本。在最后一条语句下面添加以下一行代码。

```swift
countLabel.text = initialCounterValue(text: text)
```


## Part 3: 计算字符串的字符数

让我们回到预览中，看看我们的计数标签应该是什么样子的。

![](https://miro.medium.com/max/724/1*asxm0IJLpznKQeTU8CiaQQ.png)

我们需要按照以下格式组成字符串：`currentCount/Limit`。

当前的字符数不是别的，而是我们文本字段中的文本 `String` 的长度。但是我们怎么才能得到字符数呢？

显而易见的方法是访问 `String` 中的字符集并获得其计数。

```swift
let length = myString.characters.count
```

另一种方法是获取UTF16字符数：

```swift
let length = myString.utf16.count
```

> 这两种方式有什么区别？如果你想知道详细的答案，你可以查看 [Swift语言参考](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/StringsAndCharacters.html)。

简单来说，`UTF16.count` 返回 Unicode 字符的数量，而 `characters.count` 返回 16 位字节单元的数量。

让它变得超级简单，考虑下面的例子：

```swift
let emojiString = “🎬”
print(emojiString.characters.count)  // output: 1
print(emojiString.utf16.count)       // output: 2
```

在我们的项目中，区别如下：虽然这两种方法的工作方式相同，但当你输入时（因为你是逐个字符输入的），当你在文本字段中粘贴一个表情符号或其他 Unicode 符号时，它会给你一个不同的结果。
由于我们需要一个准确的字符数，我们将使用 UTF16 方法。

回到你的 `initialCounterValue` 方法声明：它需要一个可选的字符串作为参数，所以为了访问它的值，我们需要对它进行**安全解包（safe-unwrap）**。在 `initialCounterValue` 方法中添加以下代码：

```swift
if let text = text {

}
```

> 这是最重要的必须遵守的规则之一：永远不要强制解包可选类型。基本上，如果你在代码的某个地方看到一个解包标记，这可能是一个不好的信号。尽量通过使用可选链或 guard 语句来避免它。我们总是希望我们的代码是安全的，不是吗？

有了解包的字符串值，我们可以配置初始的计数器标签文本。如果文本值为 `nil`，我们就使用 "0"作为计数器的值。

```swift
if let text = text {
    return "\(text.utf16.count)/\(lengthLimit)" 
} else {
    return "0/\(lengthLimit)"
}
```

配置计数器标签的最后一步将是调用 `setCountLabel()`。在我们的类的结尾处添加以下代码：

```swift
override func awakeFromNib() {
    super.awakeFromNib()

    setCountLabel()
}
```

> `awakeFromNib` 是在视图被初始化后立即调用的，所以这是设置标签外观的好地方。

如果 `lengthLimit` 被设置为 `0`，我们就不需要设置标签，所以把这个语句包在一个简单的条件检查中：

```swift
override func awakeFromNib() {
    super.awakeFromNib()

    if lengthLimit > 0 {
        setCountLabel()
    }
}
```

我们创建了计数器标签并设置了它的外观和默认值。如果你编译并运行你的项目，你会看到这个图片。

![](https://miro.medium.com/max/372/1*WtNfwD9hlZLs6MPJQMApOg.png)

等等，我们刚刚创建的计数器标签在哪里？

正如我之前提到的，`rightView` 的默认值是 `nil`，所以它的 `frame` 也是 `nil`。为了初始化新的 `frame`，我们需要覆盖 `UITextField` 的 `rightViewRectForBounds` 方法。在你的类的末尾添加以下代码：

```swift
override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    if lengthLimit > 0 {
        return CGRect(x: frame.width - 35, y: 0, width: 30, height: 30)
    } else {
        return CGRect.zero
    }
}
```

同样，如果 `lengthLimit` 为零，我们就不需要创建一个框架，所以只需返回 `CGRect.zero`。
我从父视图的右侧向左设置了 35 点的 frame，并使 frame 宽为 30 点。这使得我在右边留下了 5 point 的填充，我们将在后面的动画中使用。

现在编译并运行这个项目，它的行为会和预期的一样。

![](https://miro.medium.com/max/378/1*Hpc9mCajfdx5Np5Zp2Bguw.png)

我们就快成功了! 让我们进入最后一个部分：检查当前的文本长度，显示计数，限制它，并提供一个视觉反馈。



## Part 4: 施展魔法!

正如我在本教程的最开始提到的，我们需要覆盖 `UITextFieldDelegate` 方法。到目前为止，我们的类并不符合 `UITextFieldDelegate`，所以我们需要做一个类的扩展。

```swift
extension DRHTextFieldWithCharacterCount: UITextFieldDelegate {

}
```

> 为什么我们不在类声明的开头添加 `UITextFieldDelegate`？这是另一个很好的做法：把所有的委托方法放在一个适当的类扩展里面。

不要忘记给自己设置一个委托，这样我们的类就可以真正使用这个委托。在 `awakeFromNib()` 方法的末尾添加这段代码：

```swift
delegate = self
```

我们将覆写 `shouldChangeCharacterInRange` 方法。每当你在文本字段中输入或删除一个字符时，在该字符显示在 `UITextField` 中之前，它就会被调用。这个方法返回一个布尔值，所以你可以把它看成是一个简单的开关。如果它返回 `true`，文本字段将显示这些变化。如果它返回 `false`，无论你输入什么，都不会显示任何变化。

> 如果你在 `textField` 中粘贴一段文本，`shouldChangeCharacterInRange` 也将被调用。

在类的扩展中加入这个方法：

```swift
func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
  
}
```

不要担心编译器错误，一旦我们从这个方法返回一个布尔值，它就会消失。

首先，我们添加一个 `guard` 语句来检查 `textField` 中是否有任何文本。下面的代码就在这个新方法里面：

```swift
guard let text = textField.text else {
    return true
}
```

如果 `guard` 语句失败，我们返回 `true`，这意味着 `textField` 的当前变化是允许的。我们还需要确保当前的 `lengthLimit` 被设置为不同于0的数值。一个好的方法是使用一个快速的动态过滤器（一个 "where clause"），这样我们就可以避免另一个 `if-else` 语句。

```swift
guard let text = textField.text where lengthLimit != 0 else { 
    return true 
}
```

接下来，计算出当前文本的长度：

```swift
// 当前文本长度 = 编辑前的字符数 + 将要添加的字符数 - 将要删除的字符数
let newLength = text.utf16.count + string.utf16.count — range.length
```

让我们看一下这个语句的内部：

* `text.utf16.count` 是你编辑前的当前字符数。
* `string.utf16.count` 是你将要添加的字符数。
* `range.length` 是你删除的字符数。

只要 `newLenght` 的长度在限制之内，就更新计数器：

```swift
if newLength <= lengthLimit {
    countLabel.text = “\(newLength)/\(lengthLimit)”
} else {
   // animation code will go here
}
```

我们同意，当用户达到字符限制时，给他一个视觉反馈会很好。为了这个目的，我们将创建一个简单的脉冲动画。在else语句中，添加以下代码：

```swift
// 1
UIView.animate(withDuration: 0.1) {
    // 2
    self.countLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
} completion: { (finish) in
    // 3
    UIView.animate(withDuration: 0.1) {
        // 4
        self.countLabel.transform = CGAffineTransform.identity
    }
}
```

让我们逐行解释这段动画代码：
1. 创建一个持续时间为 0.1 秒的 `UIViewAnimation`
2. 在 X 轴和 Y 轴上为我们的计数器标签添加缩放动画。正如你所记得的，我们把计数器标签的 `frame` 设置得足够大，以适应缩放动画。
3. 在第一个动画完成后，创建另一个具有相同持续时间的动画。
4. 为标签设置动画，使其恢复到原始尺寸。

> 关于这个动画的更多信息，请参考 [Swift语言文档](https://developer.apple.com/reference/quartzcore/core_animation_functions)

最后，我们需要从 `shouldChangeCharactersInRange()` 方法返回一个布尔值。我们只允许在当前文本长度在限制范围内的情况下更新 `textField`。在该方法的末尾添加这一行：

```swift
return newLength <= lengthLimit
```

对于所有短于用户定义的 `lengthLimit` 的字符串，都将返回 `true`。

这就是了! 编译并运行该项目，享受你的文本字段内的动画计数器标签吧！

你可以在我的 Github 资源库中找到完整的[源代码](https://github.com/Stan-Ost/DRHTextFieldWithCharacterCount)。
