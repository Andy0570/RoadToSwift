## 如何在 iOS 中构建模块化架构

> 原文：[How to build a modular architecture in iOS](https://benoitpasquier.com/how-build-modular-architecture-ios/)



随着时间的推移，任何代码库都会随着项目的发展和成熟而增长。它为开发人员产生了两个主要限制：==如何在保持构建时间尽可能短的同时组织良好的代码==。让我们看看模块化架构如何解决这个问题。

![](https://benoitpasquier.com/images/2018/02/xcode-libraries.png)

## Modules

使用模块，我们可以将其表示为与主应用程序的其余部分隔离的代码资源。然后，这将作为依赖项添加到我们的 iOS 应用程序中。

> *创建模块还极大地提高了代码的可测试性和可重用性。*

这种依赖可以是应用程序的技术方面（网络、存储……），也可以是封装复杂性的功能（搜索、帐户……）。

一旦定义，我们就可以开始添加我们想要隔离的代码和资源。

打包代码的方式只有两种：动态框架和静态库。

两者之间的主要区别在于它们在最终可执行文件中的导入方式。静态库包含在编译类型中，在可执行文件中制作副本，其中动态框架在可执行文件的运行时包含，并且从不复制，从而使启动时间更快。



---



## 依赖注入和泛型在 Swift 中创建模块化应用程序

原文：[Dependency injection and Generics to create a modular app in Swift](https://benoitpasquier.com/modular-app-dependency-injection-generics-swift/)









