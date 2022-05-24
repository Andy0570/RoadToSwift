# Awesome Swift

精心编写的 Swift 框架、库和软件集合。



> **Notes**：
>
> :heart: Recommend;
> :orange: The framework use Objective-C language and is not recommended for information purposes only;
> :warning: Archived or no longer maintained;
> :star: The Star count for this project on GitHub is for reference only and is not guaranteed to be up to date;




[TOC]

## 网络

[回到顶部](#Awesome Swift)

### HTTP

* :heart: [Alamofire](https://github.com/Alamofire/Alamofire) ⭐️36.7k - Alamofire 是 AFNetworking 的作者 mattt 新写的网络请求的 swift 库。
* :heart: [Moya](https://github.com/ashfurrow/Moya) ⭐️13.6k - 对 Alamofire 的封装，使用枚举将网络层实现细节与页面逻辑代码分离，方便单元测试，支持 stub 测试，配合 RxSwift 食用更佳。[官方中文文档](https://github.com/Moya/Moya/blob/master/Readme_CN.md)
* [SwiftHTTP](https://github.com/daltoniam/SwiftHTTP) ⭐️1.9k - 快速围绕 `NSURLSession` 进行薄包装。简化 HTTP 请求。
* [Swift-http](https://github.com/binarybirds/swift-http) ⭐️47 - 一个很棒的 Swift HTTP 库，可以使用 API 端点快速创建通信层。
* [apple/swift-nio](https://github.com/apple/swift-nio) ⭐️6.8k - SwiftNIO  是一个跨平台的异步事件驱动的网络应用框架，用于快速开发可维护的高性能协议服务器和客户端
* [apple/swift-nio-http2](https://github.com/apple/swift-nio-http2) ⭐️372 - 苹果发布 SwiftNIO 针对 HTTP/2 的开源支持库。
* [Net](https://github.com/nghialv/Net) - HttpRequest wrapper written in Swift.
* [Just](https://github.com/JustHTTP/Just) - HTTP for Humans (python-requests style HTTP library)
* [AeroGear IOS Http](https://github.com/aerogear/aerogear-ios-http/) - is a thin layer to take care of your http requests working with NSURLSession.
* [Siesta](https://bustoutsolutions.github.io/siesta/) - Ends state headaches by providing a resource-centric alternative to the familiar request-centric approach to HTTP.
* [Reachability.Swift](https://github.com/ashleymills/Reachability.swift) ⭐️7.5k - 检测网络可达性的实用工具库。
* [Connectivity](https://github.com/rwbutler/Connectivity) ⭐️1.5k - 基于 Reachability 的封装类库，检查当前 Wi-Fi 互联网连接性及即时状态。
* [vapor-routing](https://github.com/pointfreeco/vapor-routing) ⭐️43 - 具有更多类型安全性和更少麻烦的双向 Vapor 路由器。



### Swift Server

* [vapor](https://github.com/vapor/vapor) ⭐️21.4k - 最活跃的 Web 服务器框架。[Vapor, Perfect, Kitura 比较](https://www.jianshu.com/p/a9ca47e844d7)
* [Perfect](https://github.com/PerfectlySoft/Perfect) ⭐️13.9k - 功能更强大，性能更好的 Web 服务器框架。有完整的[中文开发文档](https://github.com/PerfectlySoft/Perfect/blob/master/README.zh_CN.md)支持。
* [Kitura](https://github.com/Kitura/Kitura) ⭐️7.5k - 与 IBM Bluemix 最佳云集成，功能强大的 Web 服务器框架。CGI 支持。
* [dockSwiftOnARM](https://github.com/helje5/dockSwiftOnARM) ⭐️120 - 将 Swift 编译运行于 ARM 平台 Docker 上。
* [amzn/smoke-framework](https://github.com/amzn/smoke-framework) ⭐️1.3k - 一个用 Swift 编写的轻量级服务器端服务框架。
* [Swifter](https://github.com/glock45/swifter) ⭐️3.4k - an HTTP server engine in Swift.
* [Taylor](https://github.com/izqui/Taylor) ⭐️931 - A lightweight library for writing HTTP web servers with Swift
* [NetworkObjects](https://github.com/colemancda/NetworkObjects) ⭐️266 - Swift 后端/服务器框架（纯 Swift，支持 Linux）。


### Socket

* [socket.io-client-swift](https://github.com/socketio/socket.io-client-swift) ⭐️4.6k
* :warning: [SocketIO-Kit](https://github.com/ricardopereira/SocketIO-Kit) - Socket.io iOS/OSX Client compatible with v1.0 and later
* [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket) ⭐️11.8k


### WebSocket

* [Starscream](https://github.com/daltoniam/starscream) ⭐️7.2k - WebSocket 标准（RFC 6455）客户端库 Swift 实现，依照 `Websocket` 协议，支持 `ws`、`wss` 传输协议，并提供各种消息发送接收方法。
* [SwiftWebSocket](https://github.com/tidwall/SwiftWebSocket) ⭐️1.5k - Fast Websockets in Swift for iOS and OSX.
* [SocketRocket](https://github.com/facebookarchive/SocketRocket) ⭐️9.3k - A conforming Objective-C WebSocket client library.


### OAuth

* [OAuthSwift](https://github.com/dongri/OAuthSwift) ⭐️2.9k - 国外主流网站 OAuth 授权类库。 
* [AppAuth-iOS](https://github.com/openid/AppAuth-iOS) ⭐️1.3k - iOS and macOS SDK for communicating with OAuth 2.0 and OpenID Connect providers.


### MQTT/TCP

* [MQTT-Client-Framework](https://github.com/novastone-media/MQTT-Client-Framework) ⭐️1.7k - iOS, macOS, tvOS native ObjectiveC MQTT Client Framework
* [CocoaMQTT](https://github.com/emqx/CocoaMQTT) ⭐️1.2k - MQTT 5.0 Client Library for iOS and macOS written in Swift
* [xquic](https://github.com/alibaba/xquic) ⭐️581 - **XQUIC 是基于 IETF QUIC 协议实现的 UDP 传输框架**，包含加密可靠传输、HTTP/3 两大块主要内容，为应用提供可靠、安全、高效的数据传输功能，可以极大改善弱网和移动网络下产品的用户网络体验。
* [kcp](https://github.com/skywind3000/kcp) ⭐️10.9k - KCP 是一个快速可靠协议，能以比 TCP 浪费 10%-20% 的带宽的代价，换取平均延迟降低 30%-40%，且最大延迟降低三倍的传输效果。



## JSON/XML 操作

[回到顶部](#Awesome Swift)

* :heart: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) ⭐️21.2k - GitHub 上最为开发者认可的 JSON 解析类。
* [Alamofire-SwiftyJSON](https://github.com/SwiftyJSON/Alamofire-SwiftyJSON) ⭐️1.4k - Alamofire extension for serialize NSData to SwiftyJSON.
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) ⭐️8.9k - JSON Object mapping written in Swift.
* [HandyJSON](https://github.com/alibaba/HandyJSON) ⭐️3.9k - 阿里开源的 JSON 解析框架。
* [Argo](https://github.com/thoughtbot/Argo) ⭐️3.5k - Swift 下的 JSON 解析框架。
* [json-Swift](https://github.com/owensd/json-swift) ⭐️731 - A basic library for working with JSON in Swift.
* [DynamicJSON](https://github.com/saoudrizwan/DynamicJSON) ⭐️696 - 采用 Swift 4.2 新特性 （@dynamicMemberLookup） 实现轻便访问 JSON 数据。
* [SWXMLHash](https://github.com/drmohundro/SWXMLHash) - Simple XML parsing in Swift.
* [AEXML](https://github.com/tadija/AEXML) - Simple and lightweight XML parser for iOS written in Swift.
* [JASON](https://github.com/delba/JASON) - JSON parsing with outstanding performances and convenient operators.
* [Fuzi](https://github.com/cezheng/Fuzi) - A fast & lightweight XML/HTML parser with XPath & CSS support in Swift 2.
* [Tailor](https://github.com/zenangst/Tailor) - A super fast & convenient object mapper tailored for your needs.
* [SwiftyJSONAccelerator](https://github.com/insanoid/SwiftyJSONAccelerator) - Generate Swift 5 model files from JSON with Codeable support.
* :heart: [swift-protobuf](https://github.com/apple/swift-protobuf) ⭐️3.7k - Protocol Buffers 的 Swift 语言实现库。P.S. Protocol Buffers 是 Google 开源项目，主要功能是实现直接序列化结构化的对象数据，方便跨平台快速传递，开发者也可以直接修改 protobuf 中的数据。相比 XML 和 JSON，protobuf 解析更快，存储更小.
* [Ono](https://github.com/mattt/Ono) ⭐️2.6k - 用合理的方式处理 iOS 和 macOS 的 XML 和 HTML。

### Codable

* [Codextended](https://github.com/JohnSundell/Codextended) ⭐️1.4k - 赋予 Swift 的 Codable API 类型推断能力的扩展
* [BetterCodable](https://github.com/marksands/BetterCodable) ⭐️1.3k - 通过属性包装器更好地 Codable
* [AnyCodable](https://github.com/Flight-School/AnyCodable) ⭐️1k - Encodable、Decodable 和 Codable 值的类型擦除包装器。
* [SafeDecoder](https://github.com/GodL/SafeDecoder) ⭐️4 - SafeDecoder 支持在 Codable 解码某个字段失败时设置默认值，并且默认值可配置。



## 自动布局

[回到顶部](#Awesome Swift)

* :heart: [SnapKit](https://github.com/SnapKit/SnapKit) ⭐️ 18k - Auto Layout 自动布局框架。
* :heart: [EasyAnchor](https://github.com/onmyway133/EasyAnchor) ⭐️445 - 声明式、可扩展、强大的自动布局。
* [PureLayout](https://github.com/PureLayout/PureLayout) - ⭐️7.6k - iOS&OS X 自动布局的终极 API ー令人印象深刻的简单、强大、兼容 Objective-C 和 Swift。
* [Cartography](https://github.com/robb/Cartography) ⭐️7.3k - 声明式自动布局框架。
* [PinLayout](https://github.com/mirego/PinLayout) ⭐️1.8k - Extremely Fast views layouting without auto layout. No magic, pure code, full control and blazing fast. Concise syntax, intuitive, readable & chainable.
* [Swiftstraints](https://github.com/Skyvive/Swiftstraints) - 强大的自动布局框架，让你在一行代码中编写约束。
* [Neon](https://github.com/mamaral/Neon) ⭐️4.6k - Neon 是一套强大的 UI 布局框架，围绕用户界面的自然和直观设计而构建的。没有更多的弹簧和支撑杆，没有古怪的视觉格式化语言，没有自动布局约束。*我们不是机器人，为什么要像我们一样构建我们的 UI？*



## 框架

[回到顶部](#Awesome Swift)

* :heart: [Reusable](https://github.com/AliSoftware/Reusable) ⭐️2.7k - 一个 Swift mixin，可以轻松地以类型安全的方式重用视图。
* [swift-project-template](https://github.com/artemnovichkov/swift-project-template) ⭐️88 - Swift 项目模版
* [AsyncDisplayKit](https://github.com/facebookarchive/AsyncDisplayKit) ⭐️13.5k - 提供界面的高流畅性切换及更灵敏的响应。
* [MMWormhole](https://github.com/mutualmobile/MMWormhole) ⭐️3.8k - iOS 扩展与宿主应用的通讯框架。
* [Whisper](https://github.com/hyperoslo/Whisper) 3.7k - Whisper 是一个组件，可以简化显示消息和应用内通知的任务。
* [FontAwesome.Swift](https://github.com/thii/FontAwesome.swift) ⭐️1.5k - Use FontAwesome in your Swift projects.
* [GoogleMaterialIconFont](https://github.com/kitasuke/GoogleMaterialIconFont) - Google Material Icon Font for Swift and ObjC.
* [epoxy-iOS](https://github.com/airbnb/epoxy-ios) ⭐️776 - Epoxy 是一套用于在 Swift 中构建 UIKit 应用程序的声明式 UI 框架。
* :orange: [Aspects](https://github.com/steipete/Aspects) ⭐️8.2k - 面向切片编程（aspect oriented programming）框架。
* [CarbonGraph](https://github.com/baidu/CarbonGraph) ⭐️151 - 百度网盘开源依赖注入框架 CarbonGraph，框架使用 Swift 编写同时兼容 ObjC，提供完整的依赖注入能力（构造器注入、属性注入、方法注入、工厂注入）。你可以将类之间的依赖关系交给 IOC 容器来构建，使用框架定义的 DSL 能够方便地进行配置。构建更有利于测试和替换的松散耦合关系，可以实现不同业务对中台服务的个性化配置，也可以仅仅用来解决组件化中模块间直接依赖的问题。
* [uber/needle](https://github.com/uber/needle) ⭐️1.3k - 编译时安全的 Swift 依赖注入框架。



## UI

[回到顶部](#Awesome Swift)

* :heart: [SkeletonView](https://github.com/Juanpe/SkeletonView) ⭐️11.1k - 骨架屏，一种优雅的方式来向用户展示正在发生的事情并让他们准备好他们正在等待的内容。
* [Material](https://github.com/CosmicMind/Material) ⭐️11.9k - Material 是用于创建漂亮应用的 UI/UX 框架，其动画系统利用 [Motion](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FCosmicMind%2FMotion) 完全重新设计，提供了多种 Material Design 风格的控件，让你轻松在 iOS 应用上实现 Material Design 风格！
* [Sejima](https://github.com/MoveUpwards/Sejima) ⭐️63 - User Interface Library components for iOS.
* [EZSwipeController](https://github.com/goktugyil/EZSwipeController) ⭐️842 -  UIPageViewController like Snapchat/Tinder/iOS Main Pages
* [Swifty](https://github.com/RyukieSama/Swifty) ⭐️41 - ScreenShield 是极其轻量化的截屏防护方案，任何需要被保护的 View 作为子视图放入保护的视图中即可达到截屏时隐藏内容的效果。
* :heart: [Bartinter](https://github.com/MaximKotliar/Bartinter) ⭐️1.7k - 根据状态栏背后的内容动态更改状态栏样式主题。
* [Pulley](https://github.com/52inc/Pulley) ⭐️2k - 一个模仿 iOS 10/11 地图中抽屉的库。类似于呈现一个半模态视图控制器。
* [FloatingPanel](https://github.com/SCENEE/FloatingPanel) ⭐️4.9k - 简洁易用的浮动面板 UI 组件。



### Alert、Toast

* :heart: [Siren](https://github.com/ArtSabintsev/Siren) ⭐️3.9k - 当应用版本更新时，通知用户并提供 App Store 链接。
* :heart: [SPPermissions](https://github.com/ivanvorobei/SPPermissions) ⭐️4.8k - 通过列表、Dialog 对话框和原生界面的方式向用户请求访问权限。可以检查权限状态。支持 SwiftUI。
* [xmartlabs/XLActionController](https://github.com/xmartlabs/XLActionController) ⭐️3.3k - 有多种可自定义可扩展的底部菜单栏控件，重点是跟 XLForm/Eureka 框架是同一个作者。
* [Toast-Swift](https://github.com/scalessec/Toast-Swift) ⭐️3k
* [WMZDialog](https://github.com/wwmz/WMZDialog) ⭐️881 - 功能最多样式最多的弹窗，支持普通 / 底部 / 日期 / 地区 / 日历 / 选择 / 编辑 / 分享 / 菜单 / 自定义弹窗等，支持多种动画，链式编程调用。
* [alerts-and-pickers](https://github.com/dillidon/alerts-and-pickers) ⭐️5.4k - UIAlertController 和基于它的选择器的高级用法：电报、联系人、位置、照片库、国家、电话代码、货币、日期...
* [Mandoline](https://github.com/blueapron/Mandoline) ⭐️885 - iOS picker 视图可满足您的所有“挑选”需求。
* [SCLAlertView-Swift](https://github.com/vikmeup/SCLAlertView-Swift) ⭐️5.2k - 一款漂亮的弹窗控件。
* [SimpleAlert](https://github.com/KyoheiG3/SimpleAlert) - Customizable simple Alert and simple ActionSheet for Swift
* [EZAlertController](https://github.com/thellimist/EZAlertController) - Easy Swift UIAlertController
* [TTGSnackbar](https://github.com/zekunyan/TTGSnackbar) ⭐️579
* [SweetAlert-iOS](https://github.com/codestergit/SweetAlert-iOS) ⭐️2k - 带动画效果弹窗封装类。
* [FlourishUI](https://github.com/unicorn/FlourishUI)  ⭐️224 - 一个高度可配置的、开箱即用的漂亮UI框架。
* [AZDialogViewController](https://github.com/Minitour/AZDialogViewController) ⭐️771 - 一个高度可定制的警报对话框控制器，模仿 Snapchat 的警报对话框。



### 卡片

* :heart: [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages) ⭐️6.4k - A very flexible message bar for iOS written in Swift.
* [BulletinBoard](https://github.com/alexisakers/BulletinBoard) ⭐️5.2k - 创建显示在屏幕底部的卡片视图。
* [NotificationBanner](https://github.com/Daltron/NotificationBanner) ⭐️4.4k - 在 iOS 中显示高度可定制的应用通知横幅的最简单方法。
* [Cards](https://github.com/PaoloCuscela/Cards) ⭐️4.1k - 很棒的 iOS 11 App Store 卡片样式。



### Popup 弹窗

* [Popover](https://github.com/corin8823/Popover) ⭐️1.9k - 像 Facebook 应用里的气球呼出框，用纯 Swift 语言编写
* [AMPopTip](https://github.com/andreamazz/AMPopTip) ⭐️2.9k - 弹出指定 frame 大小的动画弹出框，非常适合微妙的 UI 提示和引导。
* [PopupView](https://github.com/exyte/PopupView) 【SwiftUI】⭐️1.1k
* [PopMenu](https://github.com/CaliCastle/PopMenu) ⭐️1.3k - 适用于 iOS 的完全可定制的弹出菜单。
* [FFPopup](https://github.com/JonyFang/FFPopup) ⭐️782 - 在 iOS 中将自定义视图呈现为弹出窗口。



### 活动指示器、UIActivityIndicatorView

* [ninjaprox/NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) ⭐️10k
* [SwiftOverlays](https://github.com/peterprokop/SwiftOverlays) ⭐️628 - GUI library for displaying various popups and notifications.
* [SendIndicator](https://github.com/LeonardoCardoso/SendIndicator) - 任务指示器。
* [EZLoadingActivity](https://github.com/goktugyil/EZLoadingActivity) - Lightweight loading activity HUD
* [Hokusai](https://github.com/ytakzk/Hokusai) ⭐️431 - A library for a cool bouncy action sheet
* [SPIndicator](https://github.com/ivanvorobei/SPIndicator) ⭐️227
* :orange: [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD) ⭐️3.2k - 适用于 iOS 和 tvOS 的优雅而简单的进度 HUD，兼容 Swift 和 ObjC。
* [ProgressHUD](https://github.com/relatedcode/ProgressHUD) ⭐️2.2k - ProgressHUD 是一款轻量级且易于使用的 iOS HUD。
* [PKHUD](https://github.com/pkluz/PKHUD) ⭐️3.7k



### 启动引导页

* [Ramotion/paper-onboarding](https://github.com/Ramotion/paper-onboarding) ⭐️3.2k - PaperOnboarding is a material design UI slider.
* [SwiftyOnboard](https://github.com/juanpablofernandez/SwiftyOnboard) ⭐️1.1k
* :heart: [Instructions](https://github.com/ephread/Instructions) ⭐️4.9k - 一款能快速创建引导流程的控件。
* [BWWalkthrough](https://github.com/ariok/BWWalkthrough) ⭐️2.8k - 界面切换中加入灵动的动画效果。
* [VideoSplashKit](https://github.com/sahin/VideoSplashKit) ⭐️1.2k - 用于创建简单的背景视频介绍页面的 UIViewController 库
* [RazzleDazzle](https://github.com/IFTTT/RazzleDazzle) ⭐️3.3k
* [Onboard](https://github.com/mamaral/Onboard) ⭐️6.5k
* :warning: [Presentation](https://github.com/hyperoslo/Presentation) ⭐️3k - 新手引导页，欢迎页及其动效
* [KSGuideController](https://github.com/skx926/KSGuideController) ⭐️323 - 一个漂亮的新手引导库。



### 分页菜单/下拉菜单/UISegmentedControl

* :heart: [JXSegmentedView](https://github.com/pujiaxin33/JXSegmentedView) ⭐️1.9k - 分类切换滚动视图
* [twicketapp/TwicketSegmentedControl](https://github.com/twicketapp/TwicketSegmentedControl) ⭐️1.7k
* [JNDropDownMenu](https://github.com/javalnanda/JNDropDownMenu) ⭐️65 - 下拉菜单
* [DropDown](https://github.com/AssistoLab/DropDown) ⭐️2.2k - 拟物设计（Material Design）风格的下拉菜单
* [TwicketSegmentedControl](https://github.com/polqf/TwicketSegmentedControl) ⭐️1.7k - 用于替代 iOS 默认组件的自定义 UISegmentedControl
* [Persei](https://github.com/Yalantis/Persei) ⭐️3.4k - 基于 Swift 语言，顶部菜单的动效，针对于 UITableView 、 UICollectionView 、 UIScrollView
* [circle-menu](https://github.com/Ramotion/circle-menu) ⭐️3.3k - 简单优雅的环形布局菜单
* [AxisSegmentedView](https://github.com/jasudev/AxisSegmentedView) ⭐️40 - A library that allows you to easily create various styles of segmented views. Supports iOS, macOS and tvOS.
* [XLPagerTabStrip](https://github.com/xmartlabs/XLPagerTabStrip) ⭐️6.7k - XLPagerTabStrip 是一个容器视图控制器，它允许我们在一组视图控制器之间轻松切换。平移手势可用于移动到下一个或上一个视图控制器。它显示了当前、前一个、下一个子视图控制器的交互式指示器。
* [xmartlabs/PagerTabStripView](https://github.com/xmartlabs/PagerTabStripView) ⭐️344 - SwiftUI 框架。
* :warning: [PagingMenuController](https://github.com/kitasuke/PagingMenuController) ⭐️2.5k - 提供多种样式的分页切换控件



### 表单

* :heart: [Eureka](https://github.com/xmartlabs/Eureka) ⭐️11.3k - iOS 表单框架，是 XLForm 的 Swift 版本。
* :warning: [SwiftForms](https://github.com/ortuman/SwiftForms) ⭐️1.3k - 表单递交库，快速开发利器



### 日历/图表

* [Charts](https://github.com/danielgindi/Charts) ⭐️24.8k - iOS 应用的漂亮图表
* [FSCalendar](https://github.com/WenchaoD/FSCalendar) ⭐️10k - 一个完全可定制的 iOS 日历库，与 Objective-C 和 Swift 兼容。
* [JTAppleCalendar](https://github.com/patchthecode/JTAppleCalendar) ⭐️7.2k - 非官方 Apple iOS Swift 日历视图。 Swift 日历库。 iOS 日历控件。
* [CalendarKit](https://github.com/richardtop/CalendarKit) ⭐️2k - Calendar for Apple platforms in Swift.
* [PNChart-Swift](https://github.com/kevinzhow/PNChart-Swift) ⭐️1.4k - 带动画效果的图表控件库。
* [CrispyCalendar](https://github.com/CleverPumpkin/CrispyCalendar) ⭐️312 - 日历 UI 框架。
* [ScrollableGraphView](https://github.com/philackm/ScrollableGraphView) ⭐️5.2k - 针对于 iOS 应用的自适应滚动图形，用于将离散的数据集进行可视化
* [SwiftUIChart](https://github.com/willdale/SwiftUIChart) ⭐️384 - 一个用于 SwiftUI 的图表/绘图库。支持在 macOS、iOS、watchOS 和 tableViewOS 上运行，并内置了无障碍功能。
* [BSChart](https://github.com/iBlacksus/BSChart) ⭐️189 - BSChart is a simple and useful chart library written on Swift。
* [RoughSwift](https://github.com/onmyway133/RoughSwift) ⭐️1k - 在 Swift 中创建手绘、粗略、漫画的形状。



### Tag

* [TagListView](https://github.com/xhacker/TagListView) ⭐️2.3k - Simple but highly customizable iOS tag list view.
* [TagCellLayout](https://github.com/riteshhgupta/TagCellLayout) ⭐️297 - UICollectionView layout for Tags with Left, Center & Right alignments.
* :orange: [TTGTagCollectionView](https://github.com/zekunyan/TTGTagCollectionView) ⭐️1.6k



### UINavigationContoller

* [SlideMenuControllerSwift](https://github.com/dekatotoro/SlideMenuControllerSwift) ⭐️3.3k - 基于 Google + ，iQON，Feedly，Ameba iOS 应用的 iOS 侧划抽屉菜单视图。
* [SAHistoryNavigationViewController](https://github.com/szk-atmosphere/SAHistoryNavigationViewController) ⭐️1.6k - 在 UINavigationContoller 中实现了类似iOS任务管理器的用户界面，支持3DTouch。
* [Interactive Side Menu](https://github.com/handsomecode/InteractiveSideMenu) - Customizable iOS Interactive Side Menu written in Swift 3.0.
* [Presentr](https://github.com/IcaliaLabs/Presentr) ⭐️2.8k - 对传统 ViewController present 的封装



### UINavigationBar 

* [AMScrollingNavbar](https://github.com/andreamazz/AMScrollingNavbar) ⭐️6k - 可滚动的 UINavigationBar，跟随 UIScrollView 的滚动。



### UIDevice
* [DeviceKit](https://github.com/devicekit/DeviceKit) ⭐️3.5k



### UILabel

* :orange: [UICountingLabel](https://github.com/dataxpress/UICountingLabel) ⭐️1.9k - 为 UILabel 添加动画计数支持。



### UIButton
* [LGButton](https://github.com/loregr/LGButton) ⭐️2.3k - 一个完全可定制的原生 `UIControl` 子类，它允许您创建漂亮的按钮，而无需编写任何代码。
* [NFDownloadButton](https://github.com/LeonardoCardoso/NFDownloadButton) ⭐️435 - 改进的下载按钮。这有点像 Netflix 应用中的下载按钮的逆向工程。
* [SwiftyButton](https://github.com/TakeScoop/SwiftyButton) ⭐️540 - Simple and customizable button in Swift
* [fave-button](https://github.com/janselv/fave-button) ⭐️1.4k - 用 Swift 编写的动画按钮，常用于收藏、点赞等场景。



### UISwitch

* [paper-switch](https://github.com/Ramotion/paper-switch) ⭐️2.9k - 这是一个 Swift 的模块组件，当页面中的开关打开后该页面填充底色
* [BetterSegmentedControl](https://github.com/gmarm/BetterSegmentedControl) ⭐️1.9k - 易于使用、可定制，替代 `UISegmentedControl` 和 `UISwitch`。
* [DDAnimatedSwitch](https://github.com/d-dotsenko/DDAnimatedSwitch) ⭐️124 - 一个可定制的开关动画。它支持你使用任何帧动画来当 icon，你不仅可以为开关设置动画，还可以为拇指设置动画，可播放、调整比例大小、循环播放，在播放速度方面支持你加快，放慢和倒转动画。



### UISlider

* [HGCircularSlider](https://github.com/HamzaGhazouani/HGCircularSlider) ⭐️2.3k - 自定义可重用循环/进度滑块控件。
* [AGCircularPicker](https://github.com/agilie/AGCircularPicker) ⭐️613 - 漂亮的动画组件，用于创建一个旨在管理任何计算参数的控制器。
* [Ramotion/fluid-slider](https://github.com/Ramotion/fluid-slider) ⭐️1.9k - 带有弹出气泡的滑块小部件，显示所选的精确值。
* [SectionedSlider](https://github.com/LeonardoCardoso/SectionedSlider) ⭐️349 - iOS 11 控制中心音量滑块。



### UITextField、UITextView

* [HTYTextField](https://github.com/hanton/HTYTextField) ⭐️315 - 带有弹性占位符的 `UITextField`.
* [NextGrowingTextView](https://github.com/muukii/NextGrowingTextView) ⭐️1.8k - 针对 iOS 8 及更高版本优化的 "growing textviews".
* [InputBarAccessoryView](https://github.com/nathantannar4/InputBarAccessoryView) ⭐️902 - 一个简单和容易定制的输入框辅助视图（InputAccessoryView），用于实现具有自动完成和附件功能的强大的输入框。
* [FloatLabelFields](https://github.com/FahimF/FloatLabelFields) ⭐️1.2k - 浮动标签输入效果类。
* [KMPlaceholderTextView](https://github.com/MoZhouqi/KMPlaceholderTextView) ⭐️777
* :orange: [UITextView-Placeholder](https://github.com/devxoul/UITextView-Placeholder) ⭐️1.4k - 为 `UITextView` 添加占位符功能
* :orange: [SZTextView](https://github.com/glaszig/SZTextView) ⭐️675 - A drop-in `UITextView` replacement which gives you: a placeholder.



### UITabBar

* :heart: [animated-tab-bar](https://github.com/Ramotion/animated-tab-bar) ⭐️11k 灵动的动画标签栏类库。
* [adaptive-tab-bar](https://github.com/Ramotion/adaptive-tab-bar) ⭐️2k
* [AxisTabView](https://github.com/jasudev/AxisTabView) ⭐️80 - A library that allows you to easily create various styles of tab views. Supports iOS and macOS.
* [LTabView](https://github.com/Mr-XiaoLiang/LTabView) ⭐️18 - *一个带有动画的 TabView* 项目。






### UITableView

* [WobbleView](https://github.com/inFullMobile/WobbleView) ⭐️2.2k - Implementation of wobble effect for any view in app.
* [Preheat](https://github.com/kean/Preheat) ⭐️633 - 自动预取 UITableView 和 UICollectionView 中的内容。
* [TableViewTools](https://github.com/rosberry/TableViewTools) ⭐️11
* [HWPanModal](https://github.com/HeathWang/HWPanModal) ⭐️921 - 任意形式的底部弹框动画；头条、知乎、抖音弹出评论效果；地图浮层，iOS13 present 默认模态效果。
* :orange: [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) ⭐️12.1k - 空白页面占位图
* [HGPlaceholders](https://github.com/HamzaGhazouani/HGPlaceholders) ⭐️2.1k - 空白页面占位图



### UICollection

* :orange: [Instagram/IGListKit](https://github.com/Instagram/IGListKit) ⭐️12.2k - Instagram 开源的一个数据驱动的 `UICollectionView` 框架，用于构建快速灵活的集合列表。 
* [Carbon](https://github.com/ra1028/Carbon) ⭐️1.2k - 一个声明式框架，在 `UITableView` 和 `UICollectionView` 中构建基于组件的界面。提供 API 文档及丰富示例。
* [Owl](https://github.com/malcommac/Owl) ⭐️437 - 一个声明式、类型安全的框架，用于搭建快速而灵活的 `UITableView` 和 `UICollectionView`。
* [CollectionKit](https://github.com/SoySauceLab/CollectionKit) ⭐️4.2k - 重构 `UICollectionView`
* :heart: [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout) ⭐️4.3k - 瀑布流布局
* :heart: [airbnb/MagazineLayout](https://github.com/airbnb/MagazineLayout) ⭐️3.1k - Airbnb 开源的集合视图布局框架，能够以垂直滚动的网格和列表的方式布置视图。
* [AnimatedCollectionViewLayout](https://github.com/KelvinJin/AnimatedCollectionViewLayout) ⭐️4.3k - 一个 UICollectionViewLayout 子类，在不影响你现有代码的前提下，为UICollectionView 添加自定义过渡动画。
* [BouncyLayout](https://github.com/roberthein/BouncyLayout) ⭐️4k - 为集合视图 cell 添加 bounce 效果。
* [VegaScroll](https://github.com/ApplikeySolutions/VegaScroll) ⭐️2.7k - 轻量级的 UICollectionView 动画流布局，完全用 Swift 4 编写，兼容 iOS 11 和 Xcode 9。
* [Ramotion/folding-cell](https://github.com/Ramotion/folding-cell) ⭐️10.1k - 卡片折叠动画
* [expanding-collection](https://github.com/Ramotion/expanding-collection) ⭐️5.5k - 一个 material design 风格的动画卡片 peek/pop 控制器
* [GravitySlider](https://github.com/ApplikeySolutions/GravitySlider) ⭐️901 - GravitySlider 是标准 UICollectionView 流布局的漂亮替代品。
* [Gemini](https://github.com/shoheiyokoyama/Gemini) ⭐️3k - 基于 scroll 的滚动动画框架，用 Swift 编写。
* [MSPeekCollectionViewDelegateImplementation](https://github.com/MaherKSantina/MSPeekCollectionViewDelegateImplementation) ⭐️341 - 在集合视图中查看上一项和下一项的自定义分页实现。
* [collectionview](https://github.com/corekit/collectionview) ⭐️28 - CollectionViews with ease.
* [CollectionViewTools](https://github.com/rosberry/CollectionViewTools)
* [CollectionViewSlantedLayout](https://github.com/yacir/CollectionViewSlantedLayout) ⭐️2.1k - 在 UICollectionView 中显示倾斜的单元格。



### UIStackView


### UIScrollView

* :heart: [FSPagerView](https://github.com/WenchaoD/FSPagerView) ⭐️6.3k - FSPagerView 是一个优雅的屏幕滚动框架。它对于制作 Banner View、Product Show、Welcome/Guide Pages、Screen/ViewController Sliders 非常有帮助。
* [ScrollStackController](https://github.com/malcommac/ScrollStackController) ⭐️378 - Easy scrollable layouts in UIKit




### UIProgress

* [KYCircularProgress](https://github.com/kentya6/KYCircularProgress) ⭐️1.1k - 简单、实用路径可定制进度条。
* [loady](https://github.com/farshadjahanmanesh/loady) ⭐️817 - Loady 是一个小动效库用来定制加载按钮动画，可用于显示 UI 中 Button 的加载，支持你自定义样式，它本身提供有 6 种不同的加载样式，4 种动画状态（成功加载、加载失败、加载中，正常加载）。
* [BKStepperProgress](https://github.com/bharathi91/BKStepperProgress) ⭐️16 - 一个 iOS 控件，用于以步进器形式指示进度视图。
* [MultiProgressView](https://github.com/mac-gallagher/MultiProgressView) ⭐️852 - 多区间进程条展示效果组件及示例。



### UIRefresh/ Pull to Refresh

* [DGElasticPullToRefresh](https://github.com/gontovnik/DGElasticPullToRefresh) ⭐️3.6k - 弹性的下拉刷新控件。
* [PullToMakeSoup](https://github.com/Yalantis/PullToMakeSoup) ⭐️1.9k - 下拉刷新顺便煮个汤吧。
* 



## Extensions

[回到顶部](#Awesome Swift)

* :heart: [SwifterSwift/SwifterSwift](https://github.com/SwifterSwift/SwifterSwift) ⭐️ 10.4k — 包含 500 多个原生 Swift 扩展的便捷集合，以提高你的工作效率。
* [HandySwift](https://github.com/Flinesoft/HandySwift) ⭐️422 - 没有进入 Swift 标准库的方便的 Swift 功能。
* [HandyUIKit](https://github.com/FlineDev/HandyUIKit) ⭐️119 - 一开始就应该成为 UIKit 一部分的方便的 UI 功能。
* :warning: [ExSwift](https://github.com/pNre/ExSwift) ⭐️3.4k - JavaScript (Lo-Dash, Underscore) & Ruby inspired set of Swift extensions for standard types and classes.
* [SwiftBoost](https://github.com/sparrowcode/SwiftBoost) ⭐️83 - Swift 扩展的集合以加速开发。
* [Pythonic.swift](https://github.com/practicalswift/Pythonic.swift) - Pythonic tool-belt for Swift – a Swift implementation of selected parts of Python standard library.
* [SWRoute](https://github.com/rodionovd/SWRoute) - A tiny Swift wrapper. Allows you to route (hook) quite any function/method with another function/method or even a closure.
* [LlamaKit](https://github.com/LlamaKit/LlamaKit) - Collection of must-have functional Swift tools.
* [Basis](https://github.com/typelift/Basis) - A number of foundational functions, types, and typeclasses.
* [CAAnimation + Closure](https://github.com/honghaoz/Swift-CAAnimation-Closure) - Add start / completion closures for CAAnimation instances
* [SwiftSequence](https://github.com/oisdk/SwiftSequence) - A μframework of extensions for SequenceType in Swift 2.0, inspired by Python's itertools, Haskell's standard library, and other things.
* [BrightFutures](https://github.com/Thomvis/BrightFutures) - Write great asynchronous code in Swift using futures and promises.
* [EZSwiftExtensions](https://github.com/goktugyil/EZSwiftExtensions) - :smirk: How Swift standard types and classes were supposed to work.
* [BFKit-Swift](https://github.com/FabrizioBrancati/BFKit-Swift) - A collection of useful classes to develop Apps faster.
* [ZamzamKit](https://github.com/ZamzamInc/ZamzamKit) - A collection of micro utilities and extensions for Standard Library, Foundation and UIKit.
* [Bow](https://github.com/bow-swift/bow) - Companion library for Typed Functional Programming in Swift.
* [SwiftCoroutine](https://github.com/belozierov/SwiftCoroutine) - Swift coroutines for iOS and macOS.
* [Omnia](https://github.com/onmyway133/Omnia) ⭐️55 - Everything your projects need to know.



## 语法糖/包装器

[回到顶部](#Awesome Swift)

* :heart: [R.Swift](https://github.com/mac-cain13/R.swift) ⭐️8.7k - Swift 项目中的强类型、自动代码补全资源，如图像、字体和 segue。
* :heart: [SwiftGen](https://github.com/SwiftGen/SwiftGen) ⭐️8k - SwiftGen 是一个为项目中的所有资源自动生成 Swift 代码的工具，允许您以类型安全的方式访问它们。
* [Closures](https://github.com/vhesener/Closures) ⭐️1.7k - 为 UIKit 和 Foundation 框架中的类添加闭包语法。
* [Result](https://github.com/antitypical/Result) ⭐️2.5k - 对任意操作的成功/失败进行建模的 Swift 类型。
* [Require](https://github.com/JohnSundell/Require) ⭐️411 - 为 Optional 类型提供辅助方法，要求可选类型的值非零，或优雅地崩溃。
* [Then](https://github.com/devxoul/Then) ⭐️3.7k - 为 Swift 初始化方法提供甜蜜的语法糖。
* [SwiftState](https://github.com/inamiy/SwiftState) ⭐️873 - 优雅的 Swift 状态机。
* [Sugar](https://github.com/hyperoslo/Sugar) ⭐️1.1k - Something sweet that goes great with your Cocoa.
* [Cupcake](https://github.com/nerdycat/Cupcake) ⭐️288 - An easy way to create and layout UI components for iOS.



## 正则表达式

[回到顶部](#Awesome Swift)

* [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit) ⭐️4.3k - 一个用于解析、格式化和验证国际电话号码的 Swift 框架。
* [Regex](https://github.com/kean/Regex) ⭐️171 - Open source regex engine
* [Sweep](https://github.com/JohnSundell/Sweep) ⭐️508 - 比正则表达式简单很多的子字符串扫描和匹配。
* [RegularExpressionDecoder](https://github.com/Flight-School/RegularExpressionDecoder) ⭐️173 - 针对结构化数据的正则表达式解析库。
* [libPhoneNumber-iOS](https://github.com/iziz/libPhoneNumber-iOS) ⭐️2.3k - 来自 libphonenumber 的 iOS 端口（Google 的电话号码处理库）



## 键盘

[回到顶部](#Awesome Swift)

* [KeyboardLayoutGuide](https://github.com/freshOS/KeyboardLayoutGuide) ⭐️1.1k - KeyboardLayoutGuide, back from when it didn't exist.
* [Ribbon](https://github.com/chriszielinski/Ribbon) ⭐️283 - 🎀 适用于 iOS 和 macOS 的简单跨平台工具栏/自定义 input accessory view。



## 字符串

[回到顶部](#Awesome Swift)

* [BonMot](https://github.com/Rightpoint/BonMot) ⭐️3.2k - Beautiful, easy attributed strings in Swift
* [SwiftRichString](https://github.com/malcommac/SwiftRichString) ⭐️2.8k - Elegant Attributed String composition in Swift。
* [SwiftScanner](https://github.com/malcommac/SwiftScanner) ⭐️172 - String Scanner in pure Swift (supports unicode)
* [Highlightr](https://github.com/raspu/Highlightr) ⭐️1.3k - Highlightr 是一个使用 Swift 构建的 iOS 和 macOS 语法荧光笔。它以 [highlight.js](https://highlightjs.org/) 为核心，支持185种语言，自带89种样式
* [Pluralize.Swift](https://github.com/joshualat/Pluralize.swift) ⭐️188 - 伟大的 Swift 字符串扩展
* [texstyle](https://github.com/rosberry/texstyle) ⭐️78
* [FlagKit](https://github.com/madebybowtie/FlagKit) ⭐️2.9k - 漂亮的旗帜图标，可在应用程序和 web 上使用。
* [StringFormatter](https://github.com/orucanil/StringFormatter) ⭐️242 - 简单的文本格式化器（信用卡号码、电话号码、序列号等） 可以根据匹配模式用于所有文本输入。




## 颜色&深色模式&主题

[回到顶部](#Awesome Swift)

* [SwiftTheme](https://github.com/wxxsw/SwiftTheme) ⭐️2.3k - Powerful theme/skin manager for iOS 8+ 主题/换肤，暗色模式
* [FluentDarkModeKit](https://github.com/microsoft/FluentDarkModeKit) ⭐️1.6k - 微软开源的 Dark Mode 框架
* [DKNightVersion](https://github.com/draveness/DKNightVersion) ⭐️3.6k
* [Hue](https://github.com/zenangst/Hue) ⭐️3.3k - 万能的颜色工具，以后再也不用写 Swift 代码啦
* [DynamicColor](https://github.com/yannickl/DynamicColor) ⭐️2.7k - 更简单的控制颜色的 Swift 拓展插件
* [SwiftColors](https://github.com/thii/SwiftColors) - HEX color handling as an extension for UIColor.
* [ComplimentaryGradientView](https://github.com/gkye/ComplimentaryGradientView) ⭐️707 - 通过源图片的主要颜色生成颜色渐变
* [ColorSet](https://github.com/DigiDNA/ColorSet) ⭐️144 - ColorSet 是一个 macOS 实用程序和框架，允许开发人员轻松管理自定义界面颜色。
* :warning: [ColorSlider](https://github.com/gizmosachin/ColorSlider) ⭐️269 - Swift 中 Snapchat 风格的颜色选择器。
* [ColorCompatibility](https://github.com/noahsark769/ColorCompatibility) ⭐️99 - 使用 iOS 13+ 系统颜色，而在 iOS <=12 上默认为浅色。



## 时间

[回到顶部](#Awesome Swift)

* [SwiftDate](https://github.com/malcommac/SwiftDate) ⭐️6.8k - 用于在 Swift 中解析、验证、操作、比较和显示日期、时间和时区的工具包。
* [DateTools](https://github.com/MatthewYork/DateTools) ⭐️7.2k - Dates and times made easy in iOS。
* [Time](https://github.com/davedelong/time) ⭐️2k - Building a better date/time library for Swift
* [Timepiece](https://github.com/naoty/Timepiece) ⭐️2.7k - 直观的日期处理。
* [DateHelper](https://github.com/melvitax/DateHelper) ⭐️1.3k - A Swift Date extension helper.
* [DateTimePicker](https://github.com/itsmeichigo/DateTimePicker) ⭐️1.8k - 一款精致的日期选择控件。
* [DatePickerDialog-iOS-Swift](https://github.com/squimer/DatePickerDialog-iOS-Swift) ⭐️506 -  Date picker dialog for iOS.



## 动画

[回到顶部](#Awesome Swift)

* [Spring](https://github.com/MengTo/Spring) ⭐️14k - Spring 是一套支持 Storyboard 上直接操作使用的动画框架，方便易用，各种动画效果的实现甚至都不用写一行代码！
* [Stellar](https://github.com/AugustRush/Stellar) ⭐️2.9k - 一个出色的物理动画库，基于 `UIDynamic` 并对其进行扩展，友好的 API 让你可以轻松使用它或自定义你自己的动画。
* [YapAnimator](https://github.com/yapstudios/YapAnimator) ⭐️1.9k - 快速友好的基于物理的动画系统。
* [EasyAnimation](https://github.com/icanzilb/EasyAnimation) ⭐️2.9k
* [Ramotion/swift-ui-animation-components-and-libraries](https://github.com/Ramotion/swift-ui-animation-components-and-libraries) ⭐️3.5k - Swift UI libraries, iOS components and animations.
* [Motion](https://github.com/CosmicMind/Motion) ⭐️1.7k - 这是一个用于为视图、图层和视图控制器创建精美动画和过渡的库。
* [RazzleDazzle](https://github.com/IFTTT/RazzleDazzle) ⭐️3.4k - RazzleDazzle 是一个简单的自动布局友好的 iOS 关键帧动画框架，使用于滚动式的应用介绍。
* [fluid-interfaces](https://github.com/nathangitter/fluid-interfaces) ⭐️2.5k - 受 “Designing Fluid Interfaces” 启发而设计的自然手势和动画。
* [Sica](https://github.com/cats-oss/Sica) ⭐️1k - 简单的 Interface Core Animation，以按顺序或并行的方式运行类型安全的动画。
* [lottie-ios](https://github.com/airbnb/lottie-ios) ⭐️22.2k - Airbnb 开源的一个动画渲染库，用于渲染播放 After Effects 矢量动画。
* :warning: [pop](https://github.com/facebookarchive/pop) ⭐️19.8k - Pop是一个可扩展的动画引擎，适用于iOS、tvOS和OS X。除了基本的静态动画，它还支持弹簧和衰减的动态动画，使其对建立现实的、基于物理的互动非常有用。
* [JHChainableAnimations](https://github.com/jhurray/JHChainableAnimations) ⭐️3.2k - Easy to read and write chainable animations in Objective-C and Swift. 通过链式语法实现动画。
* [Macaw](https://github.com/exyte/Macaw) ⭐️5.8k - 功能强大且易于使用的矢量图形动画库，支持 SVG，复杂的动画实现只需简单几行代码！
* :heart: :warning: [uber/UberSignature](https://github.com/uber/UberSignature) ⭐️1.3k - 允许用户用他们的手指以逼真的风格绘制他们的签名。
* [WaveLabelDemo](https://github.com/anonymity-du/WaveLabelDemo) ⭐️59 - 波浪经过文字，文字改变颜色。
* [Slideshow](https://github.com/folio-sec/Slideshow) ⭐️173 - 由 SceneKit 提供支持的 3D 动态图片墙，虽然效果很酷炫但是性能不是很好，如果你要是使用该动效建议优化下。
* :heart: [LoginCritter](https://github.com/cgoldsby/LoginCritter) ⭐️5.6k - LoginCritter 是一个响应文本交互的动画，它会跟踪用户的操作轨迹同你交互。LoginCritter 使用多个 UIPropertyAnimator，头部旋转是通过更新 fractionComplete 属性来控制的。当用户输入时，程序会计算文本的长度和宽度。
* [Arrows](https://github.com/antoniocasero/Arrows) ⭐️339 - Arrows 是一个下拉动画中的指示箭头小组件，它代表了三种不同的箭头状态：up /down/middle。
* [animate.css](https://github.com/animate-css/animate.css) ⭐️74.6k - 一个跨浏览器的 CSS 动画库。像一件容易的事一样容易使用。
* [HGRippleRadarView](https://github.com/HamzaGhazouani/HGRippleRadarView) ⭐️340 - 雷达动画显示附近的物品（用户、餐厅等）使用 rIPple 动画，完全可自定义。



## 转场动画

[回到顶部](#Awesome Swift)

* :heart:  [Hero](https://github.com/HeroTransitions/Hero) ⭐️20.8k - 优雅的转场框架。
* :heart: [BubbleTransition](https://github.com/andreamazz/BubbleTransition) ⭐️3.3k - 自定义的气泡转场效果。
* [Presentr](https://github.com/IcaliaLabs/Presentr) ⭐️2.9k - 用于 iOS 上自定义 ViewController 转场的 Swift 包装器。
* [Preview-Transition](https://github.com/Ramotion/Preview-Transition) ⭐️2.1k - a simple preview gallery UI controller with animated tranisitions.
* [PinterestSwift](https://github.com/demonnico/PinterestSwift) ⭐️1.9k - 类似 Pinterest 样式的转场动画。
* [StarWars.iOS](https://github.com/Yalantis/StarWars.iOS) ⭐️3.7k - 炫酷的过渡动画，把视图控制器粉碎成小块（🤔就像灭霸打了个响指）。
* :orange: [VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary) ⭐️4.6k - iOS7 动画控制器和交互控制器的集合，提供翻转、折叠等各种过渡效果。
* :orange: [RZTransitions](https://github.com/Rightpoint/RZTransitions) ⭐️1.9k - 自定义的 iOS 视图控制器动画和交互。



参考：

* [10 个让你相见恨晚的 iOS Swift 动画框架！](https://juejin.cn/post/6844903789833486350)
* [30 个让你眼前一亮的 iOS Swift UI 控件！](https://juejin.cn/post/6844903781855936519)



## 文件

[回到顶部](#Awesome Swift)

* [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults) ⭐️4.6k - 轻量级数据存储类 `NSUserDefaults` 的扩展，它使类型数据访问和存储更为便捷、直观。
* [FileKit](https://github.com/nvzqz/FileKit/) ⭐️2.2k - Swift 中简单易懂的文件管理。
* [FileProvider](https://github.com/amosavian/FileProvider) ⭐️802 - 提供了一套完整、实用，接口统一的本地及远程文件管理封装器实现 Local, iCloud and Remote (WebDAV/FTP/Dropbox/OneDrive）
* [PathKit](https://github.com/kylef/PathKit) ⭐️1.3k - 小而美的路径管理类。
* [PDFXKit](https://github.com/PSPDFKit/PDFXKit) ⭐️204 - 苹果 PDFKit 替代框架。
* [Path.swift](https://github.com/mxcl/Path.swift) ⭐️890 - 功能完整的文件系统针对目录级路径的 CRUD（增删改查）。
* [ZipArchive](https://github.com/ZipArchive/ZipArchive) ⭐️5k - ZipArchive 是一个简单的实用程序类，用于在 iOS、macOS 和 tvOS 上压缩和解压缩文件。
* [SecurePropertyStorage](https://github.com/alexruperez/SecurePropertyStorage) ⭐️429 - 使用 Swift 属性包装器为你的属性定义安全存储。



## 缓存

[回到顶部](#Awesome Swift)

* [HanekeSwift](https://github.com/Haneke/HanekeSwift) ⭐️5.1k - A lightweight generic cache for iOS written in Swift with extra love for images.
* [Carlos](https://github.com/WeltN24/Carlos) ⭐️614 - A simple but flexible cache for iOS and WatchOS 2 apps, written in Swift.
* [Cache](https://github.com/hyperoslo/Cache) ⭐️2.5k - 多类型数据混合缓存库。
* [Disk](https://github.com/saoudrizwan/Disk) ⭐️2.9k - 令人愉快的 iOS 框架，可轻松持久化存储 struct、image 和 data。



## Keychain 钥匙串

[回到顶部](#Awesome Swift)

* :heart: [cocoapods-keys](https://github.com/orta/cocoapods-keys) ⭐️1.5k - 一款 CocoaPods 插件，将你要加密的信息储存在钥匙串中，而不是硬编码在项目代码里。
* [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) ⭐️6.8k - 适用于 iOS 和 OS X 的 Keychain 的简单 Swift 包装器。使在 Swift 中使用 Keychain API 易于接受和使用。
* [Valet](https://github.com/square/Valet) ⭐️3.7k - 安全地将数据存储在 iOS、tvOS 或 macOS 钥匙串中，而无需了解钥匙串的工作原理。




## 数据库

*使用 Swift 语言实现的数据库* [回到顶部](#Awesome Swift)

* [Realm](https://github.com/realm/realm-swift) ⭐️14.8k - 志向代替 Core Data 和 SQLite 的移动端数据库。
* [IceCream](https://github.com/caiyue1993/IceCream) ⭐️1.7k - 用 CloudKit 同步 Realm 数据库工具库。
* [SQLite.swift](https://github.com/stephencelis/SQLite.swift) - 简单、轻量，使用上最 SQL 的 SQLite 封装库。
* [SwiftData](https://github.com/ryanfowler/SwiftData) - A simple and effective wrapper around the SQLite3 C API written completely in Swift.
* [Squeal](https://github.com/nerdyc/Squeal) - A Swift wrapper for SQLite databases.
* [SQLiteDB](https://github.com/FahimF/SQLiteDB) - Basic SQLite wrapper for Swift.
* [SwiftMongoDB](https://github.com/Danappelxx/SwiftMongoDB) - A Swift driver for MongoDB.
* [ModelAssistant](https://github.com/ssamadgh/ModelAssistant) - Elegant library to manage the interactions between view and model in Swift.
* [PostgresClientKit](https://github.com/codewinsdotcom/PostgresClientKit) - A PostgreSQL client library for Swift. Does not require libpq.
* [AlecrimCoreData](https://github.com/Alecrim/AlecrimCoreData) - A simple Core Data wrapper library written in Swift.



## Events

*用于一对多（one-to-many）通信的框架* [回到顶部](#Awesome Swift)

* [Caravel](https://github.com/coshx/caravel) - A Swift event bus for UIWebView and JS
* [EmitterKit](https://github.com/aleclarson/emitter-kit) - An elegant event framework built in Swift
* [Swift-Custom-Events](https://github.com/StephenHaney/Swift-Custom-Events) - A very simple way to implement Backbone.js style custom event listeners and triggering in Swift for iOS development.
* [Kugel](https://github.com/TakeScoop/Kugel) - A glorious Swift wrapper around NSNotificationCenter

## Queue

*用于处理事件队列和任务队列的框架。* [回到顶部](#Awesome Swift)

* [TaskQueue](https://github.com/icanzilb/TaskQueue) ⭐️673 - A Task Queue Class developed in Swift。
* [Dispatcher](https://github.com/aleclarson/dispatcher) ⭐️110 - Queues, timers, and task groups in Swift
* [GCDKit](https://github.com/JohnEstropia/GCDKit) ⭐️317 - Grand Central Dispatch simplified with Swift.
* [BrightFutures](https://github.com/Thomvis/BrightFutures) ⭐️1.9k - 漫长或复杂计算由独立线程异步来完成
* [Repeat](https://github.com/malcommac/Repeat) ⭐️1.4k - 用 GCD 制作的Swift、Debouncer 和 Throttler（`NSTimer` 的替代品）中的现代定时器。


### 异步编程

* [PromiseKit](https://github.com/mxcl/PromiseKit) ⭐️13.7k - Promise 的 Swift 实现类库，简化异步编程代码实现。[RxSwift vs PromiseKit](https://blog.indigo.codes/2016/08/22/rxswift-vs-promisekit/)
* [Async](https://github.com/duemunk/Async) ⭐️4.6k - Syntactic sugar in Swift for asynchronous dispatches in Grand Central Dispatch.
* [SwiftTask](https://github.com/ReactKit/SwiftTask) ⭐️1.9k - Promise + progress + pause + cancel + retry for Swift.
* [Promissum](https://github.com/tomlokhorst/Promissum) ⭐️67 - Promise library with functional combinators like `map`, `flatMap`, `whenAll` & `whenAny`.
* [PureFutures](https://github.com/wiruzx/PureFutures) ⭐️17 - Futures and Promises library
* [CollectionConcurrencyKit](https://github.com/JohnSundell/CollectionConcurrencyKit) ⭐️561 - Swift 的 forEach、map、flatMap 和 compactMap API 的异步和并发版本。


推荐阅读：
* [【译】SE-0296 Async/await](https://kemchenj.github.io/2021-03-06/)
* [Swift 5.5 带来了 async/await 和 actor 支持](https://juejin.cn/post/6975036374105718820)
* [Swift 并发初步](https://onevcat.com/2021/07/swift-concurrency/#%E5%B0%8F%E7%BB%93)
* [Swift 结构化并发](https://onevcat.com/2021/09/structured-concurrency/#%E5%B0%8F%E7%BB%93)



## 数据结构&算法

*用于生成安全随机数、加密数据和扫描漏洞的框架* [回到顶部](#Awesome Swift)

* :heart: [raywenderlich/swift-algorithm-club](https://github.com/raywenderlich/swift-algorithm-club) ⭐️25.8k - Swift 算法俱乐部，最全、最活跃，最具学习价值的算法库。
* [apple/swift-algorithms](https://github.com/apple/swift-algorithms) ⭐️3.7k - Apple 官方维护的一套 Swift 中常用的序列和集合算法。
* [apple/swift-async-algorithms](https://github.com/apple/swift-async-algorithms) ⭐️576 - Swift 的异步算法。
* [apple/swift-collections](https://github.com/apple/swift-collections) ⭐️1.9k - Swift 常用的数据结构。
* [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) ⭐️8.8k - CryptoSwift 是一个用 Swift 实现的标准和安全的密码算法集合。
* [GRKOpenSSLFramework](https://github.com/signalapp/GRKOpenSSLFramework) ⭐️12 - 适用于 iOS 和 macOS 的 SPM、CocoaPod 和 Carthage 的 penSSL 包
* [SHA256-Swift](https://github.com/CryptoCoinSwift/SHA256-Swift) - Swift framework wrapping CommonCrypto's SHA256 methods.
* [SwiftSSL](https://github.com/SwiftP2P/SwiftSSL) - An Elegant crypto toolkit in Swift.
* [SwiftyRSA](https://github.com/TakeScoop/SwiftyRSA) - RSA public/private key encryption in Swift
* [Algorithm-Guide](https://github.com/Xunzhuo/Algorithm-Guide) ⭐️1.4K - 循卓的算法与数据结构教程。
* [EllipticCurveKeyPair](https://github.com/agens-no/EllipticCurveKeyPair) ⭐️641 - 使用 Secure Enclave 进行签名、验证、加密和解密。
* [RNCryptor](https://github.com/RNCryptor/RNCryptor) ⭐️3.3k - 针对数据的 AES 加密封装。提供多语言封装解决方案。
* [DifferenceKit](https://github.com/ra1028/DifferenceKit) ⭐️3.1k - 一个用于 Swift 集合的快速而灵活的 O(n) 差分算法。



## 数学计算

[回到顶部](#Awesome Swift)

* [Surge](https://github.com/Jounce/Surge) ⭐️5k - 使用 Accelerate 框架，为矩阵数学、数字信号处理和图像处理提供高性能函数。
* [Euler](https://github.com/mattt/Euler) ⭐️1.1k - 直观、简洁的数学表达式 `∛27÷3+∑[3,1,2]`。
* [BigInt](https://github.com/attaswift/BigInt) ⭐️682 - 这个存储库提供了在纯 Swift 中实现的任意宽度的整数类型。基础表示形式为 2^64，使用 `Array<UInt64>`。
* :warning: [Euler](https://github.com/mattt/Euler) ⭐️1.1k - 用于数学符号的 Swift 自定义运算符
* [Easy-Cal-Swift](https://github.com/onevcat/Easy-Cal-Swift) - Overload +-*/ operator for Swift, make it easier to use (and not so strict).



## 图片加载&显示

[回到顶部](#Awesome Swift)

* :heart:[Kingfisher](https://github.com/onevcat/Kingfisher) ⭐️19.7k - 轻量级、纯 Swift 实现的网络图片下载和缓存框架。
* :heart:[blurhash](https://github.com/woltapp/blurhash) ⭐️10.2k - 图像占位符的非常紧凑的表示。
* [Nuke](https://github.com/kean/Nuke) ⭐️6.5k - 用于加载和缓存图像的高级框架。
* [HanekeSwift](https://github.com/Haneke/HanekeSwift) ⭐️5.1k - 轻量带缓存高性能图片加载组件。
* [Concorde](https://github.com/contentful-labs/Concorde) ⭐️1.4k - 
  渐进式下载和解码 JPEG 格式图片。
* [ImageScout](https://github.com/kaishin/ImageScout) ⭐️955 - 最小网络代价获得图片大小及类型。
* :warning: [ImageSizeFetcher](https://github.com/malcommac/ImageSizeFetcher) ⭐️440 - 通过 URL 获取图像类型或尺寸
* [FaceAware](https://github.com/BeauNouvelle/FaceAware) ⭐️3k - 这个插件帮助 `UIImageView` 将中心聚焦到照片的脸上，前提是这个照片使用了 `AspectFill`
* [ZoomTransition](https://github.com/tristanhimmelman/ZoomTransition) ⭐️267 - 通过手势操控图片的放大、缩小、旋转等自由变化效果的组件及示例。
* :orange: [VIPhotoView](https://github.com/vitoziv/VIPhotoView) ⭐️227 - 用于展示图片的工具类，因为是个 View，所以你可以放在任何地方显示。支持旋转，双击指定位置放大等。
* :orange: [MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser) ⭐️8.8k - 一个简单的 iOS 照片和视频浏览器，具有网格视图、导航栏标题和多选功能。
* :orange: [RKSwipeCards](https://github.com/cwRichardKim/RKSwipeCards) ⭐️2.2k - 基于手势的照片显示，左滑删除，右滑喜欢，你懂的！
* [PixelKit](https://github.com/heestand-xyz/PixelKit) ⭐️744 - 适用于 iOS、macOS 和 tvOS 的实时图形。
* [ZLPhotoBrowser](https://github.com/longitachi/ZLPhotoBrowser) ⭐️4.1k - 微信样式的图片选择器，支持预览 / 相册内拍照及录视频、拖拽 / 滑动选择，编辑图片 / 视频，支持多语言国际化等功能；
* [HXPHPicker](https://github.com/SilenceLove/HXPHPicker) ⭐️199 - Photo/Video Selector




### 图片编辑&滤镜

* [Toucan](https://github.com/gavinbunney/Toucan) ⭐️2.4k - 图片变换及处理框架，简化了图片制作，支持调整大小、裁剪和风格化你的图像。
* [PixelSDK](https://github.com/GottaYotta/PixelSDK) ⭐️333 - 适用于 iPhone / iPad 应用的现代照片和视频编辑器。一个完全可定制的图像和视频编辑 Swift 框架。
* [MetalFilters](https://github.com/alexiscn/MetalFilters) ⭐️316 - 基于 Metal 框架实现的 Instagram 风格图片滤镜库。
* [UIImageColors](https://github.com/jathu/UIImageColors) ⭐️3k - 图片色系决定界面背景色及字体显示颜色。获取主色、次色、背景色、详细色。
* [DominantColor](https://github.com/indragiek/DominantColor) ⭐️865 - 提取图片主色示例项目
* [issue-21-core-image-explorer](https://github.com/objcio/issue-21-core-image-explorer) ⭐️209 - objc.io 示例，Core Image 滤镜处理图片
* :orange: [CoreImageShop](https://github.com/rFlex/CoreImageShop) ⭐️418 - Mac 应用程序，让你创建一个 Core Image Filter 并轻松生成底层 Objective-C 代码。
* :orange: [CLImageEditor](https://github.com/yackle/CLImageEditor) ⭐️2.2k - 超强的图片编辑库，快速帮你实现旋转，防缩，滤镜等等一系列麻烦的事情。
* [MarkingMen](https://github.com/FlexMonkey/MarkingMen) ⭐️217 - 允许用户使用一个手势来浏览和选择菜单层次，该手势在屏幕上显示为一个连续的标记。
* [ZLImageEditor](https://github.com/longitachi/ZLImageEditor) ⭐️281- 一个强大的图像编辑器框架。支持涂鸦、裁剪、马赛克、文字贴纸、图片贴纸、滤镜。




### 图片编码&解码&压缩

* [KingfisherWebP](https://github.com/Yeatse/KingfisherWebP) ⭐️227 - Kingfisher 扩展，处理 WebP 格式图片。
* [png](https://github.com/kelvin13/png) ⭐️259 - 纯 Swift 代码解析 PNG 格式，返回图像原始像素数据和尺寸。
* [APNGKit](https://github.com/onevcat/APNGKit) ⭐️2k - 解析和显示 APNG 的框架。
* [AImage](https://github.com/wangjwchn/AImage) ⭐️1k - GIF/APNG 播放引擎。
* [gifu](https://github.com/kaishin/gifu) ⭐️2.7k - 高性能 GIF 显示类库
* [SwiftyGif](https://github.com/kirualex/SwiftyGif) ⭐️1.5k - 高性能 GIF 引擎。
* :orange: [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) ⭐️7.7k - Flipboard 开源的高性能 GIF 引擎
* [SwiftSVG](https://github.com/mchoe/SwiftSVG) ⭐️1.7k - 支持多种接口绘制 SVG 类库。
* [MetalPetal](https://github.com/MetalPetal/MetalPetal) ⭐️1.3k - MetalPetal 是一个用 Metal 做图像处理的框架。GPU 的图像处理框架，我们很容易想到的就是大名鼎鼎的 GPUImage，MetalPetal 可以说就是一个 Metal 版的 GPUImage。苹果近几年推广 Metal 的决心相信大家都有目共睹，Metal 不仅能提供了现代化的 API，也提供了碾压 OpenGL 的性能，是 iOS 上做 GPU 计算的不二之选。但如果我们希望用 Metal 来做图像和视频处理的时候，你会发现需要写非常多的代码才能够完成功能，比如图片加载，上传成纹理，创建 GPU 的 Pipelie 等等，而视频则更复杂，涉及到解码、调度、丢帧等一系列逻辑。MetalPetal 这类框架就是为了这个这样的问题而生，让你通过简单的函数调用就完成 GPU 的计算。大幅提升开发效率。
* [GPUImage3](https://github.com/BradLarson/GPUImage3) ⭐️2.3k - GPUImage3 是一个基于 BSD 许可协议的 Swift 框架，用于使用 Metal 进行 GPU 加速的视频和图像处理。
* :orange: [GPUImage](https://github.com/BradLarson/GPUImage) ⭐️19.9k - 一个开源 iOS 框架，基于 GPU 处理图像和视频。



## 音频

[回到顶部](#Awesome Swift)

* [AudioKit](https://github.com/audiokit/AudioKit) ⭐️9.1k - 适用于 iOS、macOS（包括 Catalyst）和 tvOS 的音频合成、处理和分析平台。
* [PandoraPlayer](https://github.com/ApplikeySolutions/PandoraPlayer) ⭐️1.1k - 一款轻量级的 iOS 音乐播放器，基于 AudioKit，完全用 Swift 编写。
* [MusicKit](https://github.com/benzguo/MusicKit) - Framework and DSL for creating, analyzing, and transforming music in Swift
* [WebMIDIKit](https://github.com/adamnemecek/WebMIDIKit/) - Simplest MIDI Swift framework
* [VoiceMemos](https://github.com/MoZhouqi/VoiceMemos) ⭐️323 - 一款适用于 iPhone 和 iPad 的录音机应用程序，涵盖了用 Swift 编写的 iOS 8 中引入的一些新技术和 API。
* :orange: [EZAudio](https://github.com/syedhali/EZAudio) ⭐️4.8k - 一个 iOS 和 OSX 上简单易用的音频框架，根据音量实时显示波形图，基于 Core Audio，适合实时低延迟音频处理，非常直观。
* :orange: [DOUAudioStreamer](https://github.com/douban/DOUAudioStreamer) ⭐️2.8k - 豆瓣开源的基于 Core Audio 的流式音频播放器。
* [VIWaveformView](https://github.com/VideoFlint/VIWaveformView) ⭐️91 - 从音频数据生成波形视图。



## 视频

[回到顶部](#Awesome Swift)

* [episode-code-samples](https://github.com/pointfreeco/episode-code-samples) ⭐️622 - 专注于学习 Swift 编程的视频聊天系列。
* [ARVideoKit](https://github.com/AFathi/ARVideoKit) ⭐️1.4k - 捕捉和记录 ARKit 视频、照片、实时照片和 GIFs。
* [youtube-iOS](https://github.com/aslanyanhaik/youtube-iOS) ⭐️2.4k - 像 YouTube iOS 应用一样在右侧观看缩略视频，用 Swift 3 编写。
* [BMPlayer](https://github.com/BrikerMan/BMPlayer) ⭐️1.8k - 该项目参考 OC 版的 ZFPlayer 开源项目，基于 `AVPlayer` 并使用 Swift 实现的 iOS 视频播放器，支持横竖屏。支持调整音量、亮度和滑动搜索，支持字幕。
* :heart: [Cabbage](https://github.com/VideoFlint/Cabbage) ⭐️1.3k 一个基于 `AVFoundation` 实现的视频编辑框架。
* :orange: [ZFPlayer](https://github.com/renzifeng/ZFPlayer) ⭐️6.7k - 基于 `AVPlayer`，支持竖屏、横屏（横屏可锁定屏幕方向），上下滑动调节音量、屏幕亮度，左右滑动调节播放进度 [iOS 视频播放器之 ZFPlayer 剖析](https://www.jianshu.com/p/5566077bb25f)
* :orange: [ijkplayer](https://github.com/bilibili/ijkplayer) ⭐️30k - Bilibili 开源的视频播放器
* :orange: [kxmovie](https://github.com/kolyvan/kxmovie) ⭐️2.8k - 基于 ffmpeg 的影片播放器。
* [VLC](http://www.videolan.org/) - VLC 是一款自由、开源的跨平台多媒体播放器及框架，可播放大多数多媒体文件，以及 DVD、音频 CD、VCD 及各类流媒体协议。
* :orange: [StreamingKit](https://github.com/tumtumtum/StreamingKit) ⭐️2.3k - 流媒体音乐播放器
* :orange: [FreeStreamer](https://github.com/muhku/FreeStreamer) ⭐️2.1k - 流媒体音乐播放器，cpu 占用非常小。
* :orange: [SCRecorder](https://github.com/rFlex/SCRecorder) ⭐️3.1k - 酷似 Instagram/Vine 的音频 / 视频摄像记录器，以 Objective-C 为基础的过滤器框架。 你可以做很多如下的操作：记录多个视频录像片段。删除任何你不想要的记录段。可以使用任何视频播放器播放片段。保存的记录可以在序列化的 NSDictionary 中使用。（在 NSUserDefaults 的中操作）添加使用 Core Image 的视频滤波器。可自由选择你需要的 parameters 合并和导出视频。
* :orange: [LLSimpleCamera](https://github.com/omergul/LLSimpleCamera) ⭐️1.2k - 一个简单的、可定制的相机控制--iOS的视频记录器。
* :orange: [ICGVideoTrimmer](https://github.com/itsmeichigo/ICGVideoTrimmer) ⭐️630 - 模仿 Instagram，用于快速修剪视频。
* [Learning-AV-Foundation-Swift](https://github.com/tapharmonic/Learning-AV-Foundation-Swift) ⭐️201 - 学习 AVFoundation 框架。
* [FFmpeg](https://github.com/FFmpeg/FFmpeg) ⭐️28.2k - FFmpeg 是一个库和工具的集合，用于处理多媒体内容，如音频、视频、字幕和相关元数据。
* [ffmpeg-kit](https://github.com/tanersener/ffmpeg-kit) ⭐️1.2k - 用于应用程序的 FFmpeg 套件。支持 Android、Flutter、iOS、macOS、React Native 和 tvOS。取代 MobileFFmpeg、flutter_ffmpeg 和 react-native-ffmpeg。
* [mobileplayer-iOS](https://github.com/sahin/mobileplayer-ios) ⭐️2.9k - 一款功能强大且完全可定制的 iOS 媒体播放器。
* [PiPhone](https://github.com/ky1vstar/PiPhone) ⭐️89 - Picture in picture video playback for iPhone。



## 通知中心

[回到顶部](#Awesome Swift)

* [LNRSimpleNotifications](https://github.com/LISNR/LNRSimpleNotifications) - Simple Swift in-app notifications
* [Notie](https://github.com/thii/Notie) - In-app notification in Swift, with customizable buttons and input text field.


## KVO

[回到顶部](#Awesome Swift)

* :heart: [Bond](https://github.com/DeclarativeHub/Bond) ⭐️4.2k - A Swift binding framework
* [Observable-Swift](https://github.com/slazyk/Observable-Swift) ⭐️1.2k - KVO for Swift - Value Observing and Events
* [RZDataBinding](https://github.com/Rightpoint/RZDataBinding) ⭐️551 - Lightweight KVO-based data binding options.



## 定位&地图

[回到顶部](#Awesome Swift)

* [LocationManager](https://github.com/jimmyjose-dev/LocationManager) ⭐️721 - 地理位置管理封装库。
* [MapManager](https://github.com/jimmyjose-dev/MapManager) ⭐️411 - 地图及路径管理封装库。
* [SwiftLocation](https://github.com/malcommac/SwiftLocation) ⭐️3k - 高效便捷的位置追踪、IP定位、Gecoder、地理围栏、自动完成、Beacon Ranging、广播器和访问监控。
* [mapbox-navigation-iOS](https://github.com/mapbox/mapbox-navigation-ios) ⭐️750 - 导航步骤逻辑和 UI。



## 相机&相册&二维码

[回到顶部](#Awesome Swift)

* [ImagePicker](https://github.com/hyperoslo/ImagePicker) ⭐️4.6k - A nicely designed and super easy to use ImagePicker.
* [HXPHPicker](https://github.com/SilenceLove/HXPHPicker) ⭐️138 - 照片/视频选择器-支持选择 LivePhoto，GIF，在线下载 iCloud 资源，以及编辑照片/视频。
* [EFQRCode](https://github.com/EyreFree/EFQRCode) ⭐️4.1k - A better way to operate quick response code in Swift.
* [swiftScan](https://github.com/MxABC/swiftScan) ⭐️1.4k - iOS 二维码、条形码 Swift 版本
* [Portrait-without-Depth-iOS]( koooootake/Portrait-without-Depth-iOS) ⭐️171 - 实现单摄人像模式。
* [CameraManager](https://github.com/imaginary-cloud/CameraManager) ⭐️1.2k - 相机管理封装类库，提供所有你需要的配置，以在你的应用程序中创建自定义相机视图。
* [SwiftyCam](https://github.com/Awalz/SwiftyCam) ⭐️1.9k - 一个用 Swift 编写的，受 Snapchat 启发的 iOS 相机框架。



## 即时通讯 IM

[回到顶部](#Awesome Swift)

* [MessageKit](https://github.com/MessageKit/MessageKit) ⭐️5k
* [aurora-imui](https://github.com/jpush/aurora-imui) ⭐️5.5k - 通用 IM 聊天 UI 组件，已经同时支持 Android/iOS/RN
* [Messenger](https://github.com/relatedcode/Messenger) ⭐️4.2k - Open source, native iOS Messenger, with realtime chat conversations (full offline support).
* 【Archived】[NMessenger](https://github.com/eBay/NMessenger) ⭐️2.5k - 更快更轻量级的消息组件，构建于 AsyncDisplaykit 并且由 Swift 编写
* [Cake](https://github.com/mxcl/Cake) ⭐️541 - 基于组件 MessageKit 及实时通讯云 Firestore 的即时通讯实现（功能参考 Facebook Messenger）。
* [Signal-iOS](https://github.com/signalapp/Signal-iOS) ⭐️9.2k - A private messenger for iOS.
* :warning: [eBay/NMessenger](https://github.com/eBay/NMessenger) ⭐️2.4k - 基于 AsyncDisplaykit 构建的快速、轻量级信息聊天 UI 组件。




## WebKit/HTML

[回到顶部](#Awesome Swift)

* [Marionette](https://github.com/LinusU/Marionette) ⭐️377 - 通过一套更高级的 API 控制 WKWebView。对标 Google Chrome 的 Puppeteer 库。
* [googleprojectzero/fuzzilli](https://github.com/googleprojectzero/fuzzilli)  ⭐️1.4k - Javascript 解释器引擎，技术融合的一大进步。
* [Vaux](https://github.com/dokun1/Vaux) - 一个允许你使用 Swift 生成 HTML 的库。
* [Ashton](https://github.com/IdeasOnCanvas/Ashton) ⭐️439 - MindNode 团队开发使用的 NSAttributedStrings 和 HTML 高性能互转类库。




## 蓝牙

[回到顶部](#Awesome Swift)

* [RxBluetoothKit](https://github.com/Polidea/RxBluetoothKit) ⭐️1.3k - 基于 RxSwift 框架的蓝牙库。
* :orange: [SmartDeviceLink-iOS](https://github.com/smartdevicelink/sdl_ios) ⭐️ 158 - 一组标准协议和消息，可将智能手机上的应用程序连接到车载主机。


## 应用内购买&订阅

[回到顶部](#Awesome Swift)

* [purchases-ios](https://github.com/RevenueCat/purchases-ios) ⭐️1.3k - 使应用内购买和订阅变得容易。支持 iOS、iPadOS、watchOS 和 Mac。


## Misc

*与Swift相关的各种项目* [回到顶部](#Awesome Swift)

* [acli](https://github.com/eugenpirogoff/acli) - commandline tool to download curated libraries from github (very beta)
* [Compass](https://github.com/hyperoslo/Compass) - Compass helps you setup a central navigation system for your application.
* [R.swift](https://github.com/mac-cain13/R.swift/) - tool to get strong typed, autocompleted resources like images and segues in your Swift project
* [SwiftKVC](https://github.com/bradhilton/SwiftKVC) - Key-Value Coding (KVC) for native Swift classes and structs
* [Tactile](https://github.com/delba/Tactile) - A safer and more idiomatic way to respond to gestures and control events.
* [Swift 4 Module Template](https://github.com/fulldecent/swift4-module-template) - An opinionated starting point for awesome, reusable Swift 4 modules
* [SwiftValidators](https://github.com/gkaimakas/SwiftValidators) - String validation for iOS developed in Swift. Inspired by validator.js
* [Versions](https://github.com/zenangst/Versions) - Helping you find inner peace when comparing version numbers in Swift
* [Swift 4 Module Template](https://github.com/fulldecent/swift4-module-template) - An opinionated starting point for awesome, reusable Swift 4 modules
* [XcodeGen](https://github.com/yonaskolb/XcodeGen) ⭐️5k - 一个用 Swift 编写的命令行工具，它使用文件夹结构和项目规范生成您的 Xcode 项目。



## 调试

[回到顶部](#Awesome Swift)

* [chisel](https://github.com/facebook/chisel) ⭐️8.7k - FaceBook 开源的 LLDB 调试命令集合。
* [FLEX](https://github.com/FLEXTool/FLEX) ⭐️12.6k - Flipboard 开源的一系列在应用中调试的工具集。
* [lowmad](https://github.com/bangerang/lowmad) 一个用于管理 LLDB 中的脚本和配置的命令行工具。
* [GDPerformanceView-Swift](https://github.com/dani-gavrilov/GDPerformanceView-Swift) ⭐️2.1k - 在状态栏上显示 FPS、CPU 和内存使用率、设备型号、应用程序和iOS版本，并通过委托（Delegate）报告 FPS、CPU 和内存使用率。
* [PAirSandbox-Swift](https://github.com/TeacherXue/PAirSandbox-Swift) ⭐️4 - PAirSandbox Swift 版，仿照 MrPeak 的 [PAirSandbox](https://github.com/music4kid/AirSandbox) 可方便实时查看沙盒中的文件并传送给 mac。
* [LifetimeTracker](https://github.com/krzysztofzablocki/LifetimeTracker) ⭐️2.7k - 更快地找到循环引用/内存泄漏。
* [DeallocationChecker](https://github.com/fastred/DeallocationChecker) ⭐️773 - 在不打开 Instruments 的情况下捕获内存泄漏的视图控制器。
* [LayoutInspector](https://github.com/isavynskyi/LayoutInspector) ⭐️490 - 3D 视角 iOS 应用布局视图检查器。
* :heart: [InjectionIII](https://github.com/johnno1962/InjectionIII) ⭐️2.8k - 支持 OC、Swift 以及 Swift 和 OC 混编项目的 UI 热重载工具，采取在模拟器 (真机不支持) 注入方式实现 UI 热重载，修改完 UI 直接 cmd+s，不用重新编译运行就能看到 UI 效果，堪称神器。 目前已经更新支持 Xcode13 和 iOS15。
* [SwiftTweaks](https://github.com/Khan/SwiftTweaks) ⭐️1.3k - 调整你的iOS应用，而不需要重新编译。
* [TweaKit](https://github.com/Cokile/TweaKit) ⭐️3 - 类似于 SwiftTweaks, 另一个用于调整参数和特征标记的库。
* [GodEye](https://github.com/zixun/GodEye) ⭐️3.7k - 基于 Swift 的一行代码自动显示 Log、Crash、Network、ANR、Leak、CPU、RAM、FPS、NetFlow、Folder 等。





---

推荐阅读：
* [Instruments 使用指南官方文档](https://developer.apple.com/library/archive/documentation/AnalysisTools/Conceptual/instruments_help-collection/Chapter/Chapter.html)
* [Clang Compiler User’s Manual](https://clang.llvm.org/docs/UsersManual.html#diagnostics_pragmas)
* [Advanced Debugging with Xcode and LLDB - WWDC 2018](https://developer.apple.com/videos/play/wwdc2018/412/)




## 测试

*用于测试代码和生成测试数据的框架。* [回到顶部](#Awesome Swift)

* :heart: [appium](https://github.com/appium/appium) ⭐️14.3k - iOS，Android 和 Windows 应用程序的**自动化 UI 测试框架**。
* [Quick](https://github.com/Quick/Quick) ⭐️9k - 一个行为驱动（BDD, Behavior-driven development）的针对 Swift 和 Objective-C 的单元测试框架。
* [Sleipnir](https://github.com/railsware/Sleipnir) - A BDD-style framework for Swift.
* [Nimble](https://github.com/Quick/Nimble) - 单元测试框架库
* [Fakery](https://github.com/vadymmarkov/Fakery) - Swift fake data generator.
* [SwiftRandom](https://github.com/thellimist/SwiftRandom) - Generator for random data.  
* [MockFive](https://github.com/DeliciousRaspberryPi/MockFive) - A mocking framework for Swift with runtime function stubbing.
* [MoonLight](https://github.com/AgoraIO-Community/MoonLight) ⭐️228 - Agoral 开源框架。MoonLight 是 iOS/Mac 上的性能测试组件，它可以单独集成在任何 App 中实现自动化性能数据的采集，你可以非常轻松的获取到 App CPU、System CPU、App Memory、System GPU、GPU Info、ANR 和 iOS FPS 的数据。



---

推荐阅读：

* [iOS 自动化测试的那些干货](https://github.com/LeoMobileDeveloper/Blogs/blob/master/iOS/iOS%E8%87%AA%E5%8A%A8%E5%8C%96%E6%B5%8B%E8%AF%95%E7%9A%84%E9%82%A3%E4%BA%9B%E5%B9%B2%E8%B4%A7.md)




## 项目管理&CI/CD

[回到顶部](#Awesome Swift)

* [tuist](https://github.com/tuist/tuist) ⭐️1.6k - Tuist 是一个命令行工具，可帮助您生成、维护 Xcode 项目并与之交互。
* [fastlane](https://fastlane.tools/)
* [Travis CI](https://travis-ci.org/)
* Jenkins
* [Danger](https://danger.systems/swift/)
* [Bitrise](https://www.bitrise.io/) - 持续集成和交付 (CI/CD) 平台即服务 (PaaS)，主要专注于移动应用程序开发（iOS、Android、React Native、Flutter 等）。它是一组工具和服务，可帮助您开发和自动化软件项目。
* [IBAnimatable](https://github.com/IBAnimatable/IBAnimatable) ⭐️8.6k - 使用 IBAnimatable 为 App Store 应用程序设计和定制原型 UI、交互、导航、过渡和动画 Interface Builder。



## 逆向与安全

[回到顶部](#Awesome Swift)

* [ipatool](https://github.com/majd/ipatool) ⭐️1.6k - 允许从 iOS App Store 搜索和下载应用包（ipa 文件）的命令行工具。
* [stefanesser/dumpdecrypted](https://github.com/stefanesser/dumpdecrypted) ⭐️2.7k - 将加密的 iPhone 应用程序中的解密的 mach-o 文件从内存转储到磁盘。
* [AloneMonkey/dumpdecrypted](https://github.com/AloneMonkey/dumpdecrypted) ⭐️252
* [mocha](https://github.com/White-White/mocha) ⭐️31 - Mocha 是一款 Swift 编写的 Mach-O 文件可视化工具，通过解释 Mach-O 文件中每一个字节的含义，帮助使用者理解 Mach-O。
* [MonkeyDev](https://github.com/AloneMonkey/MonkeyDev) ⭐️5.6k - CaptainHook Tweak、Logos Tweak 和命令行工具、修补 iOS 应用程序，无需越狱。
* [frida-ios-dump](https://github.com/AloneMonkey/frida-ios-dump) ⭐️2.3k - 从越狱设备中提取解密的 ipa 文件。






### FaceID/TouchID

* [BiometricAuthentication](https://github.com/rushisangani/BiometricAuthentication) ⭐️780 - 针对 Face ID 和 Touch ID 更简洁地封装使用。
* [SwiftPasscodeLock](https://github.com/yankodimitrov/SwiftPasscodeLock) ⭐️672 - 一个用 Swift 写的 TouchID 身份验证的 iOS 密码锁。




## 日志

*用于生成和处理日志文件的框架* [回到顶部](#Awesome Swift)

* [sentry](https://github.com/getsentry/sentry) ⭐️30.5k - Sentry 是跨平台的应用程序监控，专注于错误报告。
* [apple/swift-metrics](https://github.com/apple/swift-metrics) ⭐️510 - 苹果开源并逐步固定 Metrics API，以方便用户对应用的运行及资源状态进行有效跟踪。
* [apple/swift-log](https://github.com/apple/swift-log) ⭐️2.7k - A Logging API for Swift
* [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) ⭐️5.4k - SwiftyBeaver 是 Swift 的一款丰富多彩的，可扩展的，轻量级日志记录器。
* [XCGLogger](https://github.com/DaveWoodCom/XCGLogger) ⭐️3.7k - 允许你将细节记录到控制台，并且包含日期、函数名、文件名和行数等额外信息。
* [Rainbow](https://github.com/onevcat/Rainbow) ⭐️1.6k - Rainbow 为 Swift 中的控制台和命令行输出增加了文本颜色、背景颜色和样式。它是为跨平台的软件终端记录而诞生的，在苹果的平台和Linux中都能工作。
* [CleanroomLogger](https://github.com/emaloney/CleanroomLogger) ⭐️1.3k - 简单、轻量级且高性能的可配置和可扩展的纯SWIFT日志记录API。
* [Swell](https://github.com/hubertr/Swell) - A logging utility for Swift and Objective C.
* [Log](https://github.com/delba/Log) - A logging tool with built-in themes, formatters, and a nice API to define your owns.
* [QorumLogs](https://github.com/goktugyil/QorumLogs) ⭐️781 - Swift Logging Utility for Xcode & Google Docs.
* [NSLogger](https://github.com/fpillet/NSLogger) ⭐️4.9k - A high perfomance logging utility which displays traces emitted by client applications running on Mac OS X, iOS and Android.
* [Pulse](https://github.com/kean/Pulse) ⭐️4.2k - Apple 平台的网络检查器和记录器。
* [PulsePro](https://github.com/kean/PulsePro) ⭐️200 - Pulse Pro 是一款专业的 macOS 应用程序，可让您实时查看日志。该应用程序旨在灵活、可扩展和准确，同时使用所有熟悉的 macOS 模式。它可以通过表格和文本模式、过滤器、滚动标记、全新的网络检查器、JSON 过滤器等方式轻松导航大型日志文件。[raywenderlich 教程](https://www.raywenderlich.com/30189310-pulse-sdk-integration-tutorial-for-ios-network-logger)



## 文档

*生成文档文件的框架* [回到顶部](#Awesome Swift)

* [realm/jazzy](https://github.com/realm/jazzy) ⭐️7.1k - 为 Swift 或 Objective-C 生成文档的命令行工具
* [swift-docc-plugin](https://github.com/apple/swift-docc-plugin) ⭐️122 - Swift-DocC 插件是一个 Swift Package Manager 命令行插件，支持为 SwiftPM 库和可执行文件构建文档。



## 命令行

*用于创建命令行应用程序的框架* [回到顶部](#Awesome Swift)

* [CommandCougar](https://github.com/surfandneptune/CommandCougar) - An elegant pure Swift library for building command line applications.
* [SwiftInfo](https://github.com/rockbruno/SwiftInfo) ⭐️1k - 命令行工具跟踪检查 iOS 应用版本代码级变化。
* [Bagbutik](https://github.com/MortenGregersen/Bagbutik) ⭐️22 - 根据官方 OpenAPI 规范为 App Store Connect API 生成 Swift 代码。
* [LicensePlist](https://github.com/mono0926/LicensePlist) ⭐️2.1k - iOS 应用程序的所有 dependencies 的 Lincense 列表生成器。



## 代码格式化

[回到顶部](#Awesome Swift)

* :heart: [SwiftLint](https://github.com/realm/SwiftLint) ⭐️15.6k
* [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) ⭐️5.3k
* [prettier](https://github.com/prettier/prettier) ⭐️41.6k
* [SwiftRewriter](https://github.com/inamiy/SwiftRewriter) ⭐️814 - 基于 SwiftSyntax 针对代码进行自动格式化（其中包括基于代码规范进行简单的代码优化）。



## 函数式响应式编程

何为响应式编程？面向数据流和变化传播（时间和事件非代码顺序）的编程范式。[回到顶部](#Awesome Swift)

* :heart: [RxSwift](https://github.com/ReactiveX/RxSwift) ⭐️22.1k - 简单、高效，活泼的函数响应式编程框架。
* [RxGesture](https://github.com/RxSwiftCommunity/RxGesture) ⭐️1.2k - 用于视图手势的 RxSwift 响应式包装器。
* [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) ⭐️2.8k - ReactiveSwift 提供了可组合的、声明式的和灵活的基本类型。
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) ⭐️20k - ReactiveCocoa 使用 ReactiveSwift 的基本类型来封装 Cocoa 框架的方方面面。
* [ReactKit](https://github.com/ReactKit/ReactKit) ⭐️1.2k - Swift Reactive Programming.
* [ReactiveAPI](https://github.com/sky-uk/ReactiveAPI) ⭐️74 - 借助 RxSwift 的强大功能，依靠 URLSession 编写干净、简洁和声明式的网络代码。灵感来自 Retrofit。
* [Dollar](https://github.com/ankurp/Dollar) ⭐️4.2k - Swift 版 Lo-Dash (或 underscore) 函数式工具库。
* [ReSwift](https://github.com/ReSwift/ReSwift) ⭐️7.1k - 该框架主要针对单页面应用状态及单向数据流管理。
* [swiftz](https://github.com/maxpow4h/swiftz) - A Swift library for functional programming.
* [CardParts](https://github.com/intuit/CardParts) ⭐️2.4k - 基于卡片的响应式 UI 框架。



## Combine

[回到顶部](#Awesome Swift)

> Apple 在 iOS 13 中发布了 [Combine](https://developer.apple.com/documentation/combine) 框架。Combine 是 Apple 的**函数式响应式编程框架**，与 RxSwift 类似，但也有很大不同。Combine 的主要卖点是它是一个第一方框架。这意味着它将由 Apple 维护，并随着 Apple 操作系统的发布而更新，这既有好处，也有缺点。不可否认，Apple 对 Combine 押下重注，值得一看。特别是因为 SwiftUI 大量使用了 Combine。

* [CombineSwiftPlayground](https://github.com/AvdLee/CombineSwiftPlayground)
* [OpenCombine](https://github.com/OpenCombine/OpenCombine) ⭐️2.1k - 用于随时间处理值的 Apple Combine 框架的开源实现。
* [CombineExt](https://github.com/CombineCommunity/CombineExt)
* [swiftui-notes](https://github.com/heckj/swiftui-notes) ⭐️1.4k - 关于用 UIKit 和 SwiftUI 学习 Combine 的笔记。
* [RxCombine](https://github.com/CombineCommunity/RxCombine) ⭐️871 - RxSwift 和 Apple Combine 框架之间的双向桥接类型



## CoreML

[回到顶部](#Awesome Swift)

* [CoreMLHelpers](https://github.com/hollance/CoreMLHelpers) ⭐️962 - 一些输入/输出类型转换和扩展，以便于更容易地去使用 CoreML。
* [Inception-Core](https://github.com/hollance/Inception-Core) ⭐️92 - Inception-v3 运行在 CoreML 框架内
* [visual-recognition-coreml](https://github.com/watson-developer-cloud/visual-recognition-coreml) ⭐️491 - 来自 IBM Watson 的视觉识别及机器学习示例。 使用 Watson Swift SDK 管理和执行定制的训练模型。
* [NSFWDetector](https://github.com/lovoo/NSFWDetector) ⭐️1.4k - 用 CoreML 扫描、过滤不雅图片。
* [waifu2x-ios](https://github.com/imxieyi/waifu2x-ios) ⭐️ 395 - [waifu2x](https://github.com/nagadomi/waifu2x) 是一个用于动漫风格图像的图像缩放和图像降噪程序，也支持处理普通图片。[文章](https://mp.weixin.qq.com/s/51p62kRXwL4MiAWrZ1jtyg)





## ARKit

[回到顶部](#Awesome Swift)

* [Awesome-ARKit](https://github.com/olucurious/Awesome-ARKit) ⭐️7.2k - AR 开源项目汇总列表。
* [ARKit2.0-Prototype](https://github.com/SimformSolutionsPvtLtd/ARKit2.0-Prototype) ⭐️242 - AR 2.0 实现效果原型演示
* [ARKit-CoreLocation](https://github.com/ProjectDent/ARKit-CoreLocation) ⭐️5.1k - AR 与 GPS 精确数据的结合，开始一次导航之旅。非常重要的实验性项目，未来开发前景可期。
* [ARKit-SCNPath](https://github.com/maxxfrazer/ARKit-SCNPath) ⭐️327 - 方便地绘制一条 AR 场景导航路径。
* [VidEngine](https://github.com/endavid/VidEngine) - 用 Metal (GPU) 技术封装实现的 3D渲染引擎。
* [ARCharts](https://github.com/Boris-Em/ARCharts) ⭐️692 - 适用于 iOS 的可爱增强现实图表 - 使用 ARKit 构建。



## TensorFlow

[回到顶部](#Awesome Swift)

* [tensorflow/swift](https://github.com/tensorflow/swift) ⭐️6k - 集成使用 TensorFlow 专用版 Swift。
* [swix](https://github.com/scottsievert/swix) - Swift 矩阵与机器学习库.
* [xmartlabs/Bender](https://github.com/xmartlabs/Bender) ⭐️1.7k - 在 iOS 上轻松构建快速神经网络！使用 TensorFlow 模型。



## Metal

[回到顶部](#Awesome Swift)

* [Satin](https://github.com/Hi-Rez/Satin) ⭐️329 - 基于 Metal API 实现的一个 3D 引擎
* [Harbeth](https://github.com/yangKJ/Harbeth) ⭐️79 - 图形处理和滤镜制作
* [BBMetalImage](https://github.com/Silence-GitHub/BBMetalImage) ⭐️795 - 用于基于 Metal 的 GPU 加速图像/视频处理的高性能 Swift 库。



## Xcode 扩展

[回到顶部](#Awesome Swift)

* [XcodeCommentWrapper](https://github.com/SteveBarnegren/XcodeCommentWrapper) - 用于包装注释的 Xcode 扩展



## 其他 Awesome 列表

[回到顶部](#Awesome Swift)

* [awesome-ios](https://github.com/vsouza/awesome-ios) ⭐️39.1k - vsouza 发起维护的 iOS 资源列表，内容包括：框架、组件、测试、Apple Store、SDK、XCode、网站、书籍等。
* [awesome-swift@matteocrippa](https://github.com/matteocrippa/awesome-swift) ⭐️21.3k - Swift 库和资源的集合。
* [awesome-swift@Wolg](https://github.com/Wolg/awesome-swift) ⭐️5.2k
* [SwiftGuide](https://github.com/ipader/SwiftGuide) ⭐️15.6k - Swift 开源精选
* [robin.eggenkamp](https://swift.zeef.com/robin.eggenkamp)
* [TimLiu-iOS](https://github.com/Tim9Liu9/TimLiu-iOS) ⭐️10.9k - iOS 开发常用三方库、插件、知名博客等等。
* [trip-to-iOS](https://github.com/Aufree/trip-to-iOS) ⭐️7.8k - iOS 学习资料整理。
* [awesome-ios-cn](https://github.com/jobbole/awesome-ios-cn) ⭐️4k - iOS 资源大全中文版，内容包括：框架、组件、测试、Apple Store、SDK、Xcode、网站、书籍等。
* [kechengsou/awesome-ios](https://github.com/kechengsou/awesome-ios) ⭐️300 - iOS 开发者资源大全
* [Design-Patterns-In-Swift](https://github.com/ochococo/Design-Patterns-In-Swift) ⭐️13.2k - Swift 5.0 设计模式
* [awesome-ios-architecture](https://github.com/onmyway133/awesome-ios-architecture) ⭐️4.5k - Better ways to structure iOS apps
* [Awesome-Swift-Playgrounds](https://github.com/uraimo/Awesome-Swift-Playgrounds) ⭐️3.6k - A List of Awesome Swift Playgrounds
* [Optimizing-Swift-Build-Times](https://github.com/fastred/Optimizing-Swift-Build-Times) ⭐️3.5k - 收集关于优化 Swift 项目编译时间的建议。
* [FRP iOS Learning resources](https://gist.github.com/JaviLorbada/4a7bd6129275ebefd5a6) ⭐️1.3k - 函数响应式编程学习资源



