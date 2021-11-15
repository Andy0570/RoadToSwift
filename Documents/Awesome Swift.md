[TOC]


# Awesome Swift
精心编写的 Swift 框架、库和软件集合。

## 网络

### HTTP

* :heart: [Alamofire/Alamofire](https://github.com/Alamofire/Alamofire) ⭐️36.7k - Alamofire 是 AFNetworking 的作者 mattt 新写的网络请求的 swift 库。[Alamofire 最佳实践](https://github.com/ipader/SwiftGuide/wiki/Alamofire%20%E6%9C%80%E4%BD%B3%E5%AE%9E%E8%B7%B5)
* [Moya](https://github.com/ashfurrow/Moya) - 对 Alamofire 的封装，使用枚举将网络层实现细节与页面逻辑代码分离，方便单元测试，支持 stub 测试，配合 RxSwift 食用更佳
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
* [Starscream](https://github.com/daltoniam/starscream) ⭐️7.1K - Websockets in swift for iOS and OSX.
* [SwiftWebSocket](https://github.com/tidwall/SwiftWebSocket) ⭐️1.5K - Fast Websockets in Swift for iOS and OSX.
* [SocketRocket](https://github.com/facebookarchive/SocketRocket) ⭐️9.3k - A conforming Objective-C WebSocket client library.


### OAuth
* [OAuthSwift](https://github.com/dongri/OAuthSwift) - Swift based OAuth library for iOS


### 网络图片
* [Kingfisher](https://github.com/onevcat/Kingfisher) ⭐️19.3K - 轻量级，纯 Swift 实现的网络图片下载和缓存框架。
* [KingfisherWebP](https://github.com/Yeatse/KingfisherWebP) - WebP 图片解码
* [Nuke](https://github.com/kean/Nuke) ⭐️6.4K - Advanced framework for loading and caching images


## JSON/XML 操作

* :heart: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) ⭐️21K - Swift 下的 JSON 解析框架。
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
* [Cartography](https://github.com/robb/Cartography) ⭐️7.3k - 用于Swift的声明性自动布局DSL
* [PinLayout](https://github.com/mirego/PinLayout) ⭐️1.8k - Extremely Fast views layouting without auto layout. No magic, pure code, full control and blazing fast. Concise syntax, intuitive, readable & chainable.



## UI

* [Material](https://github.com/CosmicMind/Material) ⭐️11.9K - 用于创建漂亮应用程序的 UI/UX 框架。
* [Sejima](https://github.com/MoveUpwards/Sejima) - User Interface Library components for iOS.
* [Eureka](https://github.com/xmartlabs/Eureka) - Elegant iOS Forms in pure Swift.
* [XLActionController](https://github.com/xmartlabs/XLActionController) - Fully customizable and extensible action sheet controller written in Swift.
* [FlourishUI](https://github.com/unicorn/FlourishUI) - Framework for modals, color exensions and buttons.
* [SwiftColors](https://github.com/thii/SwiftColors) - HEX color handling as an extension for UIColor.
* [FontAwesome.swift](https://github.com/thii/FontAwesome.swift) - Use FontAwesome in your Swift projects.
* [SwiftOverlays](https://github.com/peterprokop/SwiftOverlays) - GUI library for displaying various popups and notifications.
* [ios-charts](https://github.com/danielgindi/ios-charts) - A powerful chart / graph framework, the iOS equivalent to [MPAndroidChart](https://github.com/PhilJay/MPAndroidChart).
* [TagCellLayout](https://github.com/riteshhgupta/TagCellLayout) - UICollectionView layout for Tags with Left, Center & Right alignments.
* [TagListView](https://github.com/xhacker/TagListView) - Simple but highly customizable iOS tag list view.
* [Swiftstraints](https://github.com/Skyvive/Swiftstraints) - Powerful auto-layout framework that lets you write constraints in one line of code.
* [PagingMenuController](https://github.com/kitasuke/PagingMenuController) - Paging view controller with customizable menu in Swift
* [GaugeKit](https://github.com/skywinder/GaugeKit) - Customizable gauges. Easy reproduce Apple's style gauges.
* [Hokusai](https://github.com/ytakzk/Hokusai) - A library for a cool bouncy action sheet
* [LNRSimpleNotifications](https://github.com/LISNR/LNRSimpleNotifications) - Simple Swift in-app notifications
* [GoogleMaterialIconFont](https://github.com/kitasuke/GoogleMaterialIconFont) - Google Material Icon Font for Swift and ObjC.
* [CozyLoadingActivity](https://github.com/goktugyil/CozyLoadingActivity) - Lightweight loading activity HUD
* [VideoSplash](https://github.com/toygar/VideoSplash.git) - Video based UIViewController
* [EZSwipeController](https://github.com/goktugyil/EZSwipeController)- :point_up_2: UIPageViewController like Snapchat/Tinder/iOS Main Pages
* [ImagePicker](https://github.com/hyperoslo/ImagePicker) - A nicely designed and super easy to use ImagePicker. :camera:
* [Notie](https://github.com/thii/Notie) - In-app notification in Swift, with customizable buttons and input text field.
* [Whisper](https://github.com/hyperoslo/Whisper) - Break the silence of your UI, whispering, shouting or whistling at it
* [SwiftPasscodeLock](https://github.com/velikanov/SwiftPasscodeLock) - An iOS passcode lock with TouchID authentication written in Swift.
* [SlideMenuControllerSwift](https://github.com/dekatotoro/SlideMenuControllerSwift) - iOS Slide Menu View based on Google+, iQON, Feedly, Ameba iOS app. It is written in pure swift.
* [Hue](https://github.com/hyperoslo/Hue) - Hue is the all-in-one coloring utility that you'll ever need.
* [SAHistoryNavigationViewController](https://github.com/szk-atmosphere/SAHistoryNavigationViewController) - SAHistoryNavigationViewController realizes iOS task manager like UI in UINavigationContoller.
* [WobbleView](https://github.com/inFullMobile/WobbleView) - Implementation of wobble effect for any view in app.
* [Interactive Side Menu](https://github.com/handsomecode/InteractiveSideMenu) - Customizable iOS Interactive Side Menu written in Swift 3.0.
* [EFQRCode](https://github.com/EyreFree/EFQRCode) - A better way to operate quick response code in Swift.
* [SendIndicator](https://github.com/LeonardoCardoso/SendIndicator) - Yet another task indicator.
* [SectionedSlider](https://github.com/LeonardoCardoso/SectionedSlider) - Control Center Slider.
* [Cupcake](https://github.com/nerdycat/Cupcake) - An easy way to create and layout UI components for iOS.
* [Gemini](https://github.com/shoheiyokoyama/Gemini) - Gemini is rich scroll based animation framework for iOS, written in Swift.
* [Hero](https://github.com/HeroTransitions/Hero) - Hero is a library for building iOS view controller transitions.



### HUD、Alert、Toast

* :heart: [Siren](https://github.com/ArtSabintsev/Siren) ⭐️3.9k - 应用版本更新提示
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



### 启动引导页
* [SwiftyOnboard](https://github.com/juanpablofernandez/SwiftyOnboard) ⭐️1k


### UIDevice
* [DeviceKit](https://github.com/devicekit/DeviceKit) ⭐️3.5k


### UILabel



### UIButton
* [NFDownloadButton](https://github.com/LeonardoCardoso/NFDownloadButton) - Revamped Download Button.
* [SwiftyButton](https://github.com/TakeScoop/SwiftyButton) - Simple and customizable button in Swift

### UITextField、UITextView
* [HTYTextField](https://github.com/hanton/HTYTextField) - A UITextField with bouncy placeholder in Swift.
* [NextGrowingTextView](https://github.com/muukii/NextGrowingTextView) ⭐️1.5K
* [InputBarAccessoryView](https://github.com/nathantannar4/InputBarAccessoryView) ⭐️880 一个简单和容易定制的输入框辅助视图（InputAccessoryView），用于实现具有自动完成和附件功能的强大的输入框。

### UITabBar
* [animated-tab-bar](https://github.com/Ramotion/animated-tab-bar) 【SwiftUI】为 iOS tabbar 和图标添加动画。

### UISegmentedControl
* :heart: [JXSegmentedView](https://github.com/pujiaxin33/JXSegmentedView) ⭐️1.9K - 分类切换滚动视图
* [twicketapp/TwicketSegmentedControl](https://github.com/twicketapp/TwicketSegmentedControl) ⭐️1.7K

### UITableView
* :heart: [Eureka](https://github.com/xmartlabs/Eureka) ⭐️11.3K - iOS 表单框架，是 XLForm 的 Swift 版本。


### UICollection
* [IGListKit](https://github.com/Instagram/IGListKit) ⭐️12K 一个数据驱动的 UICollectionView 框架，用于构建快速而灵活的列表。 
* [CollectionKit](https://github.com/SoySauceLab/CollectionKit)
* [AnimatedCollectionViewLayout](https://github.com/KelvinJin/AnimatedCollectionViewLayout)
* [MagazineLayout](https://github.com/airbnb/MagazineLayout)
* [KelvinJin/AnimatedCollectionViewLayout](https://github.com/KelvinJin/AnimatedCollectionViewLayout) ⭐️4.3K


### UIStackView


### UIScrollView


### 日历/图表

* [CrispyCalendar](https://github.com/CleverPumpkin/CrispyCalendar) - CrispyCalendar is the calendar UI framework.


## 文件

* [FileKit](https://github.com/nvzqz/FileKit/) - Simple and expressive file management in Swift.


## Extensions

* :heart: [SwifterSwift/SwifterSwift](https://github.com/SwifterSwift/SwifterSwift) ⭐️ 10.4k — 包含 500 多个原生 Swift 扩展的便捷集合，以提高你的工作效率。
* [Then](https://github.com/devxoul/Then) ⭐️3.6K - 为Swift初始化器提供甜蜜的语法糖
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


### 异步编程
Swift中的异步编程参考：[【译】SE-0296 Async/await](https://kemchenj.github.io/2021-03-06/)

* [PromiseKit](https://github.com/mxcl/PromiseKit) - A delightful Promises implementation for iOS.
* [Promissum](https://github.com/tomlokhorst/Promissum) - Promise library with functional combinators like `map`, `flatMap`, `whenAll` & `whenAny`.
* [Promise](https://github.com/Coneko/Promise) - Simple promises library in Swift.
* [PureFutures](https://github.com/wiruzx/PureFutures) - Futures and Promises library
* [SwiftTask](https://github.com/ReactKit/SwiftTask) - Promise + progress + pause + cancel, using SwiftState (state machine).
* [Async](https://github.com/duemunk/Async) - Syntactic sugar in Swift for asynchronous dispatches in Grand Central Dispatch.


## 正则表达式

* [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit) ⭐️4.3K - 一个用于解析、格式化和验证国际电话号码的 Swift 框架。




## 颜色&深色模式&主题

* [SwiftTheme](https://github.com/wxxsw/SwiftTheme) ⭐️2.2k Powerful theme/skin manager for iOS 8+ 主题/换肤，暗色模式
* [FluentDarkModeKit](https://github.com/microsoft/FluentDarkModeKit) ⭐️1.6K - 微软开源的 Dark Mode 框架
* [DKNightVersion](https://github.com/draveness/DKNightVersion) ⭐️3.6K
* [Hue](https://github.com/zenangst/Hue) ⭐️3.3K - Hue is the all-in-one coloring utility that you'll ever need.
* [DynamicColor](https://github.com/yannickl/DynamicColor) ⭐️2.7K - Yet another extension to manipulate colors easily in Swift and SwiftUI


## 时间




## 动画

* [Spring](https://github.com/MengTo/Spring) ⭐️13.9K
* [ninjaprox/NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) ⭐️10K
* [lottie-ios](https://github.com/airbnb/lottie-ios) ⭐️22.2K - Airbnb 开源的一个动画渲染库，用于渲染播放 After Effects 矢量动画。
* [EasyAnimation](https://github.com/icanzilb/EasyAnimation) ⭐️2500+
* [Ramotion/folding-cell](https://github.com/Ramotion/folding-cell) ⭐️10K



## 数据库
*使用 Swift 语言实现的数据库*

* [Realm](https://github.com/realm/realm-cocoa) - A mobile database that runs directly inside phones, tablets or wearables.
* [SQLite.swift](https://github.com/stephencelis/SQLite.swift) - A pure Swift framework wrapping SQLite3. Small. Simple. Safe.
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

* [TaskQueue](https://github.com/icanzilb/TaskQueue) - A Task Queue Class developed in Swift.
* [Dispatcher](https://github.com/aleclarson/dispatcher) - Queues, timers, and task groups in Swift
* [GCDKit](https://github.com/JohnEstropia/GCDKit) - Grand Central Dispatch simplified with Swift.



## 安全
*用于生成安全随机数、加密数据和扫描漏洞的框架*

* [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) ⭐️6k - Keychain 钥匙串访问。
* [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) - Crypto related functions and helpers for Swift implemented in Swift programming language. #Swift算法
* [SHA256-Swift](https://github.com/CryptoCoinSwift/SHA256-Swift) - Swift framework wrapping CommonCrypto's SHA256 methods.
* [SwiftSSL](https://github.com/SwiftP2P/SwiftSSL) - An Elegant crypto toolkit in Swift.
* [SwiftyRSA](https://github.com/TakeScoop/SwiftyRSA) - RSA public/private key encryption in Swift


## 测试
*用于测试代码和生成测试数据的框架。*

* [Quick](https://github.com/Quick/Quick) ⭐️9K - 一个行为驱动（behavior-driven）的针对 Swift 和 Objective-C 的测试框架。
* [Sleipnir](https://github.com/railsware/Sleipnir) - A BDD-style framework for Swift.
* [Nimble](https://github.com/Quick/Nimble) - A Matcher Framework for Swift.
* [Fakery](https://github.com/vadymmarkov/Fakery) - Swift fake data generator.
* [SwiftRandom](https://github.com/thellimist/SwiftRandom) - Generator for random data.  
* [MockFive](https://github.com/DeliciousRaspberryPi/MockFive) - A mocking framework for Swift with runtime function stubbing.


## 日志
*用于生成和处理日志文件的框架*

* [Rainbow](https://github.com/onevcat/Rainbow) ⭐️1.6K - Delightful console output for Swift developers.
* [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) ⭐️5.4K - Swift 多彩日志记录。
* [QorumLogs](https://github.com/goktugyil/QorumLogs) — Swift Logging Utility for Xcode & Google Docs.
* [CleanroomLogger](https://github.com/emaloney/CleanroomLogger) - A configurable and extensible pure Swift logging API that is simple, lightweight and performant.
* [XCGLogger](https://github.com/DaveWoodCom/XCGLogger) - A debug log framework for use in Swift projects.
* [Swell](https://github.com/hubertr/Swell) - A logging utility for Swift and Objective C.
* [Log](https://github.com/delba/Log) - A logging tool with built-in themes, formatters, and a nice API to define your owns.
* [NSLogger](https://github.com/fpillet/NSLogger) - A high perfomance logging utility which displays traces emitted by client applications running on Mac OS X, iOS and Android.


## 文档
*生成文档文件的框架*

* [jazzy](https://github.com/realm/jazzy) - A soulful way to generate docs for Swift & Objective-C
* [](https://github.com/SwiftGen/SwiftGen) ⭐️7.5K - 为你的 assets、storyboards、Localizable.strings 等提供 Swift 代码生成器 - 摆脱所有基于字符串的API!

## 命令行
*用于创建命令行应用程序的框架.*
* [CommandCougar](https://github.com/surfandneptune/CommandCougar) - An elegant pure Swift library for building command line applications.


## 音频
* [AudioKit](https://github.com/audiokit/AudioKit) - Audio synthesis, processing, and analysis platform
* [MusicKit](https://github.com/benzguo/MusicKit) - Framework and DSL for creating, analyzing, and transforming music in Swift
* [WebMIDIKit](https://github.com/adamnemecek/WebMIDIKit/) - Simplest MIDI Swift framework


## 视频



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


## 函数式响应式编程s

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)
* [ReactKit](https://github.com/ReactKit/ReactKit) - Swift Reactive Programming.
* [ReactiveAPI](https://github.com/sky-uk/ReactiveAPI) - Write clean, concise and declarative network code relying on URLSession, with the power of RxSwift. Inspired by Retrofit.


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


## Swift 版本更新内容

* [【译】SE-0296 Async/await](https://kemchenj.github.io/2021-03-06/)
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
