## Scene 状态和转换

在 iPhone 上，永远只有一个 scene -- 你的应用程序的用户界面只有一个实例。但在 iPad 上，用户可能有多个 scene，而且它们可能同时可见。下图显示了屏幕上可见的 Safari 的三个实例：

<img src="https://s2.loli.net/2021/12/07/6fOiERCZT2UnztK.png" alt="6fOiERCZT2UnztK" style="zoom:50%;" />

Scene 可以在用户打开和关闭窗口时创建和销毁，因此你应该考虑 Scene 的生命周期以及整个应用程序的生命周期。例如，一个 Scene 可以进入后台状态，而另一个 Scene 仍然保留在前台状态。

<img src="https://s2.loli.net/2021/12/07/cKLJxsSW3q8rtnT.png" alt="cKLJxsSW3q8rtnT" style="zoom:50%;" />

当一个 scene 不在运行时，它处于未连接状态，它不执行任何代码，也没有在 RAM 中保留任何内存。

在一个 scene 被启动后，在进入前台活动状态之前会短暂地进入前台非活动状态。当处于前台活动状态时，一个 scene 的界面在屏幕上显示，它正在接受事件，其代码正在处理这些事件。

在活动状态下，一个 scene 可以被一个系统事件暂时打断，比如一个电话，或者被一个用户事件打断，比如触发Siri或打开任务切换器。此时，scene 重新进入前台非活动状态。在非活动状态下，一个 scene 通常是可见的，并且正在执行代码，但它无法接收事件。scene 通常在非活动状态下花费很少的时间。

当用户返回主屏幕或切换到另一个应用程序时，scene 就进入了后台状态。(实际上，在过渡到后台状态之前，它在前台非活动状态中度过了短暂的时间）。在后台状态下，一个 scene 的界面是不可见的，也不能接收事件，但它仍然可以执行代码。

默认情况下，一个进入后台状态的 scene 在进入暂停状态之前有大约10秒的时间。但是你的 scene 不应该依赖于有这么多时间；相反，它们应该尽快保存用户数据并释放任何共享资源。

处于暂停状态的 scene 不能执行代码。你不能看到它的界面，而且在暂停状态下它不需要的任何资源都会被销毁。一个暂停的 scene 基本上是闪电式冻结的，当用户重新启动它时可以迅速解冻。

只要有足够的系统内存，处于暂停状态的场景就会一直处于该状态。当操作系统内存不足时，它将根据需要终止暂停的场景，将它们移到未连接的状态。一个暂停的场景不会得到任何关于它即将被终止的指示。它只是被从内存中删除。(一个场景在被终止后可以保留在任务切换器中，但是当它被点击时必须重新启动）。

当应用过渡到后台状态时是保存任何未完成的修改的一个好地方，因为这是你的场景在进入暂停状态之前最后一次可以执行代码。一旦进入暂停状态，一个场景就可以随操作系统的意愿而终止了。

## Scene 状态

| 状态           | UI 可见性  | 是否可接受事件 | 是否可执行代码 |
| -------------- | ---------- | -------------- | -------------- |
| 未连接状态     | No         | No             | No             |
| 前台激活状态   | Yes        | Yes            | Yes            |
| 前台未激活状态 | 大多数可见 | No             | Yes            |
| 后台状态       | No         | No             | Yes            |
| 暂停状态       | No         | No             | No             |

### SceneDelegate 生命周期

```objc
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    NSLog(@"场景加载完成");
}
- (void)sceneDidDisconnect:(UIScene *)scene {
    NSLog(@"场景已经断开连接");
}
- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"已经从后台进入前台");
}
- (void)sceneWillResignActive:(UIScene *)scene {
    NSLog(@"即将从前台进入后台");
}
- (void)sceneWillEnterForeground:(UIScene *)scene {
    NSLog(@"即将从后台进入前台");
}
- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"已经从前台进入后台");
}
```


在 iOS13 之后，我们创建新的项目工程时，会出现两个代理，分别是：AppDelegate 和 SceneDelegate，而 AppDelegate 中的 Window 属性也被放到了 SceneDelegate 中，所以 iOS13 中的 AppDelegate 职责也发生了改变：

iOS13 之前，AppDelegate 的职责全权处理 App 生命周期和 UI 生命周期；

<img src="https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/3shq0F.tif" alt="3shq0F" style="zoom:50%;" />



iOS13 之后，AppDelegate 的职责是：

* 处理 App 生命周期；
* 新的 Scene Session 生命周期，UI 的生命周期交给新增的 Scene Delegate 处理

<img src="https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/mBr8Iv.tif" alt="mBr8Iv" style="zoom:50%;" />

<img src="https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/umaAEJ.tif" alt="umaAEJ" style="zoom:50%;" />

如果不需要用到 SceneDelegate，可以直接在 AppleDelegate 里创建 window，在 didFinishLaunchWithOptions 里创建启动控制器、注释下面的两个 scens 有关的代理方法，SceneDelegate 可以删除，也可以不管它，info.plist 文件中删除 Application Scece Maninfest 选项，做完以上操作，就可以和之前一样了。

### APP 的生命周期

iOS  13 之前：

```
1.点击应用程序图标
2.程序入口：进入Main函数
3.通过UIApplicationMain函数
4.初始化UIApplication对象并且设置代理对象AppDelegate
5.程序完成加载：[AppDelegate application:didFinishLaunchingWithOptions:]
6.创建Window窗口：UIWindow
7.程序被激活：[AppDelegate applicationDidBecomeActive:]
8.点击Home键
  （1）程序取消激活状态：[AppDelegate applicationWillResignActive:]
  （2）程序进入后台：[AppDelegate applicationDidEnterBackground:]
9.点击应用图标
  （1）程序进入前台：[AppDelegate applicationWillEnterForeground:]
  （2）程序被激活：[AppDelegate applicationDidBecomeActive:]
10.内存警告：[AppDelegate applicationDidReceiveMemoryWarning]
11.将要终止：[AppDelegate applicationWillTerminate]
```

iOS 13 之后：

```
1. 点击应用程序图标
2. 程序入口：进入Main函数
3. 通过UIApplicationMain函数
4. 初始化UIApplication对象并且设置代理对象AppDelegate
5. 程序完成加载：[AppDelegate application:didFinishLaunchingWithOptions:]
6. 进入场景对象调用：[SceneDelegate scene:willConnectToSession:options:]方法
7. 程序将要进入场景：[SceneDelegate sceneWillEnterForeground:]
8. 场景已经激活：[SceneDelegate sceneDidBecomeActive:]
9. 点击Home键：
  （1）取消场景激活状态：[SceneDelegate sceneWillResignActive:]
  （2）程序进入后台：[SceneDelegate sceneDidEnterBackground:]
10. 点击图标
  （1）程序将要进入前台：[SceneDelegate sceneWillEnterForeground:]
  （2）程序已经被激活：[SceneDelegate sceneDidBecomeActive:]
11. 进入程序选择界面：[SceneDelegate sceneWillResignActive:]
11. 程序被杀死：[SceneDelegate sceneDidDisconnect:]
```

## UIViewController 的生命周期

```
Xib或者普通.h.m:
1-1 initWithNibName:bundle:------初始化（xib和纯代码）,初始化控制器，可以写数据初始化操作，不要写View相关操作。
1-2 init
StoryBoard
1-1 initWithCoder:------初始化，不会直接初始化控制器
1-2 awakeFromNib------xib加载完成(xib)，一些实例化加载写在此处

2.loadView------加载视图，默认从nib，如果nib为空则会创建一个空视图（重写时，不要写super）
3.viewDidLoad------视图已经加载完成（自带的View加载完成），用于初始化数据、设定、约束、移除视图等操作
4.viewWillAppear:------视图将要出现，用于设置设备不同方向时如何显示，状态栏方向，视图显示样式
5.viewWillLayoutSubviews------view将要布局子视图
6.viewDidLayoutSubviews------view已经布局子视图
7.viewDidAppear:------视图已经显示
8.viewWillDisappear:------视图将要消失
9.viewDidDisappear:------视图已经消失
10.didReceiveMemoryWarning------控制器出现内存警告
11.dealloc------视图被销毁，系统只会释放内存，不会释放对象的所有权，所以通常在这里置为nil
```


## UIView 的生命周期

```
(纯代码)UIView创建为：[[UIView alloc] init];
1.initWithFrame:
2.init
3.layoutSubviews

(纯代码)UIView创建为：[[UiView alloc] initWithFrame:[UIScreen mainScreen].bounds];
1.initWithFrame:
2.layoutSubviews

(XIB)UIView创建为：NSArray *arr = [[NSBundle mainBundle] loadNibNamed:(@"NIBView") owner:nil option:nil];     [arr lastObject];
1.initWithCoder:
2.awakeFromNib
3.layoutSubviews
```