> 原文：[Getting Started with Tuist](https://sarunw.com/posts/getting-started-with-tuist/)

## What is Tuist

Tuist 是一个命令行工具，可帮助您生成、维护 Xcode 项目并与之交互。它是开源的，用 Swift 编写。

以上含义来自他们的 Github repo，但 Tuist 到底是什么？

### 真相的来源

在处理 iOS 项目时，Xcode 项目 (.xcodeproj) 是我们的真实来源。它包含有关我们的源代码以及它们如何链接在一起的信息。我们可以轻松地创建一个新的测试目标、一个新的框架，并通过 Xcode 用户界面将所有内容链接在一起。

通过 Xcode 交互和管理我们的项目很容易，而且没有任何问题。当你开始作为一个团队工作时，问题就来了。 Xcode 项目非常脆弱。即使是打开 Storyboard 或移动文件等最轻微的更改也可能导致 Xcode 项目 (.xcproject) 发生更改，最终导致合并冲突。

这就是 Tuist 发挥作用的地方。 Tuist 帮助我们收回对项目的控制权。 Tuist 没有将 Xcode 项目视为事实来源并希望它能做正确的事情，而是将我们的文件系统和 Tuist 的清单文件（定义依赖关系）视为事实来源。然后它会从中生成一个 Xcode 项目。



![思考项目真相来源的不同方式*](https://d33wubrfki0l68.cloudfront.net/396fe5d769f1ebad51875d366a067bb78014bc21/dec2b/images/getting-started-tuist-diagram.png)

您可能想知道清单文件是什么样的，以及从该文件管理项目有多难。让我们自己看看。



## 安装

首先，让我们安装 Tuist。打开终端并输入此命令。

```bash
curl -Ls https://install.tuist.io | bash
```

然后尝试运行 tuist 命令，如果您还没有 Tuist，它将为您安装。设置好工具后，让我们创建您的第一个项目。

## 创建我们的第一个项目

让我们创建一个新的项目文件夹来使用。我称它为 “MyApp”。

```
mkdir MyApp
cd MyApp
```

> `mkdir` (Make Directory) 是一个创建新文件夹的命令。 `cd`（Change Directory）是更改目录的命令。

### Project.swift

然后创建一个 Project.swift 文件。 Project.swift 文件是一个清单文件，其中包含我们项目的元数据。这是 Tuist 了解我们希望我们的项目如何的说明。

创建一个名为 Project.swift 的新文件，然后运行 `tuist edit`，这将打开一个包含所有项目清单和项目助手的临时 Xcode 项目，因此您将能够在 Xcode 自动更正的帮助下编辑清单。

```bash
tuist edit
```

下面的代码片段是我们的项目清单：

```swift
import ProjectDescription // <1>

let project = Project(
    name: "MyApp",
    targets: [
        Target(
            name: "MyApp",
            platform: .iOS,
            product: .app,
            bundleId: "com.sarunw.myapp",
            infoPlist: .default,
            sources: [
                "Sources/**"
            ],
            resources: [
                "Resources/**"
            ]
        )
    ]
)
```

ProjectDescription 框架定义了所有 Xcode 项目相关的模型。

完成编辑后，在终端中按 CTRL + C。

由于我们正在定义一个 Xcode 项目，因此您可能对大多数属性都很熟悉。您可以查看项目参考以查看 ProjectDescription 框架中的所有可用属性。仅有的两个必填字段是 `name` 和 `target`。

Tuist 并没有神奇地为我们创建源文件和文件夹。我们必须手动完成。我们需要创建清单文件引用的文件、Sources 和 Resources。例如，我将创建一个 SwiftUI 项目，因为它需要更少的样板文件和设置。 SwiftUI 需要一个文件（主 App），而 UIKit 需要两个（AppDelegate 和 SceneDelegate）。

当我说 “Tuist 不会神奇地为我们创建源文件和文件夹” 时，我对你撒了谎。 Tuist 可以为您生成一些帮助程序，甚至 Info.plist，但我想强调的是，您应该是创建您的事实来源（项目结构和源文件）的人。

### 文件结构：文件夹和源代码

创建两个文件夹来托管我们的文件。

```bash
mkdir Sources
mkdir Resources
```

然后我创建了两个 Swift 文件，`MainApp.swift` 和 `ContentView.swift`，并将它们放在 `Sources` 下。这两个文件的内容你应该很熟悉，因为当我们从 Xcode 创建一个新项目时，我从 Xcode 样板中复制了它们。

**MainApp.swift**

```swift
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

**ContentView**

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

### 资源

我还将自定义字体 ObjectSans-Bold.otf 放在 Resources 文件夹中以进行演示。

我在这里放了一个自定义字体来展示 Tuist 如何为我们生成一个辅助函数。在这种情况下，Fonts+MyApp.swift 文件。

这就是我们需要做的。我们已经建立了我们的真相来源。让我们看看如何从这些文件中生成 Xcode 项目。

## 生成项目

清单和项目文件是 Tuist 唯一需要的东西。要从中生成 Xcode 项目，请运行以下命令：

```bash
tuist generate
```

我们将获得一个 MyApp.xcodeproj 和 MyApp.xcworkspace 文件。如果您打开 MyApp.xcworkspace 并尝试运行 MyApp 方案，它应该构建应用程序并在模拟器上运行它📱。

每次更改 Project.swift 时，都需要使用 tuist generate 重新生成项目。重新生成项目并手动打开它会很快变得烦人。幸运的是，Tuist 有一个命令。

```bash
tuist generate -O
tuist generate --open
```

这两个都会生成项目并立即打开它。

我建议您在运行 `tuist generate` 之前关闭您的项目。如果您在打开项目时运行它，它可能会出现问题。

这是当前的文件结构：

```bash
Derived
  - InfoPlists
    - MyApp.plist
  - Sources
    - Bundle+MyApp.swift
    - Fonts+MyApp.swift
MyApp.xcodeproj
MyApp.xcworkspace
Resources
  - ObjectSans-Bold.otf
Sources
  - ContentView.swift
  - MainApp.swift
Project.swift
```

Tuist 在 Derived 文件夹下生成所有内容。您不应该修改这些文件，因为它们将在您的 .gitignore 中，并且可以随时被 tuist generate 覆盖。

运行应用程序，您将看到以下内容：

<img src="https://d33wubrfki0l68.cloudfront.net/25b5c556519b42a3dfd87db293ce4e41a7d49cc1/3fc79/images/getting-started-tuist-first.png" style="zoom:50%;" />

看起来生成的 Info.plist 缺少一些键。让我们补充一下。

## 修改 Info.plist

Xcode 需要一个启动屏幕作为应用程序是否支持大屏幕尺寸的指标。我们生成的 Info.plist 不包含任何此键。为了解决这个问题，我们需要添加一个新的字典键，UILaunchScreen。

由于我们使用 Tuist 生成的 Info.plist，我们不应该直接从 Xcode 修改我们的 Info.plist。我们应该做的是从我们的真实来源 Project.swift 修改它

运行 tuist edit 并将我们的清单修改为：

```swift
import ProjectDescription

let infoPlist: [String: InfoPlist.Value] = [ // <1>
    "UILaunchScreen": [:]
]

let project = Project(
    name: "MyApp",
    targets: [
        Target(
            name: "MyApp",
            platform: .iOS,
            product: .app,
            bundleId: "com.sarunw.myapp",
            infoPlist: .extendingDefault(with: infoPlist), // <2>
            sources: [
                "Sources/**"
            ],
            resources: [
                "Resources/**"
            ]
        )
    ]
)
```

<1> 我们声明了一个新的 Info plist 值。

<2> 我们将 infoPlist 从 .default 更改为 .extendingDefault (with: infoPlist)，这允许我们覆盖默认 info plist 中的值。

再次运行 tuist generate，您应该会在 Info.plist 中看到新密钥。

![](https://d33wubrfki0l68.cloudfront.net/20177d97635e21e5b597b90e44bd1b47fe1a503b/13ee4/images/getting-started-tuist-launch-screen.png)

运行应用程序，一切正常。

<img src="https://d33wubrfki0l68.cloudfront.net/06beccf306a16ffabd0f745186aefbd526ae1d1d/6abb2/images/getting-started-tuist-fixed.png" style="zoom:50%;" />



## 完全控制我们的 Info.plist

如果您想完全控制您的信息列表，您也可以这样做。

1. 创建或移动您的 info plist 文件到 Derived 文件夹之外的某个位置。就我而言，我将其移至根目录。

   ```
   Resources
     - ObjectSans-Bold.otf
   Sources
     - ContentView.swift
     - MainApp.swift
   Project.swift
   MyApp.plist
   ```

2. 运行 tuist edit 并告诉 Tuist 使用我们的 Info.plist 而不是生成一个。我们通过修改 infoPlist 键来做到这一点。

   ```swift
   import ProjectDescription
   
   let project = Project(
       name: "MyApp",
       targets: [
           Target(
               name: "MyApp",
               platform: .iOS,
               product: .app,
               bundleId: "com.sarunw.myapp",
               infoPlist: "MyApp.plist", // <1>我们将 infoPlist 指向我们的 info plist。
               sources: [
                   "Sources/**"
               ],
               resources: [
                   "Resources/**"
               ]
           )
       ]
   )
   ```

3. 运行 tuist generate，这就是我们得到的。如您所见，InfoPlists/MyApp.plist 已从 Derived 文件夹中消失。您现在负责管理信息列表。

   ```
   Derived
     - Sources
       - Bundle+MyApp.swift
       - Fonts+MyApp.swift
   MyApp.xcodeproj
   MyApp.xcworkspace
   Resources
     - ObjectSans-Bold.otf
   Sources
     - ContentView.swift
     - MainApp.swift
   Project.swift
   MyApp.plist
   ```



## 结论

本文重点介绍一种非常基本的方法，我们使用 Tuist 从头开始创建 iOS 项目。我想表明使用 Tuist 开始管理 Xcode 项目并不难。

使用 Tuist 生成 Xcode 项目的主要好处是不再有合并冲突，因为我们会将 .xcodeproj 放在我们的 .gitignore 中。在这一点上我不能多说其他好处（因为我也是这个工具的新手），但据我所知，它可以使团队之间的项目分离更容易。

我仍在探索这个工具，看看它有什么能力。我的第一印象是我有点喜欢它，你可以期待我发布更多关于这个工具的帖子。