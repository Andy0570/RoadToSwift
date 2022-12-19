> 原文：[Creating a Framework for iOS](https://www.raywenderlich.com/17753301-creating-a-framework-for-ios)



框架是独立的、可重复使用的代码和资源，并且可以将其导入到许多应用程序中。

框架有三个主要目的：封装代码、模块化代码、重用代码。

[Apple: What are Frameworks?](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html)

[Swift Package Manager for iOS](https://www.raywenderlich.com/7242045-swift-package-manager-for-ios)



通过命令行归档框架：

```bash
cd /Users/huqilin/Desktop/CreateFrameworkForiOS/starter/2-Framework/CalendarControl

# Target iOS Device
xcodebuild archive \
-scheme CalendarControl \ # 要归档的 scheme
-configuration Release \ # 使用发布配置进行构建
-destination 'generic/platform=iOS' \ # 架构类型
-archivePath './build/CalendarControl.framework-iphoneos.xcarchive' \ # 归档路径
SKIP_INSTALL=NO \ # 将框架安装到 archive
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES # 确保为分发而构建库并创建接口文件

# Target Simulator
xcodebuild archive \
-scheme CalendarControl \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \ # 设置架构类型为模拟器
-archivePath './build/CalendarControl.framework-iphonesimulator.xcarchive' \ # 归档路径
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# Target MacOS
xcodebuild archive \
-scheme CalendarControl \
-configuration Release \
-destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' \
-archivePath './build/CalendarControl.framework-catalyst.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# 生成 XCFramework
xcodebuild -create-xcframework \
-framework './build/CalendarControl.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/CalendarControl.framework' \
-framework './build/CalendarControl.framework-iphoneos.xcarchive/Products/Library/Frameworks/CalendarControl.framework' \
-framework './build/CalendarControl.framework-catalyst.xcarchive/Products/Library/Frameworks/CalendarControl.framework' \
-output './build/CalendarControl.xcframework'
```



## CocoaPods

[**CocoaPods vs Carthage vs SPM (**Dependency manager in Swift)](https://manasaprema04.medium.com/dependency-managers-in-swift-d6a01e7a29a8)

CocoaPods 是 Swift 和 Objective-C Cocoa 项目的中心化（centralized）依赖管理器。它是开源的，由许多志愿者和开源社区使用 Ruby 构建。

中心化（centralized）是什么意思？好吧，CocoaPods 基于一个名为 Specs 的主存储库，它托管所有框架的规范（specifications）文件。为了使其可供其他人使用，包开发人员必须使用 pod 命令行将新版本推送到此存储库。

[CocoaPods](https://cocoapods.org/) 在其官方网站上有一个很棒的公共搜索功能，因此您无需查询网络即可找到正确的依赖项。



## Swift Package Manager

也称为 SwiftPM 或 SPM，它从 Swift 3.0 版本开始包含在 Swift 中。

*Swift 包管理器是一个用于管理源代码分发的工具，旨在让共享代码和重用他人代码变得容易。*

Swift Package Manager 还用于使用 Vapor、Kitura 或 Perfect 等框架创建后端应用程序。

### SPM 有什么优势？

* 它由 Apple 构建，用于创建 Swift 应用程序。
* 如果一个依赖依赖于另一个依赖，Swift 包管理器会为你处理它。
* 最初它仅支持 macOS 和 Linux。自 Swift 5 和 Xcode 11 发布以来，SwiftPM 与 iOS、macOS 和 tvOS 兼容。
* 它可以很容易地与持续集成服务器集成。

### SPM 的缺点是什么？

* 它与 Swift 5 和 Xcode 11 兼容。
* Xcode 11 以下，SPM 仅支持 mac 和 linux。



## Reference

### [Open Source checklist for your next Swift library](https://benoitpasquier.com/open-source-checklist-swift-library/)

文章列举了发布开源项目时应该检查的清单：

- [ ] License 许可协议
- [ ] Compatibility 兼容性
- [ ] Stability 稳定性
- [ ] Documentation 文档
- [ ] Collaboration 合作
- [ ] Know when to stop 知道何时停止

