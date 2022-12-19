> Reference: [Reduce Xcode Build Time for iOS](https://blog.devgenius.io/reduce-xcode-build-time-for-ios-bf43d3ca4ab8)



### 将应用程序拆分为模块

将 App 拆分为模块的好处不仅是减少编译时间，而且还可以在其他项目中重用这些模块，只需导入它们，而不是每次需要时都进行复制 / 粘贴。



### 删除不必要的 Pod



### 使用 Private IBOutlets (Swift)

当你创建一个新的 `UIViewController` 并且你有一些像 `UIButton` 或 `UILabel` 这样的 `IBOutlet` 时，你应该将它们设为 `private`（默认情况下它们是 `public`）。在大多数情况下，插座不会在其他类中使用，而只会在您各自的 `UIViewController` 中使用。拥有较少的 `public` 对象可以减少您的编译时间。



### 从 .h 文件中删除不必要的 Header（仅适用于 Objective-C）

当你的项目在 Objective-C 中开发时，你需要将 .h 文件导入到 .m 文件中以导入你需要的对象，但通常它会导入比你真正需要的更多的东西。例如，不要在 .h 文件中声明您的 `IBOutlets`，而是使用 .m 代替（它只会为该文件编译它）。也不要在 .h 文件中添加只有 .m 文件需要的任何属性。



### 删除未使用的文件

尝试删除所有不再需要的文件。这些文件可能是未使用的类、旧资产（不再使用的图像）或您不再使用的遗忘功能。



### 添加 SwiftLint



### 禁用 DSYM 生成

这仅适用于模拟器构建。您需要更改模拟器 SDK（project 和 pod）的设置，并且只输出 dwarf。



### Swift Extensions

当你创建一个新的扩展时，它默认是 `public` 的。这会增加编译时间，因为它应该 / 可以被每个 swift 类使用。避免创建仅在代码的一部分中使用它们的扩展。虽然您可以创建扩展，但最好将其声明为 `private` 到您应该使用它的文件中。



### 指定类型

如果你不这样做，编译器应该为你做，它会增加编译时间。例如，如果您有一个浮点数，请执行以下操作：

```swift
let number = 10
let number: CGFloat = 10
```



### Storyboards

避免使用包含大量 `UIViewController` 的 storyboards。取而代之的是，您可以尝试为每个 “story” 创建一个新的storyboard。例如，如果您的应用程序具有注册流程、登录和仪表板，您可以将它们拆分为 3 个不同的 storyboard。



### 使用代码而不是 Storyboard 或 xib

并不总是一个好的做法，因为如果您在代码中而不是在 Storyboard 中看到它们可能会更难以理解 UI，但是对于非常简单的 UI（例如只有一个 webview 的视图控制器），您可以这样做它只是来自代码，而不是仅为 UI 创建一个新文件。

