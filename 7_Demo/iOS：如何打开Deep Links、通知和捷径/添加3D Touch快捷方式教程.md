> 原文：[Add 3D Touch quick actions tutorial](https://the-nerd.be/2015/09/30/add-3d-touch-quick-actions-tutorial/)
>
> 源码：<https://github.com/frederik-jacques/quick-actions-3d-touch-tutorial>


随着 iPhone 6S（plus）的推出，苹果在其屏幕上增加了一个压力感应层。这为创建应用程序创造了一堆新的用户体验可能性。我们有可能在一个应用程序的图标上用力按压，并获得快捷方式，将你带到应用程序中的特定页面。例如，如果你按下 "照片" 应用图标，你可以快速搜索图片，查看最近的图片或查看你的收藏夹。还可以使这些快速动作成为动态的，这意味着你可以根据你的应用程序的状态添加和删除动作。

<img src="https://i1.wp.com/www.the-nerd.be/wp-content/uploads/2015/09/3d-touch-example.jpg" style="zoom:50%;" />


在本教程中，我将向你展示如何将这些快捷方式添加到你的应用程序图标中。

## 在 Info.plist 中定义动作

当你按下你的应用程序图标时，不同的选项是在你的 `info.plist` 文件中定义的。

首先，你需要在你的 plist 文件中创建一个新的行，给它一个 `UIApplicationShortcutItems` 的 *key*，并将类型设置为 *Array* 数组类型。现在你可以为每个快捷方式设置一个 *Dictionary*。

选择你刚刚创建的行，并在数组中添加一个新行，将类型设为 *Dictionary*。

在这个字典里，你必须添加具有特定键和值的行。你可以从以下选项中选择。名字前面有 `*` 的是必须项。

* `* UIApplicationShortcutItemType`：一个唯一字符串，你选择在你的应用程序中识别哪个动作必须被触发。例如 *be.thenerd.my-app.create-user*。
* `* UIApplicationShortcutItemTitle`：用户可以看到的字符串。如果该字符串太长，如果没有设置副标题，它将被包裹在2行上（见下一个 key）。如果设置了副标题，该字符串将被截断。
* `UIApplicationShortcutItemSubtitle`: 可选项，在标题下面显示给用户的字符串。
* `UIApplicationShortcutItemIconType`：可选项，你可以使用系统定义的图标（key的列表可以在[这里](https://developer.apple.com/documentation/uikit/uiapplicationshortcuticon#//apple_ref/c/tdef/UIApplicationShortcutIconType)找到）。
* `UIApplicationShortcutItemIconFile`: 可选项，你的应用程序 bundle 或 assets catalog 资产目录中的图像文件的名称。创建你的自定义图标文件的模板文件可以在这里找到。
* `UIApplicationShortcutItemUserInfo`: 可选项，一个包含你想使用的自定义数据的 *Dictionary*。

```xml
<array>
    <dict>
        <key>UIApplicationShortcutItemIconType</key>
        <string>UIApplicationShortcutIconTypeAdd</string>
        <key>UIApplicationShortcutItemTitle</key>
        <string>Create new user</string>
        <key>UIApplicationShortcutItemType</key>
        <string>be.thenerd.appshortcut.new-user</string>
        <key>UIApplicationShortcutItemUserInfo</key>
            <dict>
             <key>name</key>
             <string>Frederik</string>
            </dict>
    </dict>
</array>
```

```xml
<key>UIApplicationShortcutItems</key>
<array>
  <dict>
    <key>UIApplicationShortcutItemType</key>
    <string>com.mycompany.myapp.newuser</string>
    <key>UIApplicationShortcutItemTitle</key>
    <string>创建新用户</string>
    <key>UIApplicationShortcutItemIconType</key>
    <string>UIApplicationShortcutIconTypeAdd</string>
    <key>UIApplicationShortcutItemUserInfo</key>
    <dict>
      <key>name</key>
      <string>Frederik</string>
    </dict>
  </dict>
</array>
```

这将给你带来以下结果：

<img src="https://i0.wp.com/www.the-nerd.be/wp-content/uploads/2015/09/appshortcuts-create-new-user.jpg" style="zoom:50%;" />



## 获得选择通知


好吧，那么当用户选择一个快捷方式时，我们如何得到通知？选择之后，`application:performActionForShortcutItem:completionHandler` 方法被调用。在你的`AppDelegate` 文件中实现这个方法。

```swift
// Home 主屏幕上的快捷方式被点击时调用
func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    print("Shortcut tapped")
}
```

```swift
// Home 主屏幕上的快捷方式被点击时调用
func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    print("Shortcut tapped")
}
```

如果你点击了这个快捷方式，你会看到在你的控制台中弹出这个信息。但是我们怎么知道哪个快捷方式被点了呢？

这个方法有3个参数：

* **application**: 一个对共享的 `UIApplication` 实例的引用
* **shortcutItem**：对 `UIApplicationShortcutItem` 对象的引用。
* **completionHandler**：当你的快捷方式代码完成时被执行的一个闭包。

记得你已经指定了`UIApplicationShortcutItemType`键吗？通过这个唯一字符串，你可以检查你要运行的动作。要访问这个字符串，你只需从 `shortcutItem` 参数中获取 `type` 属性的值。



创建一个包含所有可能值的枚举也许是个好主意，这样你就不会犯任何拼写错误了。我将创建一个 `handleShortcut:shortcutItem` 方法，在这个方法中你可以检查它是什么类型，并返回一个动作成功与否的布尔值。你需要这个，因为`application:performActionForShortcutItem:completionHandler:` 方法要求你通过`completionHandler`参数返回一个布尔值：

```swift
// Home 主屏幕上的快捷方式被点击时调用
func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {

    print("Function: \(#function), line: \(#line)")
    completionHandler(handleShortcut(shortcutItem: shortcutItem))
}

func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
    print("Shortcut tapped")

    var succeeded = false
    if shortcutItem.type == "com.mycompany.myapp.newuser" {
        // Add your code here
        print("- Handling \(shortcutItem.type)")
        succeeded = true
    }

    return succeeded
}
```



## One more thing

有一个注意事项......启动你的应用程序和从非活动状态到活动状态之间是有区别的。

这意味着你有责任确保 `application:performActionForShortcutItem:completionHandler:` 被有条件地调用，例如 `application:didFinishLaunchingWithOptions:` 已经处理了该应用程序的快捷方式。

那么我们怎样才能做到这一点呢？

我们将在 `application:didFinishLaunchingWithOptions:` 中使用一个布尔值来检查我们是否需要调用 `application:performActionForShortcutItem:completionHandler:`。

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
  var performShortcutDelegate = true

  ...

}
```

现在我们要检查 `UIApplicationLaunchOptionsShortcutItemKey` 是否在 `launchOptions` 字典参数中可用。    如果是这样，我们将把`UIApplicationShortcutItem`的实例存储在一个属性中，这样我们以后就可以引用它，并把我们的布尔值设置为`false`，因为我们不希望`application:performActionForShortcutItem:completionHandler:`被再次调用。

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shortcutItem: UIApplicationShortcutItem?

...
}
```



```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    print("Application did finish launching with options")

    var performShortcutDelegate = true
    
    if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
        
        print("Application launched via shortcut")
        self.shortcutItem = shortcutItem
        
        performShortcutDelegate = false
    }
    
    return performShortcutDelegate
    
}
```

现在我们可以安全地实现 `applicationDidBecomeActive:` 并检查快捷键属性是否已经被设置。如果是的话，该应用程序就不是来自于后台状态。

```swift
func applicationDidBecomeActive(application: UIApplication) {
    print("Application did become active")
        
    guard let shortcut = shortcutItem else { return }
        
    print("- Shortcut property has been set")
        
    handleShortcut(shortcut)
        
    self.shortcutItem = nil
        
}
```

就是这样了。
