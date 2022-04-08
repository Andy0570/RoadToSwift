> 原文：[10 little UIKit tips you should know](https://theswiftdev.com/10-little-uikit-tips-you-should-know/?utm_source=swiftlee&utm_medium=swiftlee_weekly&utm_campaign=issue_101)
>
> 在这篇文章中，我收集了我最喜欢的 10 个流行的 UIKit 技巧，在我开始下一个项目之前，我肯定会想知道这些技巧。



## 自定义 UIColor 以支持深色模式

深色模式和浅色模式不应该遵循完全相同的设计模式，有时你想在你的应用程序处于浅色模式时使用边框，但在深色模式下你可能想隐藏多余的线条。

一个可能的解决方案是基于给定的 `UITraitCollection` 定义一个自定义的 `UIColor`。你可以检查 `trait` 的 `userInterfaceStyle` 属性来检查并设置深色模式的外观样式。

```swift
extension UIColor {
    // 边框颜色，浅色模式 UIColor.systemGray4，深色模式 UIColor.clear
    static var borderColor: UIColor {
        .init { (trait: UITraitCollection) -> UIColor in
            if trait.userInterfaceStyle == .dark {
                return UIColor.clear
            }
            return UIColor.systemGray4
        }
    }
}
```

基于这个条件，你可以很容易地返回浅色和深色模式的不同颜色。你可以通过扩展 `UIColor` 对象来创建你自己的一组静态颜色变量。如果你打算支持深色模式，并且你想创建自定义颜色，这是一个很有必要的小技巧。


## 监听 trait collection 的变化


下一个问题也与深色模式支持有关，有时你想检测用户界面的外观变化，这时`traitCollectionDidChange`函数就会有帮助。它在视图、控制器和 cell 中也可用，所以它是一个相当通用的解决方案。

```swift
class MyCustomView: UIView {
    // 如果 traitCollection 特征集合发生变化，则更新 CoreGraphics 图层
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        layer.borderColor = UIColor.borderColor.cgColor
    }
}
```

例如，在这个函数里面，你可以检查 trait 集合是否有不同的外观风格，你可以根据这个来更新你的CoreGraphics图层。CoreGraphics框架是一个低级别的工具，如果你使用图层和颜色，你必须手动更新它们，如果涉及到黑暗模式的支持，但 `traitCollectionDidChange` 方法可以帮助你很多。


## 带有上下文菜单的 UIButton

在 iOS 15 中，创建按钮变得更容易了，但你知道你也可以用按钮来显示上下文菜单吗？呈现一个`UIMenu`非常简单，你只需要将菜单和按钮的 `showsMenuAsPrimaryAction` 属性设置为 `true`。

```swift
import UIKit

class ViewController: UIViewController {

    weak var button: UIButton!

    override func loadView() {
        super.loadView()

        // 初始化按钮
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        self.button = button

        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle("弹出菜单", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.menu = getContextMenu()
        button.showsMenuAsPrimaryAction = true
    }

    func getContextMenu() -> UIMenu {
        .init(title: "菜单",
              children: [
                UIAction(title: "编辑", image: UIImage(systemName: "square.and.pencil")) { _ in
                    print("编辑按钮点击事件")
                },
                UIAction(title: "删除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    print("删除按钮点击事件")
                },
              ])
    }
}
```

<img src="https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/IMG_9912.jpg" style="zoom: 25%;" />

这样，`UIButton` 将作为一个菜单按钮，你可以为你的菜单 item 分配各种动作。我相信这个API在某些情况下特别方便，现在我更喜欢使用上下文菜单，而不是滑动到x-y的动作，因为如果我们直观地告诉他们（通常是用3个点），在一个给定的UI元素上有额外的动作，对用户来说会更方便一些。🧐

## 不要害怕创建子视图

UIKit 是一个 OOP 框架，我强烈建议对自定义视图进行子类化，而不是在你的视图控制器中使用多行视图配置代码片段。前面的代码片段是一个很好的反面教材，所以让我们快速解决这个问题。

```swift
import UIKit

class MenuButton: UIButton {

    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.initialize()
    }

    public init() {
        super.init(frame: .zero)

        self.initialize()
    }

    open func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false

        setTitle("Open Menu", for: .normal)
        setTitleColor(.systemGreen, for: .normal)
        menu = getContextMenu()
        showsMenuAsPrimaryAction = true
    }

    open func getContextMenu() -> UIMenu {
        .init(title: "菜单",
              children: [
                UIAction(title: "编辑", image: UIImage(systemName: "square.and.pencil")) { _ in
                    print("编辑按钮点击事件")
                },
                UIAction(title: "删除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    print("删除按钮点击事件")
                },
              ])
    }

    func layoutConstraints(in view: UIView) -> [NSLayoutConstraint] {
        [
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 44),
        ]
    }
}

class ViewController: UIViewController {

    weak var button: MenuButton!

    override func loadView() {
        super.loadView()

        // 初始化按钮
        let button = MenuButton()
        view.addSubview(button)
        self.button = button
        NSLayoutConstraint.activate(button.layoutConstraints(in: view))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
```

正如你所看到的，视图控制器中的代码被大量减少，大部分与按钮配置相关的逻辑现在被封装在`MenuButton`子类中。这种方法很好，因为你可以更少关注视图配置，多关注视图控制器中的业务逻辑。这也有助于你用可重用的组件来思考。

这里有一个补充说明，我倾向于通过代码创建我的接口，这就是为什么我用`@available(*, unavailable)`标记不必要的`init`方法，这样我团队中的其他人就不会意外地调用它们，但这只是个人偏好。



## 始终保持大的导航标题

我不知道你的情况，但对我来说，如果涉及到导航栏的大标题功能，所有的应用程序都会出现故障。对于个人项目，我已经厌倦了这种情况，我只是简单地强制大标题显示模式。这比较简单，下面是如何做的。

```swift
import UIKit

class TestNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    open func initialize() {
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        // custom tint color
        navigationBar.tintColor = .systemGreen
        // custom background color
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemBackground
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

class ViewController: UIViewController {

    weak var button: MenuButton!

    override func loadView() {
        super.loadView()

        // 如果我们添加了 scrollviews，这个技巧可以防止导航栏折叠
        view.addSubview(UIView(frame: .zero))

        // 添加其他子视图
    }
}
```

你只需要设置两个属性（你可以子类化`UINavigationController`或者在你的视图控制器中设置这些属性，但我更喜欢子类化），另外，如果你打算在视图控制器中使用`UIScrollView`、`UITableView`或`UICollectionView`，你必须在视图层次中添加一个空视图以防止折叠。

由于这个提示也是基于我的个人偏好，我还在片段中加入了一些自定义选项。如果你看一下初始化方法，你可以看到如何改变导航条的色调和背景颜色。👍



## 自定义导航栏和标签栏的分隔符

由于许多应用程序喜欢有一个定制的导航栏和标签栏的外观，所以当你不得不添加一个分隔线来区分用户界面元素的时候，这是一个相当普遍的做法。这就是你如何通过使用一个单条分隔线类来解决这个问题。

```swift
import UIKit 

class BarSeparator: UIView {
    
    let height: CGFloat = 0.3

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray4
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func layoutConstraints(for navigationBar: UINavigationBar) -> [NSLayoutConstraint] {
        [
            widthAnchor.constraint(equalTo: navigationBar.widthAnchor),
            heightAnchor.constraint(equalToConstant: CGFloat(height)),
            centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
        ]
    }
    
    func layoutConstraints(for tabBar: UITabBar) -> [NSLayoutConstraint] {
        [
            widthAnchor.constraint(equalTo: tabBar.widthAnchor),
            heightAnchor.constraint(equalToConstant: CGFloat(height)),
            centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            topAnchor.constraint(equalTo: tabBar.topAnchor),
        ]
    }
}

class MyNavigationController: UINavigationController {
    
   override func viewDidLoad() {
        super.viewDidLoad()
        
        let separator = BarSeparator()
        navigationBar.addSubview(separator)
        NSLayoutConstraint.activate(separator.layoutConstraints(for: navigationBar))
    }
}

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let separator = BarSeparator()
        tabBar.addSubview(separator)
        NSLayoutConstraint.activate(separator.layoutConstraints(for: tabBar))
    }   
}
```



这样你就可以重复使用 `BarSeparator` 组件，在导航栏的底部和标签栏的顶部添加一条线。这个片段遵循了我之前向你展示的完全相同的原则，所以你现在应该已经熟悉了子类的概念。



## 自定义 tab bar items

我在 tab bar item 图标的对齐方面做了很多努力，但这种方式可以让我轻松地显示/隐藏标题，并在没有标签的情况下将图标对齐到栏的中心。

```swift
import UIKit

class MyTabBarItem: UITabBarItem {
    
    override var title: String? {
        get { hideTitle ? nil : super.title }
        set { super.title = newValue }
    }
        
    private var hideTitle: Bool {
        true
    }

    private func offset(_ image: UIImage?) -> UIImage? {
        if hideTitle {
            return image?.withBaselineOffset(fromBottom: 12)
        }
        return image
    }
    
    // MARK: - init
    
    public convenience init(title: String?, image: UIImage?, selectedImage: UIImage?) {
        self.init()

        self.title = title
        self.image = offset(image)
        self.selectedImage = offset(selectedImage)
    }

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// inside some view controller init
tabBarItem = MyTabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
```

我还想说的是，[SF Symbols](https://developer.apple.com/sf-symbols/) 是令人惊叹的。如果你还没有使用这类图标，我强烈建议你看一看。苹果公司在这个系列中做得非常好，有这么多可爱的图标，你可以用来在视觉上丰富你的应用程序，所以不要错过了。



## loadView 与 viewDidLoad

长话短说，你应该总是在 `loadView` 方法中对你的视图进行实例化和放置约束，在 `viewDidLoad` 方法中配置你的视图。

我总是为自定义视图使用弱引用的隐式解包可选类型变量，因为 `addSubview` 函数会在视图被添加到视图层次结构中时为其创建一个强引用。我们不希望有保留循环，对吗？这对我们的应用来说是非常糟糕的。

```swift
import UIKit

class MyCollectionViewController: UIViewController {

    // 弱引用的隐式解包可选类型变量
    weak var collection: UICollectionView!

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.addSubview(UIView(frame: .zero))

        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        self.collection = collection
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.backgroundColor = .systemBackground
        collection.alwaysBounceVertical = true
        collection.dragInteractionEnabled = true
        collection.dragDelegate = self
        collection.dropDelegate = self

        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }

        collection.register(MyCell.self, forCellWithReuseIdentifier: MyCell.identifier)
    }
}
```

总之，我也会为集合视图创建一个自定义的子类，也许会定义一个配置方法，然后调用该方法，而不是直接将所有东西放在控制器中。决定权在你手中，我只是想告诉你一些可能的解决方案。😉



## 堆栈视图和自动布局锚点

尽可能地利用堆栈视图和自动布局锚点。如果你打算在 Swift 中借助 UIKit 以编程方式创建用户界面，那么掌握这些技术将是一项基本技能，否则你将会非常吃力。

我已经有一篇关于[以编程方式使用自动布局](https://theswiftdev.com/ios-auto-layout-tutorial-programmatically/)的教程，还有一篇关于[掌握自动布局锚点](https://theswiftdev.com/mastering-ios-auto-layout-anchors-programmatically-from-swift/)的教程，它们是几年前发表的，但这些概念仍然有效，代码仍然有效。我还有一篇文章，如果你想学习[使用堆栈视图构建表单](https://theswiftdev.com/custom-views-input-forms-and-mistakes/)，你应该读一读。学习这些东西对我创建复杂的屏幕有很大的帮助，让我无忧无虑。我还[使用了一个 "最佳实践 "来创建集合视图](https://theswiftdev.com/ultimate-uicollectionview-guide-with-ios-examples-written-in-swift/)。

当 SwiftUI 出来的时候，我有种感觉，最终我会用 UIKit 做同样的事情，当然，苹果有必要的工具，用视图构建器和属性包装器来支持这个框架。现在我们有了 SwiftUI，我仍然没有使用它，因为我觉得它即使在 2022 年也缺乏相当多的功能。我知道它很好，我已经用它创建了几个屏幕原型，但如果涉及到一个复杂的应用程序，我的直觉告诉我，我还是应该使用UIKit。🤐



## 创建一个可重复使用的组件库

我在本教程中的最后一个建议是，你应该建立一个自定义的 Swift 包，并将你的所有组件移到那里。也许第一次会耗费很多时间，但如果你正在做多个项目，它会加快你第二个、第三个等应用程序的开发进程。

你可以把你所有的自定义基类移到一个单独的库中，并为你的应用程序创建特定的基类。你只需要将它们标记为 `open`，你可以使用 availability API 来管理哪些可以使用，哪些应该被标记为不可用。

我在博客上有不少关于[Swift 包管理器的教程](https://theswiftdev.com/swift-package-manager-tutorial/)，这是一个熟悉它的好方法，你可以开始一步步地建立你自己的库。😊



谢谢🙏





























