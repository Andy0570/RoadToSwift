> 原文：[Checking API Availability in Swift @Andy Bargh](https://andybargh.com/checking-api-availability-in-swift/)



iOS SDK 是一头不断变化的野兽。

随着每一个新版本的发布，Apple 都会引入一系列新的类、方法和符号，同时也会废除一大堆其他的类、方法和符号。作为开发者，每次新版本发布，我们都会被诱惑着一头扎进这些框架所提供的小工具和小玩意儿中，随之而来的是越来越多的诱惑，让我们干脆放弃对旧版本操作系统的支持，以便我们能够专注于开发这些最前沿的功能。

对于许多开发者来说，这种对新事物的关注是一种可行的选择，尤其是当他们推出全新的应用程序并希望利用硬件的最新功能时，但对于其他开发者来说，只关注最新和最伟大的东西并不是一种选择，至少在不失去现有用户群的情况下是这样。这就不可避免地使后来的开发者面临着利用 SDK 新功能的挑战，同时试图支持尚未升级的部分用户群，而这一挑战又不可避免地导致这些开发者进行弱连接和运行时检查，以试图确定哪些 API 在用户平台上可用，哪些不可用。

到目前为止，成功执行这些检查总是有点棘手，但现在，在 Swift 2.0 中，Apple 已经引入了一个新的 *availability* API，在简化这种情况方面大有可为。

[TOC]

## 在 Objective-C 中检查 API 的可用性

通常，在 Objective-C 和 Swift 的早期版本中，有三种主要的技术被开发者用来检查 API 的可用性。它们是：

* 检查操作系统的版本。
* 检查一个特定类是否存在。
* 检查一个类或对象是否能响应指定的方法。

让我们依次看一下这些情况。



### 检查操作系统版本

检查 iOS SDK 中某一特定类、方法或符号是否可用的第一种方法是检查应用程序所运行的操作系统的版本，然后将其与所需的最低操作系统版本进行比较（摘自Apples文档）。

这通常涉及到在代码中定义一些宏，其核心是封装对 `[[UIDevice currentDevice] systemVersion]` 的调用，以识别应用程序所运行的操作系统的特定版本。这些宏通常看起来像这样：

```objective-c
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
```

一旦定义，这些宏就会与 `if` 语句结合使用，以有条件地执行不同的代码块:

例如，假设我想使用一个只在 iOS 9.0 或更高版本上可用的特定 API，我可以写：

```objective-c
if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
    // iOS 9 or later code
} else {
    // Code using the frameworks that were available before iOS 9.
}
```



### 检查类可用性

开发人员使用的下一个方法，是着重于检查一个特定的类是否存在。

在这种情况下，他们使用 `NSObject` 提供的类方法来访问某个特定类的类对象，以确定它是否存在。如果它存在，他们就利用该类提供的功能，如果不存在，他们就执行一些回退语句或直接退出：

```objective-c
if ([SomeClass class]) {
    // class exists
    SomeClass *instance = [[SomeClass alloc] init];
} else {
    // class doesn't exist
}
```



### 检查方法可用性

最后一种技术是在一个框架或类中检查单个方法。通常这涉及到使用类本身的 `instanceRepondsToSelector:` 方法。

```objective-c
if ([SomeClass instancesRespondToSelector:@selector (newMethod:)]) {
    // Method is available for use.
} else {
    // Method is not available.
}
```

或者在一个对象上的 `responseToSelector` 方法：

```objective-c
if ([obj respondsToSelector:@selector(newMethod:)]) {
    // Use the new method...
} else {
    // Work around the fact that the new method isn't available.
}
```



### 传统方法存在的问题

因此，正如你所看到的，开发人员可以采用一些技术来检查 API 的可用性，尽管（在大多数情况下）它们是有效的，但它们需要不断地翻阅官方文档以确定有哪些 API 可用，在什么平台上，在什么版本上，实际上，这可能是相当痛苦的维护。

除此之外，虽然这些检查看起来很安全，但在某些情况下，这些检查实际上是失败的。

这方面的一个例子是，你在最新版本的 iOS 中检查一个符号或类，你认为这是一个新功能，并希望在以前的操作系统版本中失败。但在某些情况下，该符号实际上可能存在，但却是你不知道的一个私有的未发布的 API 的一部分，在你不知道的情况下，你开始使用一个未发布的 API，其潜在的副作用是你不知道的。这并不理想。

不过在 Swift 2.0 中，整个问题变得简单多了。



## 在 Swift 2.0 中检查 API 的可用性

Swift 2.0 内置了语言层面的支持，允许我们明确检查某个特定的类、函数或符号在当前设备和平台上是否可用。

Swift 编译器现在可以利用 SDK 中的信息来检查特定 API 调用的可用性，并且能够在编译器时间而不是运行时间进行检查。如果你的代码试图使用你的部署目标在运行时无法使用或将来可能无法使用的 API，这允许它在编译期间提出警告或错误，让你有机会在应用部署前修复这些问题。

那么，我们需要做什么来利用这种新的能力呢？嗯，这就是可用性条件（*availability conditions*）的作用。



### 可用性条件

可用性条件（*availability condition*）有点像布尔表达式，使用 `#available` 关键字与 `if` 或 `guard` 语句相结合，根据你想使用的 API 的运行时间可用性，有条件地执行一个代码块。

一般语法如下：

```swift
if #available(platformName version, ..., *) {
    // Statements to execute if the API is available
} else {
    // Fallback statements to execute otherwise.
}
```

正如你所看到的，可用性条件需要一个平台名称和版本的列表，每个平台-版本对用逗号与下一个分开。
在撰写本报告时，有八个平台可供你使用：

* `iOS`
* `iOSApplicationExtension`
* `OSX`
* `OSXApplicationExtension`
* `watchOS`
* `watchOSApplicationExtension`
* `tvOS`
* `tvOSApplicationExtension`



然后，这些平台可以单独与正整数或浮点十进制的版本号结合。例如，9 和 9.1 都是有效的。

除了这些平台-版本对之外，我们还必须包括一个星号（`*`），作为括号内的最后一个参数。这个星号被用作通配符，以涵盖任何额外的平台（包括未知数量的未来平台），这些平台没有被特别列出，无论我们的代码是否针对这些平台，我们都必须包括它。

星号规定，在这些其他平台的情况下，`if` 或 `guard` 语句的主体将在你的项目指定的最小部署目标上执行，如果你忘记包括它，你将得到编译器礼貌的一巴掌，表明你必须用 `*` 来处理潜在的未来平台。

所以，在掌握了基础知识之后，让我们来看看几个具体的例子。在这个例子中，我将把可用性条件与 `if` 语句结合起来使用：

```swift
if #available(iOS 8.0, OSX 10.10, *) {
    // Make use of the new API.
} else {
    // Fall back to old API or exit.
}
```

上面代码中的可用性条件表明，当这段代码在 iOS 平台上运行时，`if` 语句的第一个分支只有在平台是 iOS 8.0 或更高版本时才会被执行。

除此之外，它还表明，当在 OS X 上执行时，必须是 10.10 或更高版本，才能使第一个分支运行。

我还（根据需要）加入了 `*`，表示在我没有特别列出的所有其他平台上，代码将在我的构建目标所指定的最小部署目标上运行。

正如我提到的，你也可以将可用性条件与 Swift 2.0 中新的 `guard` 语句结合使用。这允许你在你想使用的特定 API 不可用时，提前退出一个函数或方法：

```swift
guard #available(iOS 8, watchOS 2.0) else {
    return
}

// Make use of the new API.
```

在这种情况下，只有当平台是 iOS 8 或更高版本，或 watchOS 2.0 或更高版本时，`guard` 语句的收尾括号之后的代码才会执行。在所有其他情况下，`guard` 语句的主体将被执行，并且按照 `guard` 语句的要求，代码将返回。明白这个意思了吗？

现在，除了让我们能够在代码中检查特定 API 的可用性之外，Swift 2.0 还引入了这个等式的另一面，即我们能够注释自己的代码，以表明它将在哪些平台和版本上运行。让我们接下来看看这个。

## 属性可用性

在 Swift 中，我们有能力向声明或类型添加 *attributes*。*attributes* 是关于声明的额外元数据，写在声明前面，使用 `@` 符号，后面是属性名称和属性接受的任何参数。比如说：

```swift
@attribute name
@attribute name(arguments)
```

Swift 中的这些属性之一是 `available` 属性，它遵循这两种格式中的后者。

`available` 属性提供了我们刚刚看到的 `#available` 条件的对立面，允许我们指定与某些平台和操作系统版本有关的声明的额外细节。

现在，`available`  属性的语法应该已经非常熟悉了：

```swift
@available(platformName version, ..., *)
```

从本质上讲，它遵循与我们刚刚看到的 `#available` 条件相同的语法，使用相同的平台范围和相同的版本控制规则。

与 `#available` 条件一样，在这个简短的语法中，我们还需要包括星号（`*`）字符作为 `@available` 注解的最后一个参数，以涵盖我们没有明确指定的平台，或者将来可能出现的平台。

所以在这一点上，你可能会想，这和 `#available` 条件差不多，而且在大多数情况下你是正确的，但还有一些其他的东西使可用性注释有些不同。

除了我们到目前为止看到的速记语法外，可用性注解还可以写成较长的形式，并与提供额外细节的附加注解参数相结合。
在这种较长的形式中，你可以在声明前立即写一个或多个注解，编译器只在一个可用属性指定了一个与当前目标平台相匹配的平台时才会使用该属性。

在这种语法中，注解的第一个参数是注解适用的平台，可以是我们前面看的任何一个平台，也可以是星号（`*`）字符，表示注解适用于所有平台。然后可以在后面（在逗号之后）加上一个或多个附加参数。其中第一个是 `unavailable` 参数。



### `unavailable` 参数

`unavailable` 参数用来表示当前项在给定的平台上不可用。任何试图在该平台上使用该声明的人都会得到一个与下面类似的编译器错误：

![](https://andybargh.com/wp-content/uploads/2015/10/api_availability-unavailable-1.png)



我们还可以选择使用 `introduced`、`deprecated` 或 `obsoleted` 参数。每个参数后面都有一个 `=` 字符，然后是一个版本，和不可用参数一样，如果我们用逗号隔开，我们可以使用多个参数。



### `introduced` 参数

`introduced` 参数指定了声明可用的第一个平台版本，是我们之前看到的指定版本号的长式语法。

### `deprecated` 参数

下一个关键字，`deprecated` 表示该声明被废弃的第一个版本，对于任何试图在匹配平台的后期版本中使用该声明的人来说，将导致类似于下面的编译器警告。

![](https://andybargh.com/wp-content/uploads/2015/10/api_availability-deprecated-1.png)


### `obsoleted` 参数

`obsoleted` 关键字指定了该声明首次被删除的平台版本。在这种情况下，在以后的平台版本中使用该声明将导致一个编译器错误。

![](https://andybargh.com/wp-content/uploads/2015/10/api_availability-obsoleted-1.png)


### `renamed` 参数

`renamed` 参数，与一个字符串字面量一起使用，用于指示声明的新名称，如果它已经被重命名。正如你在下面的截图中所看到的，声明的新名字会被编译器显示在错误信息中，在这些简单的情况下，fix-it系统可以用来为你自动重命名对 API 的任何调用。

![](https://andybargh.com/wp-content/uploads/2015/10/api_availability-renamed-1.png)


### `message` 参数

最后一个支持的注释参数是 `message` 参数，它同样与一个字符串字面量结合。`message` 参数被用来提供额外的文本，当编译器显示关于声明被废弃或过时的警告或错误时，会显示这些文本。

![](https://andybargh.com/wp-content/uploads/2015/10/api_availability-message-1.png)


## 更多信息

至此，Swift 中的 API 可用性检查和 API 注释就基本结束了。正如我们所看到的，Swift 2.0 引入的新功能不仅允许我们检查 API 的可用性，还允许我们对自己的 API 进行注释，这在很大程度上消除了开发者过去所遭受的维护开销。

如果你想了解更多关于 Swift 中的 API 可用性检查或注解的信息，请确保你查看 [Swift 编程语言指南](https://swiftgg.gitbook.io/swift/)中的[检查 API 可用性](https://swiftgg.gitbook.io/swift/swift-jiao-cheng/05_control_flow#checking-api-availability)和属性部分，如果你有任何问题、提示和意见，请随时与我们联系。

