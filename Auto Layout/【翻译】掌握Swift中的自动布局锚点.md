> 原文：[Mastering iOS auto layout anchors programmatically from Swift](https://theswiftdev.com/mastering-ios-auto-layout-anchors-programmatically-from-swift/)
>
> 寻找使用自动布局锚点的最佳实践？让我们来学习如何用Swift正确地使用iOS的自动布局系统。



## 以编程方式创建视图和约束

首先，我想回顾一下 `UIViewController` 的生命周期方法，你可能对其中一些方法很熟悉。它们是按照以下顺序被调用的：

* `loadView`
* `viewDidLoad`
* `viewWillAppear`
* `viewWillLayoutSubviews`
* `viewDidLayoutSubviews`
* `viewDidAppear`

在前自动布局时代，你必须在`viewDidLayoutSubviews`方法中进行布局计算，但由于这是一个专业的自动布局教程，我们将只关注`loadView`和`viewDidLoad`方法。

这些是使用自动布局创建视图层次结构的基本规则：

* 不要自己手动计算 `frame`!
* 用 `.zero` 初始化视图的 `frame`
* 将 `translatesAutoresizingMaskIntoConstraints` 设置为 `false`
* 使用 `addSubview` 将你的视图添加到视图层次结构中
* 创建并激活你的布局约束 `NSLayoutConstraint.activation`
* 在 `loadView` 而不是 `viewDidLoad` 中创建带有约束的视图。
* 通过使用弱属性来处理内存管理问题
* 在 `viewDidLoad` 中设置所有其他的属性，如背景颜色等。

理论够了，这里有一个简短的例子：

```swift
class ViewController: UIViewController {

    weak var testView: UIView!

    override func loadView() {
        super.loadView()

        let testView = UIView(frame: .zero)
        testView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testView)
        NSLayoutConstraint.activate([
            testView.widthAnchor.constraint(equalToConstant: 64),
            testView.widthAnchor.constraint(equalTo: testView.heightAnchor),
            testView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        self.testView = testView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testView.backgroundColor = .red
    }
}
``
```

很简单，是吧？只需要几行代码，你就有了一个固定尺寸的中心对齐的视图，并有一个专门的类属性引用。如果你通过interface builder创建完全相同的视图，系统会免费为你 "制作" `loadView` 方法，但你必须为该视图设置一个`IBOutlet`引用。

> 永恒的困境：代码还是 Interface Builder？

这真的不重要，请自由选择你的道路。有时我喜欢玩玩 IB，但在大多数情况下，我更喜欢用程序化的方式做事。



## 常见的 UIKit 自动布局约束用例

所以我答应过你，我将向你展示如何以编程方式制作约束，对吗？让我们现在就来做。首先，我只使用布局锚。你可以用视觉格式语言来浪费你的时间，但那绝对是个死胡同。所以记住我的话：只使用锚点或堆栈视图，而不使用其他东西

下面是我用来创建漂亮布局的最常见的模式。

### 设置固定宽度和高度

第一个是最简单的：将一个视图的高度或宽度设置为一个固定点。

```swift
testView.widthAnchor.constraint(equalToConstant: 320),
testView.heightAnchor.constraint(equalToConstant: 240),
```

### 设置宽高比

设置一个视图的长宽比只是约束宽度和高度，或者相反，你可以简单地通过乘数来定义比率。

```swift
testView.widthAnchor.constraint(equalToConstant: 64),
testView.widthAnchor.constraint(equalTo: testView.heightAnchor, multiplier: 16/9),
```

### 水平和垂直居中

将视图置于另一个视图的中心是一项微不足道的任务，有专门的锚点来实现这一目的。

```swift
testView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
testView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
```

### 拉伸|用填充物填充视图内部

这里唯一棘手的部分是，如果涉及到常数，尾部和底部约束的行为与顶部和领先的约束有一点不同。通常情况下，你必须使用负值，但经过几次尝试，你就会明白这里的逻辑。

```swift
testView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
testView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32),
testView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32),
testView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32),
```

### 按比例的宽度或高度

如果你不想用常量值工作，你可以使用 multiplier。

```swift
testView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3),
testView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/3),
```

### 使用安全区域布局指南

有了最新的 iPhone，你需要一些指南，以保证你在缺口处的安全。这就是为什么视图有 `safeAreaLayoutGuide` 属性的原因。你可以在呼出安全区域指南后得到所有常用的锚点。

```swift
testView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
testView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
testView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
```



## 动画化布局约束

用约束条件做动画是很容易的，你不应该相信别人可能说的话。我做了一些规则和一个例子，可以帮助你理解约束条件下的恒定值的动画的基本原则，加上切换各种约束。

规则：

* 使用标准的 `UIView` 动画与 `layoutIfNeeded`
* 总是先停用约束条件
* 严格遵守已停用的约束条件
* 尽情享受吧!

约束动画的例子：

```swift
class ViewController: UIViewController {

    weak var testView: UIView!
    weak var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!

    override func loadView() {
        super.loadView()

        let testView = UIView(frame: .zero)
        testView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(testView)

        let topConstraint = testView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let bottomConstraint = testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            testView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            bottomConstraint,
        ])

        let heightConstraint = testView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)

        self.testView = testView
        self.topConstraint = topConstraint
        self.bottomConstraint = bottomConstraint
        self.heightConstraint = heightConstraint
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testView.backgroundColor = .red

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        self.view.addGestureRecognizer(tap)
    }

    @objc func tapped() {
        if self.topConstraint.constant != 0 {
            self.topConstraint.constant = 0
        }
        else {
            self.topConstraint.constant = 64
        }

        if self.bottomConstraint.isActive {
            NSLayoutConstraint.deactivate([self.bottomConstraint])
            NSLayoutConstraint.activate([self.heightConstraint])
        } else {
            NSLayoutConstraint.deactivate([self.heightConstraint])
            NSLayoutConstraint.activate([self.bottomConstraint])
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
```

这不是那么糟糕，接下来：自适应性和支持多种设备屏幕尺寸。



## 如何为 iOS 创建自适应布局

甚至苹果也在为内置的iOS应用程序的自适应布局而苦恼。如果你看看那些用集合视图制作的应用程序--比如照片--在每个设备上的布局都很好。然而，还有一些其他的，在我看来，在大屏幕上的体验是很糟糕的。

### 旋转支持

实现自适应布局的第一步是支持多种设备方向。你可以查看我之前写的关于iOS自动布局的文章，那篇文章里有很多关于旋转支持、在自动布局土地里使用图层等的好东西。

### 特征集合

第二步是适应特性集合。UITraitCollection 是为你分组所有环境特定的特征，如尺寸类、显示比例、用户界面标识等。大多数时候，你将不得不检查垂直和水平尺寸类。有一个关于设备尺寸类和苹果公司所有可能的变化的参考资料，见下面的外部资源部分。
下面这个小的Swift代码例子演示了如何检查尺寸类，以便为紧凑和普通屏幕设置不同的布局。

```swift
class ViewController: UIViewController {

    weak var testView: UIView!

    var regularConstraints: [NSLayoutConstraint] = []
    var compactConstraints: [NSLayoutConstraint] = []

    override func loadView() {
        super.loadView()

        let testView = UIView(frame: .zero)
        testView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(testView)

        self.regularConstraints = [
            testView.widthAnchor.constraint(equalToConstant: 64),
            testView.widthAnchor.constraint(equalTo: testView.heightAnchor),
            testView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ]

        self.compactConstraints = [
            testView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            testView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ]

        self.activateCurrentConstraints()
        self.testView = testView
    }

    private func activateCurrentConstraints() {
        NSLayoutConstraint.deactivate(self.compactConstraints + self.regularConstraints)

        if self.traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(self.regularConstraints)
        } else {
            NSLayoutConstraint.activate(self.compactConstraints)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testView.backgroundColor = .red
    }

    // MARK: - rotation support

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    // MARK: - trait collections

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.activateCurrentConstraints()
    }
}
```



### 设备检测

你也可以通过UIDevice类检查用户界面的idom（也就是这个该死的设备是iPhone还是iPad），以根据它来设置例如字体大小。

```swift
UIDevice.current.userInterfaceIdiom == .pad
```



### 屏幕尺寸

弄清你的环境的另一个选择是检查屏幕的尺寸。你可以检查本地像素数或基于点的相对尺寸。

```swift
//iPhone X
UIScreen.main.nativeBounds   // 1125x2436
UIScreen.main.bounds         // 375x812
```

通常情况下，我努力让自己遵守这些规则。我真的不记得有什么场景是我需要超过我上面列出的所有东西的，但如果你有一个具体的案例或问题，请不要犹豫，与我联系。

谢谢🙏
