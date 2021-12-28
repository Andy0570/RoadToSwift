### 1. 使用 `hasAmbiguousLayout` 方法

在视图控制器的 `viewDidLayoutSubviews` 方法中添加以下代码：

```objectivec
- (void)viewDidLayoutSubviews {
    for (UIView *subview in self.view.subviews) {
        // MARK: 检查是否存在有歧义布局的子视图
        if ([subview hasAmbiguousLayout]) {
            NSLog(@"AMBIGUOUS:%@", subview);
            // MARK: 以下方法可以查看自动布局系统在有歧义布局情况下的各种布局效果
            [subview exerciseAmbiguityInLayout];
        }
    }
}
```

说明：通过遍历视图控制器下的子视图并依次发送 `hasAmbiguousLayout` 消息的方式来查找有歧义布局的视图。此方法适合**遍历视图控制器下的一级子视图**。


### 2. 使用 `_autolayoutTrance` 方法

`_autolayoutTrance` 方法是 `UIWindow` 的私有实例方法，该方法返回一个表示 `UIWindow` 中整个视图层次结构的字符串。对于有歧义布局的视图，`_autolayoutTrance` 会使用 **AMBIGUOUS LAYOUT**（有歧义的布局）标记出来。

使用方式：

1. 在视图控制器的 `viewWillAppear:` 方法中设置一个断点。
2. 当程序在断点处停下来之后，在控制台输入：

```bash
(lldb) po [[UIWindow keyWindow] _autolayoutTrance]
```

如果应用界面与期望的布局方式不一致，同时也无法确定问题原因，就可以使用该方法找出有歧义布局的视图。

### 3. 添加 Symbolic Breakpoint 断点

1. 添加 Symbolic Breakpoint 断点，将 **Symbol** 属性设置为： `UIViewAlertForUnsatisfiableConstraints`;
2. Action 设置：

Objective-C 项目：
```bash
po [[UIWindow keyWindow] _autolayoutTrace]
```
![](https://upload-images.jianshu.io/upload_images/2648731-3785df1fa94af722.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Swift 项目：
```bash
expr -l objc++ -O -- [[UIWindow keyWindow] _autolayoutTrace]
```

显示自动布局存在问题的视图
```bash
expr ((UIView *)0x7f88a8cc2050).backgroundColor = [UIColor redColor]
```

参考：<https://stackoverflow.com/questions/26389273/how-to-trap-on-uiviewalertforunsatisfiableconstraints>
