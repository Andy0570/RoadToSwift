> 原文：[Basic MVVM with ReactiveCocoa](https://cocoasamurai.blogspot.com/2013/03/basic-mvvm-with-reactivecocoa.html)

## MVC - 一种模式走天下

MVC 设计模式从 20 世纪 70 年代末就已经存在了，在 Foundation、AppKit & UIKit 框架中已经使用了很长时间。其核心是一个非常简单的理念。它是这样的：

![MVC](https://tva1.sinaimg.cn/large/0081Kckwgy1glpqdh6i6ej308w026a9y.jpg)

如你所见，我们有3个组件：

* Model - 我们的视图正在管理的数据模型；
* View - 屏幕上的用户界面，包括文本输入框、按钮等；
* Controller - MVC 中的控制器用于将视图与模型解耦；

在 MVC 设计模式中，控制器将模型与视图分离，这样每个模型都可以独立地更改。如果我们没有这样解耦，那么每当模型改变时，视图也需要改变。在这个设计模式中，交互是这样发生的：

1. 视图触发并执行控制器上的动作；
2. 控制器执行所述动作，并更新模型；
3. 控制器可能会收到来自模型的更新通知；
4. 控制器更新视图；

这是我们在使用这种设计模式时，所做的 MVC 华尔兹，总的来说效果相当不错。我们使用这种模式的原因是因为这种模式将视图和数据模型解耦，让控制器成为两者的中介，这样控制器就可以访问数据模型中需要访问的部分，并且允许控制器做一些事情，比如正确地格式化视图的数据。

## MVVM - 一种更好的模式

MVVM 是 Model-View-ViewModel 的缩写，来自微软，它基于 MVC 设计模式。更准确的说，它基于 [Martin Fowlers Presentation Model](https://martinfowler.com/eaaDev/PresentationModel.html)。对于部分人来说，一开始它看起来和 MVC 设计模式非常相似，人们会困惑于它有什么不同。所以，让我给你展示一下这个模式，然后我们再看看它有什么不同。

![MVVM](https://tva1.sinaimg.cn/large/0081Kckwgy1glpqn3z6odj308w01bdfq.jpg)

在这种模式下，我们仍然有 3 个组件，和 MVC 一样，但是有区别。在 MVVM 中，我和其他人倾向于把 View Controller 和 View 归为一组，这样这 2 个东西就被当作 1 个组件来处理。最重要的部分是我们引入了视图模型，并且视图通过某种观察者从视图模型中获得更新推送。在本文中，ReactiveCocoa 将是那个观察者。

在 MVVM 模式中，视图模型封装了视图可以绑定的数据/属性，以及任何可以执行的验证逻辑和动作。例如，如果你有一个按钮需要改变它的标题文本，你会在视图模型上创建一个属性，按钮可以将其标题属性绑定到这个属性上。如果你需要改变一个控件的颜色或启用/禁用控件，也是一样的。在这个模式中，我们基本上是把我们的应用程序的状态放到了视图模型中。同样值得注意的是，就视图模型而言，它并不关心它从哪里获得这个状态。不管它是从它的 `init` 方法、磁盘上的文件、Core Data、还是数据库获取的。

因为我们用这样的方式封装了视图的状态，这有几个好处。

**我们不需要去测试 UI**

对于标准控件，我们根本不需要测试我们的 UI，因为控件将其状态绑定到了视图模型上。苹果应该测试我们正在使用的控件，而你应该测试你创建的自定义控件。这意味着，当我们将控件状态绑定到视图模型上时，我们不需要查询控件的状态了，因为我们能够直接通过视图模型获取控件的状态。这个功能往往能很好地借给下一个功能......。

**我们可以很容易地对视图模型进行单元测试**

视图模型可以访问视图绑定的所有属性，正因为如此，我们可以对视图模型进行逻辑验证。这也使得对模型进行单元测试和 UI 可能进入的各种状态进行单元测试变得非常容易。我认为 Justin 其实把这句话表述得非常好："MVVM 的一个好的试金石就是你是否能够在没有实际的 UI 的情况下，为你的 UI 行为编写自动化测试。" 我完全同意这句话，并且认为它出色地概括了 MVVM 的核心思想。

**更容易更新 UI**

因为 UI 只是绑定到视图模型上，这意味着你只需将合适的属性绑定到视图模型上就能够替换组件，你的 UI 就可以和以前一样正常工作。这也让 UI 设计师更容易在你的应用中尝试不同的视图。

## ReactiveCocoa 介绍

正如我提到的，ReactiveCocoa 是 Reactive Extensions .NET for Cocoa 的一个实现。该 API 并不是项目文档中解释的从 Rx 到 Cocoa API 的精确映射。ReactiveCocoa 也是基于函数式响应式编程的理念构建的。

​    函数式响应式编程（FRP）是一种编程范式，用于编写对变化做出反应的软件。

​    FRP 是建立在对价值随时间的抽象上。FRP 不是在特定的时间捕捉一个值，而是提供捕捉过去、现在和未来值的信号。这些信号可以被推理、连锁、组成和响应。

​    通过组合信号，软件可以声明式地编写，而不需要不断地观察和更新值的代码。例如，一个文本字段可以直接设置为总是显示当前的时间戳，而不是使用额外的代码来观察时钟并每秒钟更新文本字段。

​    信号也可以表示异步操作，很像期货和承诺。这大大简化了异步软件，包括网络代码。

​    FRP 的一个主要优点是它提供了一个单一的、统一的方法来处理不同类型的反应式、异步行为。

让我们通过几个例子直接跳到 ReactiveCocoa，并解释一下是怎么回事。

```objc
[RACObserve(self,name) subscribeNext:^(NSString *newName){
    NSLog(@"Name changed to %@",newName);
}];
self.name = @"Hypnotoad";
self.name = @"Nibbler";
```

当运行以上代码时，它会打印输出 "Name changed to Hypnotoad" 和 "Name changed to Nibbler"。我们所做的是围绕 `self` 中的一个关键路径创建一个信号，然后订阅该信号，并从该信号接收流上的事件。可以这样想，一旦我们以这种方式围绕一个关键路径创建了一个信号，只要这个关键路径的值发生变化，这个信号就会看到这一点，并发送一个带有更新值的 `-next` 信号。当我们对这个信号调用 `-subscribeNext` 的时候，我们就自动订阅了这个信号。

信号只发送 3 种类型的信息：

* `next` : 这是我们如何从流中获取更新值的方法；
* `error`: 当信号无法完成时发出；
* `completed`：发送并让你知道，流上没有更多的信号了。

让我们创建一个我们自己的信号，这样你就可以看到这里发生的事情了。

```objc
-(RACSignal *)urlResults {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSError *error;
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]
     encoding:NSUTF8StringEncoding
        error:&error];
    if (!result) {
        [subscriber sendError:error];
    } else {
        [subscriber sendNext:result];
        [subscriber sendCompleted];
    }
    return nil;
 }];
}
```

虽然我们可以通过其他方式实现，但我想手动创建这个方法。这个方法返回一个信号，它是为了获取一个 URL 地址的字符串内容，然后返回给我们而创建的。为此，我使用了 `NSString` 内置的方法来从 URL 中获取字符串。我们需要做的就是检查是否有结果，如果没有，那么我们可以发送 `-next`，然后发送 `-completed`，因为我们不打算再发送消息。

除了接收我们可能会用来分配给变量的更新值外，信号还可以用于验证。

```objc
NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
RACSignal *nameFieldValid = [RACSignal combineLatest:@[ self.usernameField.rac_textSignal, self.passwordField.rac_textSignal ]
 reduce:^(NSString *username, NSString *password) {
    return @((username.length > 0) && (password.length > 0) &&
            ([username rangeOfCharacterFromSet:charSet].location == NSNotFound));
 }];
```

如果你有一个用户名字段，密码字段，并且你想知道它是否被正确填写，这个特殊的例子将在 iOS 上工作。在这个例子中，我们将只关心自身，确保用户名和密码的长度大于 0，并且在用户名中没有任何空格。该方法的 `combineLatest` 部分确保我们从文本字段信号中获取最新的值，然后在 `reduce` 部分，我们简单地返回一个数字（0 或 1）来表示是否有效。当我们把这个方法挂到控件的 `enabled` 属性时，我们得到......

```objc
RAC(self.loginButton.enabled) = nameFieldValid;
```

从这里开始，当我们绑定的信号出现正确的条件时，我们会得到一个自动启用和禁用的按钮。同样，我们也可以将控件绑定到视图模型上，比如......。

```objc
RAC(self.textField.text) = RACObserve(self.viewModel,title);
```

这里发生的事情是 ReactiveCocoa 隐含地设置了所有必要的基础架构来绑定一个字段和一个信号。如果你扩展 RAC 字段，你会得到这样的东西......

```objc
[RACSubscriptingAssignmentTrampoline trampoline][ 
[[RACSubscriptingAssignmentObjectKeyPathPair alloc] initWithObject:self 
keyPath:@(((void)(__objc_no && ((void)self.self.resultLabel.string, __objc_no)),
 "self.resultLabel.string"))] ] = 
 [self rac_signalForKeyPath:@(((void)(__objc_no && 
 ((void)self.self.aTitle, __objc_no)), "self.aTitle")) 
 observer:self];
```

值得庆幸的是，你不必每次想在代码中绑定属性时都要写这些东西。

## 什么是 View Model ?

所以我在前面提到了视图模型是我们的用户界面绑定其属性的东西，同时也包含了可以对视图模型进行的操作和任何验证逻辑。让我们展示一个简单的例子，开始了解 MVVM 中的 VM 是如何工作的。下面是我们将使用的用户界面的截图......

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glpssmhafmj308w06074v.jpg)

这里是 ViewModel 接口...

```objc
#import <Foundation/Foundation.h>

@interface CDWPlayerViewModel : NSObject

@property(nonatomic, retain) NSString *playerName;

@property(nonatomic, assign) double points;
@property(nonatomic, assign) double stepAmount;
@property(nonatomic, assign) double maxPoints;
@property(nonatomic, assign) double minPoints;

@property(nonatomic, readonly) NSUInteger maxPointUpdates;

-(IBAction)resetToDefaults:(id)sender;
-(IBAction)uploadData:(id)sender;
-(RACSignal *)forbiddenNameSignal;
-(RACSignal *)modelIsValidSignal;

@end
```

实现代码：

```objc
#import "CDWPlayerViewModel.h"

@interface CDWPlayerViewModel ()
@property(nonatomic, retain) NSArray *forbiddenNames;
@property(nonatomic, readwrite) NSUInteger maxPointUpdates;
@end

@implementation CDWPlayerViewModel

-(id)init {
    self = [super init];
    if(!self) return nil;

    _playerName = @"Colin";
    _points = 100.0;
    _stepAmount = 1.0;
    _maxPoints = 10000.0;
    _minPoints = 0.0;

    _maxPointUpdates = 10;

    //I guess we'll go with the ned flanders bad words
    //change this to whatever you want
    _forbiddenNames = @[ @"dag nabbit",
                      @"darn",
                      @"poop"
                      ];

    return self;
}

-(IBAction)resetToDefaults:(id)sender {
    self.playerName = @"Colin";
    self.points = 100.0;
    self.stepAmount = 1.0;
    self.maxPoints = 10000.0;
    self.minPoints = 0.0;
    self.maxPointUpdates = 10;
    self.forbiddenNames = @[ @"dag nabbit",
                          @"darn",
                          @"poop"
                          ];
}

-(IBAction)uploadData:(id)sender {
    @weakify(self);
    [[RACScheduler scheduler] schedule:^{
        sleep(1);
        //pretend we are uploading to a server on a backround thread...
        //dont ever put sleep in your code
        //upload player & points...

        [[RACScheduler mainThreadScheduler] schedule:^{
            @strongify(self);
            NSString *msg = [NSString stringWithFormat:@"Updated %@ with %.0f points",self.playerName,self.points];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Successfull" message:msg delegate:nil
                                                  cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }];
    }];
}

-(RACSignal *)forbiddenNameSignal {
    @weakify(self);
    return [RACObserve(self,playerName) filter:^BOOL(NSString *newName) {
        @strongify(self);
        return [self.forbiddenNames containsObject:newName];
    }];
}

-(RACSignal *)modelIsValidSignal {
    @weakify(self);
    return [RACSignal
            combineLatest:@[ RACObserve(self,playerName), RACObserve(self,points) ]
            reduce:^id(NSString *name, NSNumber *playerPoints){
                @strongify(self);
                return @((name.length > 0) &&
                (![self.forbiddenNames containsObject:name]) &&
                (playerPoints.doubleValue >= self.minPoints));
            }];
}

@end
```

关于@weakify(self);和@strongify(self);的简短说明，这是你可以在你的应用程序中除了使用__weak id bself = self;之外的事情之一，以避免保留self。这段特殊的代码是最初来自 libextobjc，然后直接融入到 ReactiveCocoa 本身。特别是这也有同样的效果，即创建一个弱引用到self。我喜欢这种方法，因为你只需在代码中不断使用self.[property]......，你就不必不断地记住创建一个bself变量。查看libextobjc中的EXTScope.h或ReactiveCocoa中的RACEXTScope.h。

正如你所看到的，它相对简单，因为我们只真正关注与播放器相关的几个属性。其他的属性是用来绑定控件和进行一些验证的。我们也有一个单一的动作方法和几个信号。你会注意到一件事，那就是View Model根本不知道它要绑定的UI是什么样的。这很好，因为这意味着你可以灵活地绑定东西，你可以以对绑定它的类有意义的方式与视图模型挂钩。

现在让我们来看看我们的 ViewController，它是如何使用这些属性和信号的。

```objc
__weak CDWViewController *bself = self;
```

为了确保我们不在 Block 块中保留自身，我们需要使用一个弱引用。ReactiveCocoa 项目也有 @weakify 和 @strongify 可以在 Block 块中做到这一点，但我会让你研究一下，看看你是否想使用它。

```objc
// 创建视图模型
self.viewModel = [CDWPlayerViewModel new];
```

显然要从创建一个 ViewModel 实例开始。

```objc
// 开始绑定属性
RAC(self.nameField.text) = [RACObserve(self.viewModel,playerName) distinctUntilChanged];

[[self.nameField.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString *x) {
    bself.viewModel.playerName = x;
}];
```

第一个控件是球员名字的 `UITextField`，所以我们需要将其文本属性绑定到视图模型的 `playerName` 属性。我们还需要确保我们用来自文本字段的更新来更新视图模型。这样可以确保文本字段接收到来自视图模型的任何更新，也可以确保视图在更新视图模型上的球员名属性。

```objc
//the score property is a double, RC gives us updates as NSNumber which we just call
//stringValue on and bind that to the scorefield text
RAC(self.scoreField.text) = [RACObserve(self.viewModel.points) map:^id(NSNumber *value) {
    return [value stringValue];
}];
```

我们需要将标签的文本属性绑定到视图模型的 `points` 属性。视图模型的 `points` 属性是一个 double 类型，但是ReactiveCocoa 给我们提供的更新是 `NSNumber` 类型，所以我们需要将其映射为一个标签可以使用的 `NSString` 类型。

```objc
//Setup bind the steppers values
self.scoreStepper.value = self.viewModel.points;
RAC(self.scoreStepper.stepValue) = RACObserve(self.viewModel,stepAmount);
RAC(self.scoreStepper.maximumValue) = RACObserve(self.viewModel,maxPoints);
RAC(self.scoreStepper.minimumValue) = RACObserve(self.viewModel,minPoints);
```

简单的绑定和设置。从视图模型中给出步进器的初始值，并将属性（stepValue,min,max）绑定到视图模型。

```objc
//bind the hidden field to a signal keeping track if
//we've updated less than a certain number times as the view model specifies
RAC(self.scoreStepper.hidden) = [RACObserve(self,scoreUpdates) map:^id(NSNumber *x) {
    return @(x.intValue >= bself.viewModel.maxPointUpdates);
}];

//only take the maxPointUpdates number of score updates
[[RACObserve(self.scoreStepper,value) take:self.viewModel.maxPointUpdates] subscribeNext:^(id newPoints) {
    bself.viewModel.points = [newPoints doubleValue];
    bself.scoreUpdates++;
}];
```

我们将从视图模型中强制执行一个规则，在任何给定的时间，你只能更新点10次。为了做到这一点，我创建了一个NSUInteger 属性(实际上是我们真正添加到视图控制器中的唯一属性。)然后将隐藏属性绑定到一个信号上，这个信号根据我们更新的次数是否大于或等于我们更新点的次数而还原为0或1。所以只要达到我们想要的数字，这个就会返回1，并将隐藏属性翻转为YES。为了更新点数，我们订阅步进器的值属性，只要它更新，我们就会更新视图模型，并递增玩家点数。

```objc
//this signal should only trigger if we have "bad words" in our name
[self.viewModel.forbiddenNameSignal subscribeNext:^(NSString *name) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forbidden Name!"
                                                    message:[NSString stringWithFormat:@"The name %@ has been forbidden!",name]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    bself.viewModel.playerName = @"";
}];
```

如果你还记得视图模型有一个验证信号，它表明是否有任何名字被禁止。我的列表真的很糟糕，无论如何都不能代表我个人认为的坏词。这样做的好处是，我们不需要知道视图模型认为什么是 "坏词 "的任何细节，但它可以只提供一个信号来表明它认为某件事情应该被禁止。视图模型可以为很多这样的事情提供信号，它认为重要的事情要让你知道。在这种情况下，我们决定做的就是显示一个警报视图，并重置玩家名称。

```objc
//let the upload(save) button only be enabled when the view model says its valid
RAC(self.uploadButton.enabled) = self.viewModel.modelIsValidSignal;
```

视图模型提供给我们的另一个信号是让我们知道存在的视图模型是否有效。在这种情况下，我把这个信号挂到了上传按钮的enabled属性上。所以如果视图模型的状态不好，我们应该无法上传球员的数据。这里的信号很简单

```objc
-(RACSignal *)modelIsValidSignal {
    @weakify(self):
    return [RACSignal
            combineLatest:@[ RACObserve(self,playerName), RACObserve(self,points) ]
            reduce:^id(NSString *name, NSNumber *playerPoints){
                @strongify(self);
                return @((name.length > 0) && (![self.forbiddenNames containsObject:name]) && (playerPoints.doubleValue >= self.minPoints));
            }];
}
```

所以在这个简单的演示中，我们只关注名字长度是否大于0，名字是否不在禁名中，积分是否大于最小值。真的我们应该关注更多，但我不会进一步扩展。我们甚至可以直接把禁名信号放进去，如果我们把它改成使用map，返回一个0或者1的NSNumber，这样我们就可以在这个信号里面使用它。

```objc
//set the control action for our button to be the ViewModels action method
[self.uploadButton addTarget:self.viewModel
                      action:@selector(uploadData:)
            forControlEvents:UIControlEventTouchUpInside];
```

按钮的设置是为了触发视图模式的上传数据操作。示例代码中的这个方法模拟上传东西，然后呈现一个警报视图，让你知道上传成功。

```objc
//we can subscribe to the same thing in multiple locations
//here we skip the first 4 signals and take only 1 update
//and then disable/hide certain UI elements as our app
//only allows 5 updates
[[[[self.uploadButton rac_signalForControlEvents:UIControlEventTouchUpInside]
   skip:(kMaxUploads - 1)] take:1] subscribeNext:^(id x) {
    bself.nameField.enabled = NO;
    bself.scoreStepper.hidden = YES;
    bself.uploadButton.hidden = YES;
    }];
```

这里由于已经有了启用按钮的信号，现在需要限制上传的数量。这是订阅UIControlEventTouchUpInside事件的信号，并在第n次更新时，其中n是kMaxUploads。在第n次更新时，Nameefield被禁用，分数步进器和上传按钮被隐藏。

所有这一切的结果是，UI只是将其属性绑定到视图模型上，将其动作设置为视图模型上的动作，并从视图模型上接收指示感兴趣事物的信号。我承认这个特殊的例子有点奇怪，但它演示了使用视图模型和使用ReactiveCocoa的基本方面。特别是ReactiveCocoa还有很多东西，为了不一下子介绍太多概念，我没有在这里展示。另外我们还可以建立一些更好的视图模型来处理网络代码，可以处理子视图控制器，但这要等到另一篇文章中去。

那么我们在这里看到了什么呢？

* MVVM是Model-View-ViewModel的缩写。
* 视图模型包含了要绑定的属性、验证逻辑和要对视图模型进行的操作等内容。
* 视图模型不应该知道任何关于将与之绑定的UI的信息。
* ReactiveCocoa是Microsofts Reactive Extensions for .NET中许多API在Cocoa中的实现。
* 我们学习了如何绑定和订阅属性。
* 我们学会了如何创造信号。

你可以看到 reactive cocoa 最大的特点是，所有的代码和信号都只是对事件的反应。当我们把这些反应链在一起，并正确地过滤事件时，我们就会大量减少创建大量变量和方法只是为了跟踪正在发生的事件。这就导致了更可靠的代码，有了视图模型，我们可以很容易地测试它，并模拟一个 UI，而无需在我们的应用程序中实际拥有一个真实的 UI。

这里展示的完整源代码位于https://github.com/Machx/MVVM-IOS-Example。

所以请查看 github上 的 ReactiveCocoa，我在底部提供了一些有用的链接来帮助理解这些概念。如果大家愿意的话，我会在以后的文章中对 ReactiveCocoa 进行更深入的探讨。

* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
* [MVVM 概述](https://docs.microsoft.com/en-us/previous-versions/msp-n-p/hh848246(v=pandp.10)?redirectedfrom=MSDN)
* [Martin Fowlers Presentation Model](https://martinfowler.com/eaaDev/PresentationModel.html)

