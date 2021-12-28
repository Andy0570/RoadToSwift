## 通过 Auto Layout 视觉格式化语言（Visual Format Language，VFL）添加自动布局约束



在视图控制器上添加5个 `UILabel`：

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        // iOS 默认会基于视图的尺寸和大小自动为你生成自动布局约束
        // 但我们等会要手动添加这些约束，所以需要禁用该特性
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
    }
```



设置5个`UILabel`水平方向上从左到右填充整个屏幕：

```swift
let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]

// 水平方向上，每个标签都应该在我们的视图中从边缘延伸到边缘。
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label1]|", options: [], metrics: nil, views: viewsDictionary))
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label2]|", options: [], metrics: nil, views: viewsDictionary))
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label3]|", options: [], metrics: nil, views: viewsDictionary))
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label4]|", options: [], metrics: nil, views: viewsDictionary))
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label5]|", options: [], metrics: nil, views: viewsDictionary))
```

水平方向上的布局代码，可以通过 `for` 循环语句优化：

```swift
let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]

for label in viewsDictionary.keys {
    // H 表示水平方向，V 表示垂直方向。| 表示屏幕边缘。
    // "H:|[label1]|" 意味着 "在水平方向上，我希望我的 label1 在我的视图中的布局从左边缘到右边缘。"
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
}

// - 表示视图元素之间的 space，默认值为 10 point
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[label1]-[label2]-[label3]-[label4]-[label5]", options: [], metrics: nil, views: viewsDictionary))
```

* `view.addConstraints()`: 为我们的视图控制器的视图添加一个约束数组。使用这个数组而不是单个约束，是因为VFL可以一次生成多个约束。
* `NSLayoutConstraint.constraints(withVisualFormat:)` 是自动布局方法，它将 VFL 转换为一个约束数组。它接受很多参数，但重要的参数是第一个和最后一个。
* 我们为 `options` 参数传递 `[]`（一个空数组），为 `metrics` 参数传递 `nil`。你可以使用这些选项来定制 VFL 的含义，但现在我们并不关心。



<img src="https://s2.loli.net/2021/12/27/8IQ3LYTaiwFesHp.png" alt="screenshot01" style="zoom:50%;" />

---

```swift
// 垂直方向上：
// label 与 label 之间的间距默认为 10；-
// 每个 label 的高度是 88；(==88)
// 第一个 label 与顶部的距离固定为 40；|-40-
// 最后一个 label 与底部的距离大于 10；-(>=10)-|
view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[label1(==88)]-[label2(==88)]-[label3(==88)]-[label4(==88)]-[label5(==88)]-(>=10)-|", options: [], metrics: nil, views: viewsDictionary))
```

<img src="https://s2.loli.net/2021/12/27/PedY3blqXMCIhy7.png" alt="screenshot02" style="zoom:50%;" />

---

### 优化：把 `==88` 写到 metrics 数组中，而不用把具体的数值硬编码到 VFL 语句中。

```swift
let metrics = ["labelHeight": 88]

view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[label1(labelHeight)]-[label2(labelHeight)]-[label3(labelHeight)]-[label4(labelHeight)]-[label5(labelHeight)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
```

---

### 优化：适配 iPhone 横屏模式，降低 label 的高度优先级，同时设置所有 label 的高度一致

```swift
let metrics = ["labelHeight": 88]

view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
```

![screenshot03](https://s2.loli.net/2021/12/27/TQBqtPnerL7K8E1.png)

---

### Auto Layout Anchors

你已经看到了如何在 Interface Builder 和使用 Visual Format Language 来创建自动布局约束，但还有一个选择是开放给你的，它往往是最好的选择。

每个 `UIView` 都有一组锚点来定义其布局规则。最重要的是 `widthAnchor`, `heightAnchor`, `topAnchor`, `bottomAnchor`, `leftAnchor`, `rightAnchor`, `leadingAnchor`, `trailingAnchor`, `centerXAnchor`, and `centerYAnchor`。

其中大部分应该是不言自明的，但值得澄清的是，`leftAnchor`、`rightAnchor`、`leadingAnchor`和`trailingAnchor`之间的区别。对我来说，left 和 leading 是一样的，right 和 trailing 也是一样的。这是因为我的设备被设置为使用英语，而英语是从左到右书写和阅读的。然而，对于从右到左的语言，如**希伯来语**和**阿拉伯语**，leading 和 trailing 是颠倒的，所以leading 等于 right，trailing 等于 left。

在实践中，这意味着如果你想让你的用户界面在从右到左的语言中翻转，就使用`leadingAnchor`和`trailingAnchor`，而对于那些无论在什么环境下都应该看起来一样的东西，就使用`leftAnchor`和`rightAnchor`。

使用锚点的最好的一点是，它们可以相对于其他锚点创建。也就是说，你可以说 "这个标签的宽度锚等于它的容器的宽度"，或者 "这个按钮的顶部锚等于其他按钮的底部锚"。

```swift
var previous: UILabel?

for label in [label1, label2, label3, label4, label5] {
    // 每个 label 的宽度 = 当前视图的宽度
    label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    // 每个 label 的高度 = 88
    label.heightAnchor.constraint(equalToConstant: 88).isActive = true

    // label.topAnchor = previous.bottomAnchor + 10
    if let previous = previous {
        label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
    } else {
        // 让第一个 Label 相对于 Safe Area 布局
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }

    previous = label
}
```

<img src="https://s2.loli.net/2021/12/27/Y2sHeniIa4WOSKx.png" alt="screenshot04" style="zoom:50%;" />





