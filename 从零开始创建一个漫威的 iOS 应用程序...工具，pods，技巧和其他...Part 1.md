> 原文：[Creating a Marvel iOS App from scratch.. Tools, pods, tricks of the trade and more .. Part 1](https://medium.com/cocoaacademymag/creating-a-ios-app-from-scratch-tools-pods-tricks-of-the-trade-and-more-part-1-a0a3f18fbd13#.fc7jia6q3)
>
> 通过 [DeepL](https://www.deepl.com/translator) 翻译并由本人校对。



今天我将开始发表一系列帖子，展示如何从零开始创建一个 iOS 应用程序，并使用许多不同的 pods 和工具，使你的生活更容易。这个项目将被分成几个部分并涵盖许多重要的主题。你通常可以在其他地方找到这些信息，但他们被分割在不同的不相关的教程中，我这里的方法是在同一个项目中传达所有的信息，你可以在[这里](https://github.com/thiagolioy/marvelapp)找到源代码。在不同的时间点上会有不同的 tag 标签，涵盖第一部分、第二部分等等。


## 路线

* 如何使用 [Moya](https://github.com/Moya/Moya) + [RxSwift](https://github.com/ReactiveX/RxSwift) 创建一个网络层。
* 如何使用 Json -> Model 映射框架来解析响应数据。
* 如何使用外部数据源和委托，来避免视图控制器的臃肿化（MMVC）。这将使 tableView/CollectionView 的模板代码保持在它应该的位置。
* 如何使用 [SwiftGen](https://github.com/SwiftGen/SwiftGen) 的 Enums 处理 storyboards 和视图控制器，使一切变得更加安全。
* 使用更好的[重用](https://github.com/AliSoftware/Reusable)机制来处理 tableView 和 collectionView 的单元格。
* 如何使用 [Kingfisher](https://github.com/onevcat/Kingfisher) 处理图片下载。
* 使用 [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) 处理 Marvel api 的特定安全需求。
* 使用 [cocoapods-keys](https://github.com/orta/cocoapods-keys) 将敏感数据和密钥与存储库分离。

后面的帖子将会提到：

* 如何测试应用程序的各个层级（网络层、模型层、控制器层、数据源等等）。
* 如何生成覆盖率报告。
* 使用 [Fastlane](https://fastlane.tools/) 实现开发流程的自动化。
* 如何使用 [Travis](https://travis-ci.org/) 为 Github 项目配置持续集成。
* 使用 [Danger](http://danger.systems/) 为你的存储库创建 PR 规则。
* 开发者的 [Skecth](https://www.sketch.com/)! 如何创建 "引导式" 的设计。

## App

在该项目中，我选择使用 Marvel 的 [api](https://developer.marvel.com/) 创建一个名为 Marvel 的应用程序。第一部分都聚集在 v0.1 的 Tag 标签下。你只需要克隆仓库并切换 Tag 标签到 v0.1 下即可。

**声明**：页面的样式布局将在以后我们讨论 skecch 和开发人员的设计时得到加强，目前它非常简单，就像下面这样：


![](https://i.loli.net/2021/12/02/PDIeCzkXo72l6tR.png)

## 重要的事情先来... Podfile 文件

所以，让我先在这里展示，在第一部分中我们要使用哪些 pods。

```ruby
# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Marvel' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  plugin 'cocoapods-keys', {
    :project => "Marvel",
    :keys => [
      "MarvelApiKey",
      "MarvelPrivateKey"
    ]}

  # Pods for Marvel
   pod 'SwiftGen'
   pod 'RxSwift', '~> 3.0.0-beta.2'
   pod 'Moya/RxSwift','~> 8.0.0-beta.1'
   pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/ivanbruel/Moya-ObjectMapper'
   pod 'CryptoSwift'
   pod 'Dollar'
   pod 'Kingfisher'
   pod "Reusable"

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
```

这个 Podfile 文件有些特别之处，它使用了上面提到的 [cocoapods-keys](https://www.google.com.br/search?client=safari&rls=en&q=cocoapods-keys&ie=UTF-8&oe=UTF-8&gfe_rd=cr&ei=edAyWPTfIYKF8QeDxbW4Ag) 插件，这将允许我们在第一次运行 `pod install` 时在我们的钥匙串中设置钥匙串的值。这个配置步骤完成之后，我们就可以在代码中注入钥匙串的值，而不需要将它们硬编码到我们的 Git 存储库中。不仅如此，它还允许你们使用你们自己的 Marvel 的 api 密钥，这些密钥可以在[这里](https://developer.marvel.com/)生成。这多好啊？谢谢 
[orta](https://medium.com/@orta) ...

```ruby
plugin 'cocoapods-keys', {
    :project => "Marvel",
    :keys => [
      "MarvelApiKey",
      "MarvelPrivateKey"
    ]}
```

在 api key 创建和项目设置之后，让我们继续下一部分。

## 基于 Moya 的网络层

Moya 是一个了不起的 pod，它可以管理所有的模板和必须复杂地一个项目接一个项目地创建你自己的网络抽象层。虽然它不必与 RxSwift 一起使用，但为了本教程的目的，我打算将两者结合起来使用。

```swift
import Foundation
import Moya
import CryptoSwift
import Dollar
import Keys

fileprivate struct MarvelAPIConfig {
    fileprivate static let keys = MarvelKeys()
    static let privatekey = keys.marvelPrivateKey()!
    static let apikey = keys.marvelApiKey()!
    static let ts = Date().timeIntervalSince1970.description
    static let hash = "\(ts)\(privatekey)\(apikey)".md5()
}

enum MarvelAPI {
    case characters(String?)
    case character(String)
}

extension MarvelAPI: TargetType {
    var baseURL: URL { return URL(string: "https://gateway.marvel.com:443")! }
    
    
    var path: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .character(let characterId):
            return "/v1/public/characters/\(characterId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .characters, .character:
            return .get
        }
    }
    
    func authParameters() -> [String: String] {
        return ["apikey": MarvelAPIConfig.apikey,
                "ts": MarvelAPIConfig.ts,
                "hash": MarvelAPIConfig.hash]
    }
    
    var parameters: [String: Any]? {
        
        switch self {
        
        case .characters(let query):
            if let query = query {
                return $.merge(authParameters(),
                               ["nameStartsWith": query])
            }
            return authParameters()
            
        case .character(let characterId):
            return $.merge(authParameters(),
                           ["characterId": characterId])
        }
    }
    
    var task: Task {
        return .request
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
}
```

这就是定义 api 设置、path 路径、参数、方法等等的超级简单的使用方法。存储属性 `sampleData` 将在稍后关于测试的文章中使用。同样值得一提的是 MarvelAPIConfig 结构和 authParameters 方法，它们都需要遵守 marvel api 的强制需求。authParameters 与用户创建的参数合并在一起，使用了一个很好的名为 [Dollar](https://dollarswift.org/) 的 pod，它有很多有用的方法。

在创建了api 设置之后，我们仍然需要创建一个 Moya 提供者来使用 api，这可以在任何地方完成，尽管强烈建议创建另一个抽象来处理这种逻辑。

```swift
import Foundation
import Moya
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

extension Response {
    func removeAPIWrappers() -> Response {
        guard let json = try? self.mapJSON() as? Dictionary<String, AnyObject>,
            let results = json?["data"]?["results"] ?? [],
            let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted) else {
                return self
        }
        
        let newResponse = Response(statusCode: self.statusCode,
                                   data: newData,
                                   response: self.response)
        return newResponse
    }
}

struct MarvelAPIManager {
    
    let provider: RxMoyaProvider<MarvelAPI>
    let disposeBag = DisposeBag()
    
    
    init() {
        provider = RxMoyaProvider<MarvelAPI>()
    }
    
}

extension MarvelAPIManager {
    typealias AdditionalStepsAction = (() -> ())
    
    fileprivate func requestObject<T: Mappable>(_ token: MarvelAPI, type: T.Type,
                                   completion: @escaping (T?) -> Void,
                                   additionalSteps: AdditionalStepsAction? = nil) {
        provider.request(token)
            .debug()
            .mapObject(T.self)
            .subscribe { event -> Void in
                switch event {
                case .next(let parsedObject):
                    completion(parsedObject)
                    additionalSteps?()
                case .error(let error):
                    print(error)
                    completion(nil)
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func requestArray<T: Mappable>(_ token: MarvelAPI, type: T.Type,
                                  completion: @escaping ([T]?) -> Void,
                                  additionalSteps:  AdditionalStepsAction? = nil) {
        provider.request(token)
            .debug()
            .map { response -> Response in
                return response.removeAPIWrappers()
            }
            .mapArray(T.self)
            .subscribe { event -> Void in
                switch event {
                case .next(let parsedArray):
                    completion(parsedArray)
                    additionalSteps?()
                case .error(let error):
                    print(error)
                    completion(nil)
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
}




extension MarvelAPIManager {
    
    func characters(query: String? = nil, completion: @escaping ([Character]?) -> Void) {
        requestArray(.characters(query),
                     type: Character.self,
                     completion: completion)
    }
    
    
}
```


这里有很多事情要做，我创建了两个通用方法（一个用于数组，另一个用于对象）来抽象出如何与 api 交互并处理响应。之后，这些方法可以用来进行特定的 api 调用，比如：

```swift
func characters(query: String? = nil, completion: @escaping ([Character]?) -> Void) {        
    requestArray(.characters(query),
                 type: Character.self,                            completion: completion)    
}
```

**声明**：我知道我甚至没有使用 RxSwift 的 1%，我只是用它来解包 api 的响应（*这个api有两层包装对象，我并不关心，至少对于这个教程的目的*），将其解析为模型并处理成功和错误流。许多人认为，我应该返回一个 Observable 列表，以后可以与其他 api 调用相结合，进行过滤等等，而不是在 api 管理器中处理，并提供一个完成函数，他们这样做也是对的。

问题是，这里没有对与错，一切都是一种权衡，项目的需要不要求这样的执行，所以让我们保持简单。

现在我们可以调用 api，而不用担心任何实现细节，就这么简单:

```swift
let apiManager = MarvelAPIManager()
apiManager.characters(query: query) { characters in                   
}
```



这个解释并不打算成为一个完整的操作指南，它们更像是一个指南，一个例子。任何跟随者都必须克隆该[版本](https://github.com/thiagolioy/marvelapp) 并进行实验。



## External Datasources + Reusable ..
