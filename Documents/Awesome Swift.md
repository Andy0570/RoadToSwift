[TOC]


# Awesome Swift
精心编写的 Swift 框架、库和软件集合。

## 网络

### HTTP

* :heart: [Alamofire/Alamofire](https://github.com/Alamofire/Alamofire) ⭐️36.7k - Alamofire 是 AFNetworking 的作者 mattt 新写的网络请求的 swift 库。[Alamofire 最佳实践](https://github.com/ipader/SwiftGuide/wiki/Alamofire%20%E6%9C%80%E4%BD%B3%E5%AE%9E%E8%B7%B5)
* :heart: [Moya](https://github.com/ashfurrow/Moya) ⭐️13.6K - 对 Alamofire 的封装，使用枚举将网络层实现细节与页面逻辑代码分离，方便单元测试，支持 stub 测试，配合 RxSwift 食用更佳。[官方中文文档](https://github.com/Moya/Moya/blob/master/Readme_CN.md)
* [SwiftHTTP](https://github.com/daltoniam/SwiftHTTP) - Thin wrapper around NSURLSession in swift. Simplifies HTTP requests.
* [Net](https://github.com/nghialv/Net) - HttpRequest wrapper written in Swift.
* [Just](https://github.com/JustHTTP/Just) - HTTP for Humans (python-requests style HTTP library)
* [AeroGear IOS Http](https://github.com/aerogear/aerogear-ios-http/) - is a thin layer to take care of your http requests working with NSURLSession.
* [Siesta](https://bustoutsolutions.github.io/siesta/) - Ends state headaches by providing a resource-centric alternative to the familiar request-centric approach to HTTP.
* [Taylor](https://github.com/izqui/Taylor) - a web server library in Swift.
* [Perfect](https://github.com/PerfectlySoft/Perfect) - a web framework tayin Swift.
* [Swifter](https://github.com/glock45/swifter) - an HTTP server engine in Swift.


### Socket
* [socket.io-client-swift](https://github.com/socketio/socket.io-client-swift) ⭐️4.6k
* 【Archived】[SocketIO-Kit](https://github.com/ricardopereira/SocketIO-Kit) - Socket.io iOS/OSX Client compatible with v1.0 and later
* [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket) ⭐️11.8k
* [MQTT-Client-Framework](https://github.com/novastone-media/MQTT-Client-Framework) ⭐️1.7k - iOS, macOS, tvOS native ObjectiveC MQTT Client Framework


### WebSocket
* [Starscream](https://github.com/daltoniam/starscream) ⭐️7.1K - WebSocket 客户端类库。
* [SwiftWebSocket](https://github.com/tidwall/SwiftWebSocket) ⭐️1.5K - Fast Websockets in Swift for iOS and OSX.
* [SocketRocket](https://github.com/facebookarchive/SocketRocket) ⭐️9.3k - A conforming Objective-C WebSocket client library.


### OAuth
* [OAuthSwift](https://github.com/dongri/OAuthSwift) ⭐️2.9K - 国外主流网站 OAuth 授权类库。 


### MQTT
* [CocoaMQTT](https://github.com/emqx/CocoaMQTT) ⭐️1.2K - MQTT 5.0 Client Library for iOS and macOS written in Swift


### 图片加载&图片处理
* [Kingfisher](https://github.com/onevcat/Kingfisher) ⭐️19.3K - 轻量级，纯 Swift 实现的网络图片下载和缓存框架。
* [KingfisherWebP](https://github.com/Yeatse/KingfisherWebP) - WebP 图片解码
* [Nuke](https://github.com/kean/Nuke) ⭐️6.4K - Advanced framework for loading and caching images
* [HanekeSwift](https://github.com/Haneke/HanekeSwift) ⭐️5.1K - 轻量带缓存高性能图片加载组件
* [ImageScout](https://github.com/kaishin/ImageScout) ⭐️953 - 最小网络代价获得图片大小及类型
* [DominantColor](https://github.com/indragiek/DominantColor) ⭐️865 - 提取图片主色示例项目
* [Toucan](https://github.com/gavinbunney/Toucan) ⭐️2.4K - 小而美的图片变换及处理类
* [gifu](https://github.com/kaishin/gifu) ⭐️2.7K - 高性能 GIF 显示类库



## JSON/XML 操作

* :heart: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) ⭐️21K - GitHub 上最为开发者认可的 JSON 解析类。
* [Alamofire-SwiftyJSON](https://github.com/SwiftyJSON/Alamofire-SwiftyJSON) ⭐️1.4K - Alamofire extension for serialize NSData to SwiftyJSON.
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) ⭐️8.9K - JSON Object mapping written in Swift.
* [HandyJSON](https://github.com/alibaba/HandyJSON) ⭐️3.9K - 阿里开源的 JSON 解析框架
* [Argo](https://github.com/thoughtbot/Argo) ⭐️3.5K - Swift 下的 JSON 解析框架。
* [json-Swift](https://github.com/owensd/json-swift) ⭐️731 - A basic library for working with JSON in Swift.
* [SWXMLHash](https://github.com/drmohundro/SWXMLHash) - Simple XML parsing in Swift.
* [AEXML](https://github.com/tadija/AEXML) - Simple and lightweight XML parser for iOS written in Swift.
* [JASON](https://github.com/delba/JASON) - JSON parsing with outstanding performances and convenient operators.
* [Fuzi](https://github.com/cezheng/Fuzi) - A fast & lightweight XML/HTML parser with XPath & CSS support in Swift 2.
* [Tailor](https://github.com/zenangst/Tailor) - A super fast & convenient object mapper tailored for your needs.
* [SwiftyJSONAccelerator](https://github.com/insanoid/SwiftyJSONAccelerator) - Generate Swift 5 model files from JSON with Codeable support.
* :heart: [swift-protobuf](https://github.com/apple/swift-protobuf) ⭐️3.7k - Protocol Buffers 的 Swift 语言实现库。P.S. Protocol Buffers 是 Google 开源项目，主要功能是实现直接序列化结构化的对象数据，方便跨平台快速传递，开发者也可以直接修改 protobuf 中的数据。相比 XML 和 JSON，protobuf 解析更快，存储更小.



## 自动布局

* :heart: [SnapKit](https://github.com/SnapKit/SnapKit) ⭐️ 18k - Auto Layout 自动布局框架
* [PureLayout](https://github.com/PureLayout/PureLayout) - ⭐️7.5k - iOS&OS X 自动布局的终极 API ー令人印象深刻的简单、强大、兼容 Objective-C 和 Swift。
* [Cartography](https://github.com/robb/Cartography) ⭐️7.3k - 基于代码级的自动布局封装框架
* [PinLayout](https://github.com/mirego/PinLayout) ⭐️1.8k - Extremely Fast views layouting without auto layout. No magic, pure code, full control and blazing fast. Concise syntax, intuitive, readable & chainable.
* [Swiftstraints](https://github.com/Skyvive/Swiftstraints) - 强大的自动布局框架，让你在一行代码中编写约束。

## 框架

* [AsyncDisplayKit](https://github.com/facebookarchive/AsyncDisplayKit) ⭐️13.5K - 提供界面的高流畅性切换及更灵敏的响应。
* [MMWormhole](https://github.com/mutualmobile/MMWormhole) ⭐️3.8K - iOS 扩展与宿主应用的通讯框架。
* [Whisper](https://github.com/hyperoslo/Whisper) 3.7K - Whisper 是一个组件，可以简化显示消息和应用内通知的任务。
* [NetworkObjects](https://github.com/colemancda/NetworkObjects) ⭐️266 - 轻量版 HttpServer 框架，跨平台解决方案。
* [FontAwesome.Swift](https://github.com/thii/FontAwesome.swift) ⭐️1.5K - Use FontAwesome in your Swift projects.
* [GoogleMaterialIconFont](https://github.com/kitasuke/GoogleMaterialIconFont) - Google Material Icon Font for Swift and ObjC.
* [epoxy-iOS](https://github.com/airbnb/epoxy-ios) ⭐️776 - Epoxy 是一套用于在 Swift 中构建 UIKit 应用程序的声明式 UI 框架。


## UI

* :heart: [Hero](https://github.com/HeroTransitions/Hero) ⭐️20.5K - Hero is a library for building iOS view controller transitions.
* [Material](https://github.com/CosmicMind/Material) ⭐️11.9K - 用于创建漂亮应用程序的 UI/UX 框架。
* [Sejima](https://github.com/MoveUpwards/Sejima) ⭐️63 - User Interface Library components for iOS.
* [FlourishUI](https://github.com/unicorn/FlourishUI)  ⭐️224 - Framework for modals, color exensions and buttons.
* [SectionedSlider](https://github.com/LeonardoCardoso/SectionedSlider) - iOS 11 Control Center Slider.
* [Cupcake](https://github.com/nerdycat/Cupcake) ⭐️281 - An easy way to create and layout UI components for iOS.
* [EZSwipeController](https://github.com/goktugyil/EZSwipeController) ⭐️849 -  UIPageViewController like Snapchat/Tinder/iOS Main Pages


### Alert 弹窗、Toast

* :heart: [Siren](https://github.com/ArtSabintsev/Siren) ⭐️3.9k - 当应用版本更新时，通知用户并提供 App Store 链接。
* :heart: [SPPermissions](https://github.com/ivanvorobei/SPPermissions) ⭐️4.7K - 通过列表、Dialog 对话框和原生界面的方式向用户请求访问权限。可以检查权限状态。支持 SwiftUI。
* [BulletinBoard](https://github.com/alexisakers/BulletinBoard) ⭐️5.2k - 创建显示在屏幕底部的卡片视图
* [Toast-Swift](https://github.com/scalessec/Toast-Swift) ⭐️3K
* [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages) ⭐️6.3K - A very flexible message bar for iOS written in Swift.
* [WMZDialog](https://github.com/wwmz/WMZDialog) ⭐️800 - 功能最多样式最多的弹窗。
* [XLActionController](https://github.com/xmartlabs/XLActionController) ⭐️3K
* [PopupView](https://github.com/exyte/PopupView) 【SwiftUI】⭐️1.1K
* [Ribbon](https://github.com/chriszielinski/Ribbon) - 🎀 A simple cross-platform toolbar/custom input accessory view library for iOS & macOS.
* [SimpleAlert](https://github.com/KyoheiG3/SimpleAlert) - Customizable simple Alert and simple ActionSheet for Swift
* [EZAlertController](https://github.com/thellimist/EZAlertController) - Easy Swift UIAlertController
* [TTGSnackbar](https://github.com/zekunyan/TTGSnackbar) ⭐️579
* [SweetAlert-iOS](https://github.com/codestergit/SweetAlert-iOS) ⭐️2K - 带动画效果弹窗封装类。


### 活动指示器、UIActivityIndicatorView

* [ninjaprox/NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) ⭐️10K
* [SwiftOverlays](https://github.com/peterprokop/SwiftOverlays) ⭐️628 - GUI library for displaying various popups and notifications.
* [SendIndicator](https://github.com/LeonardoCardoso/SendIndicator) - 任务指示器。
* [EZLoadingActivity](https://github.com/goktugyil/EZLoadingActivity) - Lightweight loading activity HUD
* [Hokusai](https://github.com/ytakzk/Hokusai) ⭐️431 - A library for a cool bouncy action sheet


### 启动引导页

* [SwiftyOnboard](https://github.com/juanpablofernandez/SwiftyOnboard) ⭐️1k
* [BWWalkthrough](https://github.com/ariok/BWWalkthrough) ⭐️2.8K - 界面切换中加入灵动的动画效果。
* [VideoSplashKit](https://github.com/sahin/VideoSplashKit) - 用于创建简单的背景视频介绍页面的 UIViewController 库
* [Onboard](https://github.com/mamaral/Onboard) ⭐️6.5K

### 分页菜单、UISegmentedControl

* :heart: [JXSegmentedView](https://github.com/pujiaxin33/JXSegmentedView) ⭐️1.9K - 分类切换滚动视图
* 【Archived】[PagingMenuController](https://github.com/kitasuke/PagingMenuController) ⭐️2.5K - Paging view controller with customizable menu in Swift
* [twicketapp/TwicketSegmentedControl](https://github.com/twicketapp/TwicketSegmentedControl) ⭐️1.7K


### 表单

* :heart: [Eureka](https://github.com/xmartlabs/Eureka) ⭐️11.3K - iOS 表单框架，是 XLForm 的 Swift 版本。
* 【Archived】[SwiftForms](https://github.com/ortuman/SwiftForms) ⭐️1.3K - 表单递交库，快速开发利器

### 日历/图表

* [Charts](https://github.com/danielgindi/Charts) ⭐️24.8K - A powerful chart / graph framework, the iOS equivalent to [MPAndroidChart](https://github.com/PhilJay/MPAndroidChart).
* [FSCalendar](https://github.com/WenchaoD/FSCalendar) ⭐️9.8K - 一个完全可定制的iOS日历库，与 Objective-C 和 Swift 兼容。
* [PNChart-Swift](https://github.com/kevinzhow/PNChart-Swift) ⭐️1.4K - 带动画效果的图表控件库。
* [CrispyCalendar](https://github.com/CleverPumpkin/CrispyCalendar) ⭐️312 - 日历 UI 框架。


### Tag

* [TagListView](https://github.com/xhacker/TagListView) ⭐️2.3K - Simple but highly customizable iOS tag list view.
* [TagCellLayout](https://github.com/riteshhgupta/TagCellLayout) ⭐️297 - UICollectionView layout for Tags with Left, Center & Right alignments.



### UINavigationContoller

* [SlideMenuControllerSwift](https://github.com/dekatotoro/SlideMenuControllerSwift) ⭐️3.3K - 基于 Google + ，iQON，Feedly，Ameba iOS 应用的 iOS 侧划抽屉菜单视图。
* [SAHistoryNavigationViewController](https://github.com/szk-atmosphere/SAHistoryNavigationViewController) ⭐️1.6K - 在 UINavigationContoller 中实现了类似iOS任务管理器的用户界面，支持3DTouch。
* [Interactive Side Menu](https://github.com/handsomecode/InteractiveSideMenu) - Customizable iOS Interactive Side Menu written in Swift 3.0.



### UINavigationBar 

* [AMScrollingNavbar](https://github.com/andreamazz/AMScrollingNavbar) ⭐️6k - 可滚动的 UINavigationBar，跟随 UIScrollView 的滚动。



### UIDevice
* [DeviceKit](https://github.com/devicekit/DeviceKit) ⭐️3.5k


### UILabel



### UIButton
* [LGButton](https://github.com/loregr/LGButton) ⭐️2K，一个完全可定制的原生 UIControl 子类，它允许您创建漂亮的按钮，而无需编写任何代码。
* [NFDownloadButton](https://github.com/LeonardoCardoso/NFDownloadButton) - Revamped Download Button.
* [SwiftyButton](https://github.com/TakeScoop/SwiftyButton) - Simple and customizable button in Swift

### UITextField、UITextView
* [HTYTextField](https://github.com/hanton/HTYTextField) - A UITextField with bouncy placeholder in Swift.
* [NextGrowingTextView](https://github.com/muukii/NextGrowingTextView) ⭐️1.5K
* [InputBarAccessoryView](https://github.com/nathantannar4/InputBarAccessoryView) ⭐️880 一个简单和容易定制的输入框辅助视图（InputAccessoryView），用于实现具有自动完成和附件功能的强大的输入框。
* [FloatLabelFields](https://github.com/FahimF/FloatLabelFields) ⭐️1.2K - 浮动标签输入效果类。

### UITabBar
* :heart: [animated-tab-bar](https://github.com/Ramotion/animated-tab-bar) ⭐️10.9K 灵动的动画标签栏类库。




### UITableView

* [WobbleView](https://github.com/inFullMobile/WobbleView) ⭐️2.2K - Implementation of wobble effect for any view in app.

### UICollection
* [IGListKit](https://github.com/Instagram/IGListKit) ⭐️12K 一个数据驱动的 UICollectionView 框架，用于构建快速而灵活的列表。 
* [CollectionKit](https://github.com/SoySauceLab/CollectionKit)
* [AnimatedCollectionViewLayout](https://github.com/KelvinJin/AnimatedCollectionViewLayout)
* [MagazineLayout](https://github.com/airbnb/MagazineLayout) ⭐️3K - A collection view layout capable of laying out views in vertically scrolling grids and lists.
* [KelvinJin/AnimatedCollectionViewLayout](https://github.com/KelvinJin/AnimatedCollectionViewLayout) ⭐️4.3K




### UIStackView


### UIScrollView


### UIProgress

* [KYCircularProgress](https://github.com/kentya6/KYCircularProgress) ⭐️1.1K - 简单、实用路径可定制进度条。


## 文件

* [FileKit](https://github.com/nvzqz/FileKit/) ⭐️2.2K - Swift 中简单易懂的文件管理。
* [PathKit](https://github.com/kylef/PathKit) ⭐️1.3K - 小而美的路径管理类


## Extensions

* :heart: [SwifterSwift/SwifterSwift](https://github.com/SwifterSwift/SwifterSwift) ⭐️ 10.4k — 包含 500 多个原生 Swift 扩展的便捷集合，以提高你的工作效率。
* [Then](https://github.com/devxoul/Then) ⭐️3.6K - 为 Swift 初始化方法提供甜蜜的语法糖
* [Dollar.swift](https://github.com/ankurp/Dollar.swift) - A functional tool-belt for Swift Language similar to Lo-Dash or Underscore in Javascript.
* [swiftz](https://github.com/maxpow4h/swiftz) - A Swift library for functional programming.
* [ExSwift](https://github.com/pNre/ExSwift) - JavaScript (Lo-Dash, Underscore) & Ruby inspired set of Swift extensions for standard types and classes.
* [Observable-Swift](https://github.com/slazyk/Observable-Swift) - Value Observing and Events for Swift.
* [Pythonic.swift](https://github.com/practicalswift/Pythonic.swift) - Pythonic tool-belt for Swift – a Swift implementation of selected parts of Python standard library.
* [SWRoute](https://github.com/rodionovd/SWRoute) - A tiny Swift wrapper. Allows you to route (hook) quite any function/method with another function/method or even a closure.
* [Euler](https://github.com/mattt/Euler) - Swift Custom Operators for Mathematical Notation.
* [swix](https://github.com/scottsievert/swix) - Swift Matrix and Machine Learning Library.
* [Easy-Cal-Swift](https://github.com/onevcat/Easy-Cal-Swift) - Overload +-*/ operator for Swift, make it easier to use (and not so strict).
* [AlecrimCoreData](https://github.com/Alecrim/AlecrimCoreData) - A simple Core Data wrapper library written in Swift.
* [SwiftState](https://github.com/inamiy/SwiftState) - Elegant state machine for Swift.
* [LlamaKit](https://github.com/LlamaKit/LlamaKit) - Collection of must-have functional Swift tools.
* [Basis](https://github.com/typelift/Basis) - A number of foundational functions, types, and typeclasses.
* [CAAnimation + Closure](https://github.com/honghaoz/Swift-CAAnimation-Closure) - Add start / completion closures for CAAnimation instances
* [SwiftyUserDefaults](https://github.com/radex/SwiftyUserDefaults) — a cleaner, swiftier API for NSUserDefaults
* [Pluralize.swift](https://github.com/joshualat/Pluralize.swift) - Great Swift String Pluralize Extension
* [SwiftSequence](https://github.com/oisdk/SwiftSequence) - A μframework of extensions for SequenceType in Swift 2.0, inspired by Python's itertools, Haskell's standard library, and other things.
* [BrightFutures](https://github.com/Thomvis/BrightFutures) - Write great asynchronous code in Swift using futures and promises.
* [EZSwiftExtensions](https://github.com/goktugyil/EZSwiftExtensions) - :smirk: How Swift standard types and classes were supposed to work.
* [BFKit-Swift](https://github.com/FabrizioBrancati/BFKit-Swift) - A collection of useful classes to develop Apps faster.
* [Sugar](https://github.com/hyperoslo/Sugar) - Something sweet that goes great with your Cocoa.
* [ZamzamKit](https://github.com/ZamzamInc/ZamzamKit) - A collection of micro utilities and extensions for Standard Library, Foundation and UIKit.
* [Bow](https://github.com/bow-swift/bow) - Companion library for Typed Functional Programming in Swift.
* [SwiftCoroutine](https://github.com/belozierov/SwiftCoroutine) - Swift coroutines for iOS and macOS.



## 正则表达式

* [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit) ⭐️4.3K - 一个用于解析、格式化和验证国际电话号码的 Swift 框架。




## 颜色&深色模式&主题

* [SwiftTheme](https://github.com/wxxsw/SwiftTheme) ⭐️2.2k Powerful theme/skin manager for iOS 8+ 主题/换肤，暗色模式
* [FluentDarkModeKit](https://github.com/microsoft/FluentDarkModeKit) ⭐️1.6K - 微软开源的 Dark Mode 框架
* [DKNightVersion](https://github.com/draveness/DKNightVersion) ⭐️3.6K
* [Hue](https://github.com/zenangst/Hue) ⭐️3.3K - Hue is the all-in-one coloring utility that you'll ever need.
* [DynamicColor](https://github.com/yannickl/DynamicColor) ⭐️2.7K - Yet another extension to manipulate colors easily in Swift and SwiftUI
* [SwiftColors](https://github.com/thii/SwiftColors) - HEX color handling as an extension for UIColor.


## 时间



## 动画
* [Spring](https://github.com/MengTo/Spring) ⭐️13.9K
* [EasyAnimation](https://github.com/icanzilb/EasyAnimation) ⭐️2.9K
* [lottie-ios](https://github.com/airbnb/lottie-ios) ⭐️22.2K - Airbnb 开源的一个动画渲染库，用于渲染播放 After Effects 矢量动画。
* [Ramotion/folding-cell](https://github.com/Ramotion/folding-cell) ⭐️10K
* [Gemini](https://github.com/shoheiyokoyama/Gemini) ⭐️3K - Gemini is rich scroll based animation framework for iOS, written in Swift.
* 【Archived】[pop](https://github.com/facebookarchive/pop) ⭐️19.8K - 一个可扩展的 iOS 和 osx 动画库，对基于物理的交互很有用。



参考：
* [10 个让你相见恨晚的 iOS Swift 动画框架！](https://juejin.cn/post/6844903789833486350)
* [30 个让你眼前一亮的 iOS Swift UI 控件！](https://juejin.cn/post/6844903781855936519)



## 数据库
*使用 Swift 语言实现的数据库*

* [Realm](https://github.com/realm/realm-cocoa) - 志向代替 Core Data 和 SQLite 的移动数据库。
* [SQLite.swift](https://github.com/stephencelis/SQLite.swift) - 简单、轻量，使用上最 SQL 的 SQLite 封装库。
* [SwiftData](https://github.com/ryanfowler/SwiftData) - A simple and effective wrapper around the SQLite3 C API written completely in Swift.
* [Squeal](https://github.com/nerdyc/Squeal) - A Swift wrapper for SQLite databases.
* [SQLiteDB](https://github.com/FahimF/SQLiteDB) - Basic SQLite wrapper for Swift.
* [SwiftMongoDB](https://github.com/Danappelxx/SwiftMongoDB) - A Swift driver for MongoDB.
* [ModelAssistant](https://github.com/ssamadgh/ModelAssistant) - Elegant library to manage the interactions between view and model in Swift.
* [PostgresClientKit](https://github.com/codewinsdotcom/PostgresClientKit) - A PostgreSQL client library for Swift. Does not require libpq.


## 缓存

* [HanekeSwift](https://github.com/Haneke/HanekeSwift) - A lightweight generic cache for iOS written in Swift with extra love for images.
* [Carlos](https://github.com/WeltN24/Carlos) - A simple but flexible cache for iOS and WatchOS 2 apps, written in Swift.


## Events
*用于一对多（one-to-many）通信的框架*

* [Caravel](https://github.com/coshx/caravel) - A Swift event bus for UIWebView and JS
* [EmitterKit](https://github.com/aleclarson/emitter-kit) - An elegant event framework built in Swift
* [Swift-Custom-Events](https://github.com/StephenHaney/Swift-Custom-Events) - A very simple way to implement Backbone.js style custom event listeners and triggering in Swift for iOS development.
* [Kugel](https://github.com/TakeScoop/Kugel) - A glorious Swift wrapper around NSNotificationCenter

## Queue
*用于处理事件队列和任务队列的框架。*

* [TaskQueue](https://github.com/icanzilb/TaskQueue) ⭐️673 - A Task Queue Class developed in Swift。
* [Dispatcher](https://github.com/aleclarson/dispatcher) ⭐️110 - Queues, timers, and task groups in Swift
* [GCDKit](https://github.com/JohnEstropia/GCDKit) ⭐️317 - Grand Central Dispatch simplified with Swift.
* [BrightFutures](https://github.com/Thomvis/BrightFutures) ⭐️1.9K - 漫长或复杂计算由独立线程异步来完成


### 异步编程

* [PromiseKit](https://github.com/mxcl/PromiseKit) ⭐️13.7K - A delightful Promises implementation for iOS.
* [Async](https://github.com/duemunk/Async) ⭐️4.6K - Syntactic sugar in Swift for asynchronous dispatches in Grand Central Dispatch.
* [SwiftTask](https://github.com/ReactKit/SwiftTask) ⭐️1.9K - Promise + progress + pause + cancel + retry for Swift.
* [Promissum](https://github.com/tomlokhorst/Promissum) ⭐️67 - Promise library with functional combinators like `map`, `flatMap`, `whenAll` & `whenAny`.
* [PureFutures](https://github.com/wiruzx/PureFutures) ⭐️17 - Futures and Promises library


推荐阅读：
* [【译】SE-0296 Async/await](https://kemchenj.github.io/2021-03-06/)
* [Swift 5.5 带来了 async/await 和 actor 支持](https://juejin.cn/post/6975036374105718820)
* [Swift 并发初步](https://onevcat.com/2021/07/swift-concurrency/#%E5%B0%8F%E7%BB%93)
* [Swift 结构化并发](https://onevcat.com/2021/09/structured-concurrency/#%E5%B0%8F%E7%BB%93)



## 数据结构&算法&安全
*用于生成安全随机数、加密数据和扫描漏洞的框架*

* :heart: [wift-algorithms](https://github.com/apple/swift-algorithms) ⭐️3.7K - Apple 官方维护的一套 Swift 中常用的序列和集合算法。
* [swift-collections](https://github.com/apple/swift-collections) ⭐️1.9K - Swift 常用的数据结构。
* [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) ⭐️8.8K - CryptoSwift 是一个用 Swift 实现的标准和安全的密码算法集合。
* [SHA256-Swift](https://github.com/CryptoCoinSwift/SHA256-Swift) - Swift framework wrapping CommonCrypto's SHA256 methods.
* [SwiftSSL](https://github.com/SwiftP2P/SwiftSSL) - An Elegant crypto toolkit in Swift.
* [SwiftyRSA](https://github.com/TakeScoop/SwiftyRSA) - RSA public/private key encryption in Swift
* [Surge](https://github.com/Jounce/Surge) ⭐️4.9K - 使用 Accelerate 框架的 Swift 库，为矩阵数学、数字信号处理和图像处理提供高性能函数。
* [Euler](https://github.com/mattt/Euler) ⭐️1.1K - 直观、简洁的数学表达式 `∛27÷3+∑[3,1,2]`。
* [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) ⭐️6k - Keychain 钥匙串访问。
* [SwiftPasscodeLock](https://github.com/yankodimitrov/SwiftPasscodeLock) ⭐️672 - 一个用 Swift 写的 TouchID 身份验证的 iOS 密码锁。
* [Algorithm-Guide](https://github.com/Xunzhuo/Algorithm-Guide) ⭐️1.4K - 循卓的算法与数据结构教程。



## 音频
* [AudioKit](https://github.com/audiokit/AudioKit) - Audio synthesis, processing, and analysis platform
* [MusicKit](https://github.com/benzguo/MusicKit) - Framework and DSL for creating, analyzing, and transforming music in Swift
* [WebMIDIKit](https://github.com/adamnemecek/WebMIDIKit/) - Simplest MIDI Swift framework


## 视频



## 通知中心

* [LNRSimpleNotifications](https://github.com/LISNR/LNRSimpleNotifications) - Simple Swift in-app notifications
* [Notie](https://github.com/thii/Notie) - In-app notification in Swift, with customizable buttons and input text field.



## 定位&地图

* [LocationManager](https://github.com/jimmyjose-dev/LocationManager) ⭐️721 - 地理位置管理封装库。
* [MapManager](https://github.com/jimmyjose-dev/MapManager) ⭐️411 - 地图及路径管理封装库。



## 相机&相册&二维码

* [ImagePicker](https://github.com/hyperoslo/ImagePicker) ⭐️4.6K - A nicely designed and super easy to use ImagePicker. :camera:
* [EFQRCode](https://github.com/EyreFree/EFQRCode) ⭐️4.1K - A better way to operate quick response code in Swift.
* [swiftScan](https://github.com/MxABC/swiftScan) ⭐️1.4K - iOS 二维码、条形码 Swift 版本


## 即时通讯 IM

* [MessageKit](https://github.com/MessageKit/MessageKit) ⭐️5K
* [aurora-imui](https://github.com/jpush/aurora-imui) ⭐️5.5K - 通用 IM 聊天 UI 组件，已经同时支持 Android/iOS/RN
* [Messenger](https://github.com/relatedcode/Messenger) ⭐️4.2k - Open source, native iOS Messenger, with realtime chat conversations (full offline support).



## Misc

* [acli](https://github.com/eugenpirogoff/acli) - commandline tool to download curated libraries from github (very beta)
* [Compass](https://github.com/hyperoslo/Compass) - Compass helps you setup a central navigation system for your application.
* [R.swift](https://github.com/mac-cain13/R.swift/) - tool to get strong typed, autocompleted resources like images and segues in your Swift project
* [SwiftKVC](https://github.com/bradhilton/SwiftKVC) - Key-Value Coding (KVC) for native Swift classes and structs
* [Tactile](https://github.com/delba/Tactile) - A safer and more idiomatic way to respond to gestures and control events.
* [Swift 4 Module Template](https://github.com/fulldecent/swift4-module-template) - An opinionated starting point for awesome, reusable Swift 4 modules
* [SwiftValidators](https://github.com/gkaimakas/SwiftValidators) - String validation for iOS developed in Swift. Inspired by validator.js
* [Versions](https://github.com/zenangst/Versions) - Helping you find inner peace when comparing version numbers in Swift
* [Swift 4 Module Template](https://github.com/fulldecent/swift4-module-template) - An opinionated starting point for awesome, reusable Swift 4 modules


## 调试

* [chisel](https://github.com/facebook/chisel)，⭐️8.7K - FaceBook 开源的 lldb 调试命令集合。
* [FLEX](https://github.com/FLEXTool/FLEX)，⭐️12.6K - Flipboard 开源的一系列在应用中调试的工具集。
* [lowmad](https://github.com/bangerang/lowmad)，一个用于管理 LLDB 中的脚本和配置的命令行工具。


---

推荐阅读：
* [Instruments 使用指南官方文档](https://developer.apple.com/library/archive/documentation/AnalysisTools/Conceptual/instruments_help-collection/Chapter/Chapter.html)
* [Clang Compiler User’s Manual](https://clang.llvm.org/docs/UsersManual.html#diagnostics_pragmas)
* [Advanced Debugging with Xcode and LLDB - WWDC 2018](https://developer.apple.com/videos/play/wwdc2018/412/)



## 测试

*用于测试代码和生成测试数据的框架。*

* :heart: [appium](https://github.com/appium/appium) ⭐️14.3K - iOS，Android 和 Windows 应用程序的**自动化测试框架**。
* [Quick](https://github.com/Quick/Quick) ⭐️9K - 一个行为驱动（behavior-driven）的针对 Swift 和 Objective-C 的测试框架。
* [Sleipnir](https://github.com/railsware/Sleipnir) - A BDD-style framework for Swift.
* [Nimble](https://github.com/Quick/Nimble) - A Matcher Framework for Swift.
* [Fakery](https://github.com/vadymmarkov/Fakery) - Swift fake data generator.
* [SwiftRandom](https://github.com/thellimist/SwiftRandom) - Generator for random data.  
* [MockFive](https://github.com/DeliciousRaspberryPi/MockFive) - A mocking framework for Swift with runtime function stubbing.


### 持续集成&持续交付

* [fastlane](https://fastlane.tools/)
* [Travis CI](https://travis-ci.org/)
* [IBAnimatable](https://github.com/IBAnimatable/IBAnimatable) ⭐️8.6k - 使用 IBAnimatable 为 App Store 应用程序设计和定制原型 UI、交互、导航、过渡和动画 Interface Builder。



## 日志
*用于生成和处理日志文件的框架*

* [XCGLogger](https://github.com/DaveWoodCom/XCGLogger) ⭐️3.7K - 功能完整的日志管理类库。
* [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) ⭐️5.4K - Swift 多彩日志记录。
* [Rainbow](https://github.com/onevcat/Rainbow) ⭐️1.6K - Delightful console output for Swift developers.
* [QorumLogs](https://github.com/goktugyil/QorumLogs) — Swift Logging Utility for Xcode & Google Docs.
* [CleanroomLogger](https://github.com/emaloney/CleanroomLogger) - A configurable and extensible pure Swift logging API that is simple, lightweight and performant.
* [Swell](https://github.com/hubertr/Swell) - A logging utility for Swift and Objective C.
* [Log](https://github.com/delba/Log) - A logging tool with built-in themes, formatters, and a nice API to define your owns.
* [NSLogger](https://github.com/fpillet/NSLogger) - A high perfomance logging utility which displays traces emitted by client applications running on Mac OS X, iOS and Android.


## 文档
*生成文档文件的框架*

* [jazzy](https://github.com/realm/jazzy) - A soulful way to generate docs for Swift & Objective-C
* [SwiftGen](https://github.com/SwiftGen/SwiftGen) ⭐️7.5K - 为你的 assets、storyboards、Localizable.strings 等提供 Swift 代码生成器 - 摆脱所有基于字符串的API!


## 命令行
*用于创建命令行应用程序的框架.*
* [CommandCougar](https://github.com/surfandneptune/CommandCougar) - An elegant pure Swift library for building command line applications.



## 函数式响应式编程
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)
* [ReactKit](https://github.com/ReactKit/ReactKit) - Swift Reactive Programming.
* [ReactiveAPI](https://github.com/sky-uk/ReactiveAPI) - Write clean, concise and declarative network code relying on URLSession, with the power of RxSwift. Inspired by Retrofit.
* [Dollar](https://github.com/ankurp/Dollar) ⭐️4.2K - Swift 版 Lo-Dash (或 underscore) 函数式工具库。

### Combine

> Apple 在 iOS 13 中发布了 [Combine](https://developer.apple.com/documentation/combine) 框架。Combine 是 Apple 的**函数式响应式编程框架**，与 RxSwift 类似，但也有很大不同。Combine 的主要卖点是它是一个第一方框架。这意味着它将由 Apple 维护，并随着 Apple 操作系统的发布而更新，这既有好处，也有缺点。不可否认，Apple 对 Combine 押下重注，值得一看。特别是因为 SwiftUI 大量使用了 Combine。

* [CombineSwiftPlayground](https://github.com/AvdLee/CombineSwiftPlayground)
* [OpenCombine](https://github.com/OpenCombine/OpenCombine)
* [CombineExt](https://github.com/CombineCommunity/CombineExt)
* [swiftui-notes](https://github.com/heckj/swiftui-notes) ⭐️1.4K - 关于用 UIKit 和 SwiftUI 学习 Combine 的笔记。


# 资源

各种资源，如书籍，网站和文章，提高 Swift 开发技能和知识。

## Swift 网站

* [Official website](https://developer.apple.com/swift/) - A home page of Swift programming language.
* [Official blog](https://developer.apple.com/swift/blog/) - Official Swift Blog.
* [Jameson Quave's blog](http://jamesonquave.com/blog/category/swift/) - Tips for everyday work with Swift.
* [Swift Collection on Medium](https://medium.com/swift-programming) - Collection of blog posts about Swift on Medium.
* [Swift Collection on raywenderlich.com](http://www.raywenderlich.com/?s=swift) - Collection of blog posts about Swift on raywenderlich.
* [SwiftInFlux](https://github.com/ksm/SwiftInFlux) - An attempt to gather all that is in flux in Swift.
* [We ❤ Swift](http://www.weheartswift.com/) - Tutorials and guides.
* [Natasha The Robot](http://natashatherobot.com/) - Nice blog about Swift by Natasha The Robot.
* [LearnSwift.tips](http://www.learnswift.tips/) - A curated list of helpful resources to learn Swift. Tutorials, Code Samples, References.
* [Hacking with Swift](https://www.hackingwithswift.com/) - a complete Swift training course that teaches you app development through 36 hands-on projects, for free.
* [SwiftLang](http://swiftlang.eu) - a Swift Resource Center & Community.
* [WWDC-Recap](https://erenkabakci.github.io/WWDC-Recap/) - A collection of session summaries in markdown format, from WWDC 19 & 17.
* [Cocoacasts](https://cocoacasts.com/) - Tutorials and videos about Swift and Cocoa development.

## Swift 书籍

* [The Swift Programming Language](https://itunes.apple.com/us/book/the-swift-programming-language/id881256329?mt=11)
* [Using Swift with Cocoa and Objective-C](https://itunes.apple.com/us/book/using-swift-cocoa-objective/id888894773?mt=11)
* [Swift Standard Library Reference](https://developer.apple.com/library/prerelease/ios/documentation/General/Reference/SwiftStandardLibraryReference/)
* [Learn to Program iOS and OS X with Apple Swift](https://www.kickstarter.com/projects/alanforbes/learn-to-program-ios-and-os-x-with-apple-swift?utm_medium=referral&utm_source=swift.zeef.com%2Frobin.eggenkamp&utm_campaign=ZEEF)

## Swift 视频

* [TheSwiftLanguage youtube channel](https://www.youtube.com/user/TheSwiftLanguage/) - Videos about the Swift programming language by Apple.
* [Brian Advent youtube channel](https://www.youtube.com/channel/UCysEngjfeIYapEER9K8aikw/videos) - High quality Swift tutorials.
* [SkipCasts youtube channel](https://www.youtube.com/user/SkipCasts/videos) - Skip Wilson's casts on Swift.
* [Developing iOS 8 Apps with Swift](https://itunes.apple.com/us/course/developing-ios-8-apps-swift/id961180099) - Stanford course by Paul Hegarty.

## Swift Playgrounds

* [Learn-swift playground](https://github.com/nettlep/learn-swift) - Learn Swift interactively through these playgrounds.
* [Design-Patterns-In-Swift](https://github.com/ochococo/Design-Patterns-In-Swift) - Design Patterns implemented in Swift.
* [SwiftStub](http://swiftstub.com) - an online Swift playground and REPL.

## 编码规范&最佳实践

* :heart: [raywenderlich/swift-style-guide](https://github.com/raywenderlich/swift-style-guide) ⭐️11.8k - Ray Wenderlich 官方 Swift 代码风格指南。[中文版](https://github.com/SketchK/swift-style-guide-by-raywenderlich-in-chinese)
* [airbnb/swift](https://github.com/airbnb/swift) ⭐️1.4k
* [linkedin/swift-style-guide](https://github.com/linkedin/swift-style-guide) ⭐️1.3k
* [github/swift-style-guide](https://github.com/github/swift-style-guide) ⭐️4.7k
* [prolificinteractive/swift-style-guide](https://github.com/prolificinteractive/swift-style-guide)
* [SlideShareInc/swift-style-guide](https://github.com/SlideShareInc/swift-style-guide)
* :heart: [SwiftLint](https://github.com/realm/SwiftLint) ⭐️ 15.4K - A tool to enforce Swift style and conventions.
* [如何编写高性能的 Swift 代码 @Apple](https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst) ⭐️57.8K
* [iOS Good Practices](https://github.com/futurice/ios-good-practices) ⭐️10.4k - iOS 初学者的最佳实践。



## 设计模式

* :heart: [Design Patterns implemented in Swift 5.0](https://github.com/ochococo/Design-Patterns-In-Swift) ⭐️13.1k
* [Trip-to-iOS-Design-Patterns](https://github.com/skyming/Trip-to-iOS-Design-Patterns)

## Swift 版本更新内容

* [swift](https://github.com/apple/swift) ⭐️57.8K - The Swift Programming Language.
* [swift-evolution](https://github.com/apple/swift-evolution) - 这个库用来放置用户对 Swift 的反馈和建议，同时也用来记录 Swift 的重要改变。
* [Swift 编程语言:文档修订历史 @cnswift.org](https://www.cnswift.org/document-revision-history)
* [InfoQ：Swift 5.3 又更新了什么新奇爽快的语法？](https://www.infoq.cn/article/Sv1ropcrVfCefYP707dS)
* [掘金：Swift 5 新特性预览 (最低支持 Xcode 10.2 beta 版)](https://juejin.im/post/6844903767792435208)
* [详解 WWDC 20 SwiftUI 的重大改变及核心优势](https://www.infoq.cn/article/vYYtkGTqkWDJtEYrg0aP?utm_source=related_read_bottom&utm_medium=article)
* [What's new in Swift 2.0](https://www.hackingwithswift.com/swift2)
* [What's new in Swift 2.2](https://www.hackingwithswift.com/swift2-2)
* [What's new in Swift 3.0](https://www.hackingwithswift.com/swift3)
* [What's new in Swift 3.1](https://www.hackingwithswift.com/swift3-1)
* [What's new in Swift 4.0](https://www.hackingwithswift.com/swift4)
* [What’s new in Swift 5.2](https://www.hackingwithswift.com/articles/212/whats-new-in-swift-5-2)



# 其他 Awesome 列表

* [awesome-ios](https://github.com/vsouza/awesome-ios) ⭐️38.5K - vsouza 发起维护的 iOS 资源列表，内容包括：框架、组件、测试、Apple Store、SDK、XCode、网站、书籍等。
* [awesome-swift@matteocrippa](https://github.com/matteocrippa/awesome-swift) ⭐️21.3K - Swift 库和资源的集合。
* [awesome-swift@Wolg](https://github.com/Wolg/awesome-swift) ⭐️5.2K
* [robin.eggenkamp](https://swift.zeef.com/robin.eggenkamp)
* [TimLiu-iOS](https://github.com/Tim9Liu9/TimLiu-iOS) ⭐️10.9K - iOS 开发常用三方库、插件、知名博客等等。
* [trip-to-iOS](https://github.com/Aufree/trip-to-iOS) ⭐️7.8K - iOS 学习资料整理。
* [awesome-ios-cn](https://github.com/jobbole/awesome-ios-cn) ⭐️4K - iOS 资源大全中文版，内容包括：框架、组件、测试、Apple Store、SDK、Xcode、网站、书籍等。
[kechengsou/awesome-ios](https://github.com/kechengsou/awesome-ios) ⭐️300 - iOS 开发者资源大全
