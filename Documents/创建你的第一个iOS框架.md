> 参考：[Creating your first iOS Framework @20190323](https://thoughtbot.com/blog/creating-your-first-ios-framework)

如果你曾经尝试过创建自己的 iOS 框架，你就会知道这并不适合胆小的人 -- 管理依赖关系和编写测试并不会让它变得简单。本教程将指导你从头到尾创建你的第一个 iOS 框架，这样你就可以出去创建自己的框架了。

我们将创建一个框架，暴露一个名为 `RGBUIColor(red:green:blue)` 的函数，返回一个由这些值创建的新 `UIColor`。我们将使用 Swift 构建它，使用 Carthage 作为我们的依赖管理器。我们的框架将可以使用 Carthage、CocoaPods 或 git 子模块来消费。

让我们开始吧！

## 设置 Xcode 项目

* 选择 File → New → Project。
* 从左边的侧边栏选择 "iOS → Framework & Library"，在右边选择 "Cocoa Touch Library"。
* 点击 "Next" 并填写选项提示。确保选择 "Include Unit Tests" 复选框。

![](https://images.thoughtbot.com/creating-your-first-ios-framework/CFo5I571SMWDTllrhfQW_Project%20Options.png)

* 选择你想保存你的项目的地方。
* 取消勾选 "Create Git repository on My Mac"，我们稍后会手动设置它。
* 点击 "Create"，该项目将在 Xcode 中打开。
* 进入 "File → Save As Workspace"，将其保存在与 Xcode 项目相同的目录下，并使用相同的名称。我们把项目放在一个工作区，因为我们将把 Carthage 的依赖性作为子模块加入；它们必须在一个工作区，以便 Xcode 构建它们。
* 用 File → Close Project 关闭 Xcode 项目。
* 用 File → Open 打开 workspace。
* 点击 Xcode 左上方的 scheme，选择 "Manage Schemes"。我们需要将我们的方案标记为 "共享"，这样该项目就可以用 Carthage 来构建。
* 找到 "RGB" 方案并勾选 "共享" 复选框，然后点击 "关闭"。

![](https://images.thoughtbot.com/creating-your-first-ios-framework/J1T3GfyKSBed3XmQDMZR_Manage%20Schemes.png)

让我们跳转到 Terminal。

## 初始化 Git

首先，导航到你保存项目的目录。

* 运行 `git init` 来初始化一个空仓库。
* 创建一个 `.gitignore` 文件，它将阻止一些讨厌的 Xcode 和依赖性文件，我们不想在 git 中跟踪。
* 这里有一个用于 Swift 项目的 [标准 .gitignore 文件模版](https://github.com/github/gitignore/blob/main/Swift.gitignore)，并做了一些修改。我们添加了 `.DS_Store` 并删除了 fastlane 和额外的注释。

```bash
## OS X Finder
.DS_Store

## Build generated
build/
DerivedData

## Various settings
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata

## Other
*.xccheckout
*.moved-aside
*.xcuserstate
*.xcscmblueprint

## Obj-C/Swift specific
*.hmap
*.ipa

# Swift Package Manager
.build/

# Carthage
Carthage/Build
```

## 添加 Carthage 和依赖关系

* 在你的项目目录下创建一个名为 Cartfile 的文件，并将运行时的依赖关系加入其中。我们将添加 [Curry](https://github.com/thoughtbot/Curry)。

```bash
github "thoughtbot/Curry"
```

* 创建一个 `Cartfile.private`。它将容纳像我们的测试框架一样的私有依赖。我们将使用 [Quick](https://github.com/Quick/Quick) 和 [Nimble](https://github.com/Quick/Nimble)。

```bash
github "Quick/Quick"
github "Quick/Nimble"
```

* 创建一个 `bin/setup` 脚本。它是用来给我们的贡献者（和我们）一个简单的方法来设置项目和依赖关系。


```bash
mkdir bin
touch bin/setup
chmod +x bin/setup
```

* 打开 `bin/setup`，并填入以下内容。

```bash
#!/usr/bin/env sh

if ! command -v carthage > /dev/null; then
  printf 'Carthage is not installed.\n'
  printf 'See https://github.com/Carthage/Carthage for install instructions.\n'
  exit 1
fi

carthage update --platform iOS --use-submodules --no-use-binaries
```

在这个脚本中，我们确保用户已经安装了 [Carthage](https://github.com/Carthage/Carthage)，并运行其更新命令来安装 iOS 的依赖项。

我们使用 `--use-submodules`，这样我们的依赖就会作为子模块加入。这允许用户在 Carthage 之外使用我们的框架，如果他们愿意的话。我们使用 `--no-use-binaries`，这样我们的依赖项就会在我们的系统上构建。

创建了 `bin/setup` 后，让我们运行它，这样 Carthage 就会下载我们的依赖项。


* 在终端，运行 `bin/setup`。


现在我们需要设置我们的项目来构建和链接新的依赖项。



## 将依赖项添加到工作区

由于我们的依赖项是子模块，我们需要将它们添加到我们的工作空间。

* 打开 `Carthage/Checkouts`，将每个依赖项的.xcodeproj 添加到工作区的根部。它们可以从 Finder 拖到 Xcode 项目的导航器中。


当你完成后，它应该看起来像：

![](https://images.thoughtbot.com/creating-your-first-ios-framework/rBQNmPf2QiOkafIz30XK_Add%20Subprojects.png)

### 链接运行时的依赖性

* 在导航器中选择 "RGB"，在中间的侧边栏中选择 "RGB" 目标，选择 "构建阶段" 标签并展开 "用库链接二进制" 部分。
* 点击 "+" 图标，选择 Curry-iOS 目标中的 Curry.framework。
* 点击 "Add"。

![](https://images.thoughtbot.com/creating-your-first-ios-framework/rqymaJQ9Rua4r6RmBEjW_select-framework.png)

## 链接开发依赖性

* 从中间的侧边栏选择 "RGBTests" 目标。
* 使用与之前相同的过程，将 Quick 和 Nimble 框架添加到此目标的 "与库链接二进制" 部分。
* 当添加依赖关系到每个目标时，Xcode 将自动把它们添加到 "构建设置" 标签下的 "框架搜索路径" 中。我们可以从 "RGB" 和 "RGBTests" 目标中删除这些，因为 Xcode 将它们视为隐含的依赖关系，因为它们在同一个工作区。
* 选择目标，找到 "框架搜索路径" 设置，将其突出显示，并按键盘上的 "退格" 键。

![](https://images.thoughtbot.com/creating-your-first-ios-framework/fXCR3yrrRrGRkTZsXEOW_Search%20Paths.png)

* 接下来，在导航器中查看 "RGB" 项目；你会看到在根层有三个新框架。为了保持这个区域的有序性，突出显示所有三个，右击并选择 "从选择中新建组"，将它们放在一个命名的组中。我把我的称为 "框架"。

现在 Carthage 已经设置好了，让我们来添加 CocoaPods。

## 添加 CocoaPods 支持


...





