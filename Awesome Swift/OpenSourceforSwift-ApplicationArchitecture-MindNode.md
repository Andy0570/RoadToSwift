# Swift 开源项目精选 - 应用架构角度  ➟ GitHub


# Learning & Advanced



## <*livestreams, videos and sessions*> insidegui/WWDC ➟ macOS

WWDC 现场、视频及相关资源汇集应用（非官方）



## ……


# Developer Tools


## Package Manager

### <*Package Manager*> apple/swift-package-manager ➟ macOS

苹果官方 Swift 包管理

### <*dependency manager*> Carthage/Carthage ➟ macOS

简单，去中心化库依赖管理框架。 入门指南：[https://www.raywenderlich.com/416-carthage-tutorial-getting-started](https://www.raywenderlich.com/416-carthage-tutorial-getting-started)

###  <*Git Hooks*> orta/Komondor ➟ macOS

在 Swift 项目中支持 Git hooks。 配置实例：https://github.com/orta/Komondor/blob/master/Documentation/with_swiftpm.md

### <*third-party dependencies*> mxcl/swift-sh ➟ macOS | Linux

最简单、实用的依赖库导入脚本。这太方便了

### <*dependency manager*> JamitLabs/Accio ➟ macOS

结合 SwiftPM，为 Carthage 锦上添花的包管理命令行工具。

## <*App Store Connect API*> AvdLee/appstoreconnect-swift-sdk ➟ macOS

“借助 App Store Connect API 实现工作流程自动化”，这个库是对整套工作流程 Swift 版的易用化封装。
REST API：https://[developer.apple.com/documentation/appstoreconnectapi](http://developer.apple.com/documentation/appstoreconnectapi)
APP STORE CONNECT 使用入门（官方中、英、日文版）[https://help.apple.com/app-store-connect/](https://help.apple.com/app-store-connect/)

## <*design & prototype*> IBAnimatable/IBAnimatable ➟ iOS | macOS

IBAnimatable 是一个帮助我们在 Interface Builder 和 Swift Playground 里面设计 UI, 交互, 导航模式, 换场和动画的开源库。 [https://github.com/IBAnimatable/IBAnimatable/blob/master/Documentation/README.zh.md](https://github.com/IBAnimatable/IBAnimatable/blob/master/Documentation/README.zh.md)



## <*code generator*> mac-cain13/R.swift ➟ macOS

常用资源（images，fonts, ,colors 等）通过更易用的强类型方式在 Xcode 编辑器输入并自动转换。

## XCTest



### <*snapshot testing*> pointfreeco/swift-snapshot-testing ➟ iOS | macOS

通过快照记录方式进行自动化测试。非常直观方便的一种方式。

## <*network debugging tool*> yagiz/Bagel ➟ iOS | macOS

iOS 网络通讯本地调试神器（用 Bounjour 协议，不需要繁琐的连接证书之类的）。





## <*science-journal*> google/science-journal-ios ➟ iOS

Google 科学日志 iOS 版应用开源。






# 

## App Services



### editor

- <*integration with your app*> coteditor/CotEditor ➟ macOS

	轻量，但功能一点也不轻量的 App Store 上架的开源文本编辑器（几乎支持所有主流格式语法高亮显示，且可以扩展及自定义）

- <*Editor Kit*> GeekTree0101/VEditorKit ➟ iOS

	功能强大、完成度非常高的 iOS 编辑器组件。



### Markdown

- <*cmark*> iwasrobbed/Down ➟ iOS | macOS

	集成调用 cmark 的高性能 Markdown 渲染实现库及演示。支持多种输出式（Web View, HTML, XML, LaTeX 等）也许是性能外加可用性最高的一个版本了。

- <*WKWebView*> keitaoouchi/MarkdownView ➟ iOS

	Markdown 文档预览视图组件。

-  <*WKWebView*> tophat/RichTextView ➟ iOS

	兼具主流格式解析（LaTeX, HTML, Markdown）及简单视频嵌入（YouTube/Vimeo）功能富文本浏览视图。

- <*customizable Markdown Parser*> moliveira/MarkdownKit ➟ iOS | macOS

	一款简单地可定制化 Markdown 解析预览类库。

### ePub

-  <*reader & framework for ePub*> FolioReader/FolioReaderKit ➟ iOS

	ePub 阅读器及解析框架类库。这个很震撼，开发者还同步提供 Android 版。





### Web Services

- <*iOS SDK for AWS AppSync*> awslabs/aws-mobile-appsync-sdk-ios ➟ iOS

	来自 Amazon Web Services 实验室的 AWS AppSync iOS SDK。

- <*AWS SDK*> swift-aws/aws-sdk-swift ➟ macOS | Linux 

	支持 macOS 和 Ubuntu 的 AWS SDK。



## UIKit & AppKit

### View and Controls

- <*Form*> xmartlabs/Eureka ➟ iOS

	“由XMARTLABS精心编写，是XLForm的Swift版本。”https://github.com/xmartlabs/Eureka/blob/master/Documentation/README_CN.md

- <*folding paper card*> Ramotion/folding-cell ➟ iOS 

	自然流畅、清新的单元格可折叠视图及演示库。

- <*Image*> onevcat/Kingfisher ➟ iOS | macOS

	轻量级下载、缓存网络图像视图库。

- <*Charts*> danielgindi/Charts ➟ iOS | macOS

	Android 图表开源库 MPAndroidChart 的 Swift 版。相当于在 Apple 的跨平台版本。

- <*modal segue*> SwiftKickMobile/SwiftMessages ➟ iOS

	高可定制信息弹窗组件

- <*modal*> slackhq/PanModal ➟ iOS 

	这款可定制性底部上滑式模态窗口组件开发和用户体验都不错啊。

- <*Calendar*> patchthecode/JTAppleCalendar ➟ iOS

	功能强大、高可定制日历组件。

- <*UILabel morphing*> lexrus/LTMorphingLabel ➟ iOS

	特赞的文字飘入飘出效果。

- <*skeleton loading*> Juanpe/SkeletonView ➟ iOS

	等待加载信息前，预先优雅的显示内容骨架。

- <*loading*> farshadjahanmanesh/loady ➟ iOS

	常用可定制载入进程按钮动画。

- <*UITextFields*> raulriera/TextFieldEffects ➟ iOS

	定制的不同风格 UITextFields 输入框。

- <*UINavigationController*> andreamazz/AMScrollingNavbar ➟ iOS

	可滚动的（显示或隐藏 UINavigationBar

- <*Mac style Menu*> TwoLivesLeft/Menu ➟ iOS

	著名 iPad 编程应用 Codea（Lua 语言） 开源传统菜单如何存在于小屏幕设计思路及解决方案。

- <*floating panel*  > IdeasOnCanvas/Aiolos ➟ iOS

	MindNode  iOS 项目中使用的浮动面板。

- <*A simple routing library*> hubrioAU/XRouter ➟ iOS

	一款使用简单，结构清晰同时支持 URL 的应用路由库。

- *<range picker> Cuberto/rubber-range-picker* ➟ iOS

	很带人情味的数字区间选择。

- <*progress view*> mac-gallagher/MultiProgressView ➟ iOS

	多区间进程条展示效果组件及示例。

### View Layout



### window

- <*window manager*> ianyh/Amethyst ➟ macOS

	自动排列及快捷操作切换、管理窗口。

### Animations

- <*animations framework*> timdonnelly/Advance ➟ iOS | macOS  

	一款高阶仿真动画框架库。

- <*animations*> MengTo/Spring ➟ iOS

	精简版动画库（并附动画功能展示和调试功能）。

- <*loading & animations*> ninjaprox/NVActivityIndicatorView ➟ iOS

	酷炫的装载动画库及演示。满足你对装载动画的个性化需求。

- <*transition*> HeroTransitions/Hero ➟ iOS

	类似于 Keynote 的 Magic Move 的 transition 库。极为易用、支持自动布局。

- <*transition*> marcosgriselli/ViewAnimator ➟ iOS

	简单的代码实现复杂 UI 布局及动画切换。

- <*liquid swipe animation* > Cuberto/liquid-swipe ➟ iOS

	液滑动画效果升级版。

- <*vector animations*> airbnb/lottie-ios ➟ iOS | macOS 

	Airbnb 矢量级动画渲染库全面迁移至 Swift 版本。其势不可挡。

- <*animations*> sagaya/Wobbly ➟ iOS 

	对界面组件元素实现各种摇晃抖闪的动画效果。

### <*UIKit extensions*> haoking/SwiftyUI ➟ iOS

轻量、高性能的 UI 渲染及扩展类库。

### <*Declarative UI construction*> square/Blueprint ➟ iOS

Square 公司开源的自用声明式 UI 开发框架库。

### <*hand-drawn, comic shape*> onmyway133/RoughSwift ➟ iOS

编程方式创建手绘和漫画风格画面。酷炫！


# IoT ➟ Ubuntu | Raspain


## <*Swift on ARM devices*> uraimo/buildSwiftOnARM ➟ Shell

持续提供使 Swift 运行于 ARM 上的编译版本（已经更新到 Swift 4.1.3 ），它几乎支持所有的（运行于 Ubuntu 16.04 和 Raspbain）树莓派版本。

## <*hardward projects*> uraimo/SwiftyGPIO ➟ Linux

通过 Swift 语言去控制基于 Linux/ARM 主板（比如：C.H.I.P. 和 树莓派） 的 GPIO（General Purpose Input Output ），去完成简单的工控功能（比如 LED 灯的显示）。

## ……


# Foundation ➟ iOS | macOS | watchOS | Linux


## Utility



### <*JSON parser*> SwiftyJSON/SwiftyJSON

GitHub 上最为开发者认可的 JSON 解析库。

###  <*JSON parser & object mapping*> tristanhimmelman/ObjectMapper

简介：对象与JSON互转实用类库。
推荐理由：面向对象模型，易于开发集成。有更完善的与 Alamofire 的集成方案。

### <*Binary Codable*> jverkoey/BinaryCodable ➟ iOS | macOS | Linux

Codable 风格实现 Binary 数据的 Decode/Encode。

### <*Codable extension*> JohnSundell/Codextended ➟ macOS | Linux

为自定义 Codable 而生的扩展 API。

## Security

### <*cryptographic algorithms*> krzyzanowskim/CryptoSwift

Crypto 算法及相关功能类库集合

## Database & Client

###  <*SQLite*> stephencelis/SQLite.swift

简单、轻量，使用上最 SQL 的 SQLite 封装库。



## GitHub

### <*GitHub client API*> nerdishbynature/octokit.swift

同时支持 GitHub 和 GitHub 企业版 Swift API 客户端类库。

##  Cognitive Computing 

### <*tensorflow apis*> tensorflow/swift-apis ➟ macOS

### <*IBM Watson*> watson-developer-cloud/swift-sdk ➟ iOS | Linux

让开发者在自己的应用内快速应用 IBM Watson Cognitive Computing 服务。



## ……


# IBM Watson Services (AI)


# Database Server (cross platform)


## ➟ Shell  <*Realm Platform>* realm/realm-object-server

Realm 平台目标实现可交互的移动数据库

## ……


# iCloud & Remote (iCloud, On-drive, Dropbox, Webdav, ftp/ftps, Samba...)


# TensorFlow (pre-trained model)


## <*TensorFlow to CoreML Converter*> tf-coreml/tf-coreml ➟ Python


# Caffe (Neural networks model)

