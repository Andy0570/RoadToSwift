> 原文：[Model-View-ViewModel for iOS @Ash Furrow](https://teehanlax.com/blog/model-view-viewmodel-for-ios/)

如果你已经开发 iOS 应用很长时间了，你可能听说过 Model-View-Controller，或者 MVC。这是你构建 iOS 应用的标准方法。 然而最近我对 MVC 的一些缺点越来越感到厌倦。在这篇文章中，我将介绍什么是 MVC，以及它的缺点，并向你介绍一种新的方式来构建你的应用程序：Model-View-ViewModel。拿出你的流行语宾果卡，因为我们即将迎来一次范式转变。

### Model-View-Controller

Model-View-Controller 是构建代码的权威模式。苹果甚至也[这样说](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)。在 MVC 模式下，所有的对象都被分类为模型、视图或控制器。模型保存数据，视图向用户展示交互 UI 界面，而视图控制器则是模型和视图之间交互的媒介。

![图自 Apple](https://tva1.sinaimg.cn/large/0081Kckwgy1glpfswpf8aj31080ezmxn.jpg)

在该模式中，视图通知控制器有关任何用户交互事件。然后视图控制器更新模型以反映状态的变化。最后，该模型（通常通过 Key-Value-Observation 的方式）通知任何需要对其视图执行更新的控制器。这种交互构成了编写 iOS 应用的大量代码。

模型对象通常是非常非常简单的。通常情况下，它们是 Core Data [管理对象](https://developer.apple.com/library/archive/documentation/DataManagement/Devpedia-CoreData/managedObject.html#//apple_ref/doc/uid/TP40010398-CH23-SW1)，或者，如果你喜欢避开讨论 Core Data，则是其他[流行的模型层](https://github.com/Mantle/Mantle)。根据苹果的说法，模型包含数据和操作数据的逻辑。然而在实践中，模型通常非常薄，归根结底，与模型逻辑有关的代码都会被放到控制器中。

视图通常是 UIKit 组件或程序员定义的 UIKit 组件集合。这些都是你的 .xib 文件或 Storyboard 文件中的一部分：应用程序中的视觉和可交互组件。Button 按钮、Label 标签，你懂的。视图永远不应该有对模型的直接引用，只应该通过 `IBAction` 事件对控制器进行引用。与视图本身无关的业务逻辑不应该出现在视图中。

这样我们就只剩下控制器了。控制器是应用程序中 "胶水代码" 的所在地：在模型和视图之间调解所有交互的代码。控制器负责管理它们所拥有的视图的视图层次结构。它们需要响应视图的加载、出现、消失等等。它们也往往会被我们从模型层中剥离出来的数据操作逻辑和从视图层中剥离出来的业务逻辑所累及。这就引出了我们对 MVC 的第一个问题......

### 臃肿的视图控制器（Massive View Controller）

由于视图控制器中放置了非常多的代码，它们往往会变得极其臃肿。在 iOS 中，视图控制器内容增加到成千上万行代码并非危言耸听。这些臃肿的部件让你的应用不堪重负：臃肿的视图控制器难以维护（因为它们的体积太大了），包含几十个属性，使得它们的状态难以管理，并且遵守许多协议，这使得遵守协议的实现代码与控制器逻辑混合在一起。

臃肿的视图控制器难以测试，无论是手动测试还是单元测试，因为它们有很多可能的状态。将代码分解成更小、更容易理解的部分通常是一件好事。我想到了最近的[一个故事](http://mikehadlow.blogspot.com/2013/12/are-your-programmers-working-hard-or.html)。

### 缺失的网络逻辑（Missing Network Logic）

MVC 的定义--也就是苹果使用的定义--指出所有的对象都可以被划分到模型、视图或控制器中的一类中。所有的对象都可以。那么你把网络代码放在哪里呢？与 API 通信的代码放在哪里？

你可以尝试聪明一点，把它放在模型对象中，但这可能会变得很棘手，因为网络调用应该是异步完成的，所以如果一个网络请求超过了拥有它的模型，那么，这就变得很复杂了。你绝对不应该把网络代码放在视图中，所以就剩下......控制器了。这也是个坏主意，因为它导致了所谓的“臃肿的视图控制器”问题。

那么，放在哪里呢？MVC 根本没有一个地方可以容纳那些不适合放在它的三个组件中的代码。

### 糟糕的可测试性（Poor Testability）

MVC 的另一个大问题是它不鼓励开发人员编写单元测试。由于视图控制器将视图操作逻辑和业务逻辑混合在一起，为了单元测试而将这些组件分离出来就成了一项艰巨的任务。很多人忽略了这项任务，而选择了......什么都不测试。

### “管理” 的模糊定义

我在前面提到，视图控制器管理一个视图层次结构；视图控制器有一个 "view" 属性，并且可以通过 `IBOutlets` 插座访问该视图的任何子视图。当你有很多插座变量时，这并不能很好地扩展，在某些时候，你可能最好使用子视图控制器来帮助管理所有的子视图。

这个时间点在哪里？什么时候才有利于分解？验证用户输入的业务逻辑是属于控制器，还是属于模型？

这里有很多模糊的界限，似乎没有人能够完全赞同。似乎无论你把这些（分割）线划在哪里，视图和相应的控制器都会变得如此紧密地结合在一起，反正你可能会把它们当作一个组件来对待。

嘿！现在有一个想法......

### Model-View-ViewModel

在理想世界里，MVC 可能会很好地工作。然而，我们生活在现实世界中，它并非你想象的那样。我们已经详细介绍了 MVC 在典型场景下的分解方式，让我们来看看另一种模式：Model-View-ViewModel。

![图自 Microsoft](https://tva1.sinaimg.cn/large/0081Kckwgy1glpi6g0r73j30ba07rmxf.jpg)

MVVM 出自[微软](http://msdn.microsoft.com/en-us/library/hh848246.aspx)，但也不要因此而抱有成见。MVVM 与 MVC 非常相似。它形式化了视图和控制器的紧密耦合特性，并引入了一个新的组件。

在 MVVM 模式下，视图和视图控制器正式连接，让我们把它们当作一个整体。视图仍然没有引用模型，但控制器也没有。相反，它们引用视图模型（View Model）。

视图模型是放置用于用户输入的验证逻辑，视图的表示逻辑，网络请求的启动以及其他各种代码的绝佳场所。 不属于视图模型的是对视图本身的任何引用。 视图模型中的逻辑在 iOS 上应与在 OS X 上一样适用。（换句话说，不要在视图模型中 `#import UIKit.h` 就可以了。）

由于表示逻辑（例如将模型数据转换为格式化字符串）属于视图模型，视图控制器本身变得远远不那么臃肿。 最好的部分是，当你开始使用 MVVM 时，你只能在视图模型中放置一些逻辑代码，然后随着对这种模式的适应性逐渐提高，将更多的逻辑迁移进来。

使用 MVVM 编写的 iOS 应用程序具有很高的可测试性。 由于视图模型包含所有表示逻辑并且不引用视图，因此可以通过编程对其进行全面测试。 尽管测试 Core Data 模型涉及许多技巧，但是使用 MVVM 编写的应用程序可以进行完整的单元测试。

以我的经验，使用 MVVM 的结果就是代码总量会略有增加，但是代码复杂度总体上下降了。这是一个值得尝试的权衡策略。

如果你再次查看 MVVM 架构图，你会注意到我使用了模棱两可的动词“ notify” 和 “update”，但未指定如何执行。 你可以像使用 MVC 一样使用 KVO，但是很快就会变得难以管理。 实际上，使用 [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 是将所有活动部件粘合在一起的好方法。

有关如何将 MVVM 与 ReactiveCocoa 结合使用的更多信息，请阅读 Colin Wheeler 发表的[出色文章](https://cocoasamurai.blogspot.com/2013/03/basic-mvvm-with-reactivecocoa.html)或查看我编写的[开源应用程序](https://github.com/AshFurrow/C-41)。 你也可以阅读我的关于 ReactiveCocoa 和 MVVM 的[书籍](https://leanpub.com/iosfrp)。
