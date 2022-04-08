[cocoapods-keys](https://github.com/orta/cocoapods-keys) 是一款 CocoaPods 插件，他将你要加密的信息储存在钥匙串中，而不是硬编码在代码里。


## 安装

```bash
$ gem install cocoapods-keys
```



## 它是如何工作的

key names 存储在 `~/.cocoapods/keys/` 中，key value 存储在 OS X 系统钥匙串中。当你运行 `pod install` 或 `pod update` 时，会使用加密版本的密钥创建一个 Objective-C 类，这使你很难通过 [dump](https://github.com/stefanesser/dumpdecrypted) 直接解密二进制内容并提取密钥。在运行时（runtime），密钥会被解密以便在你的应用程序中使用。

生成的 Objective-C 类存储在 `Pods/CocoaPodsKeys` 目录中，因此如果你要检出（check in） Pods 文件夹，只需将 `Pods/CocoaPodsKeys` 添加到你的 `.gitignore` 文件中。CocoaPods-Keys 支持在 Swift 或 Objective-C 项目中使用。



## 用法

使用 CocoaPods 中新的插件 API，我们可以将很多繁琐的部分自动化。你可以在你的 [Podfile](https://github.com/artsy/eidolon/blob/0a9f5947914eb637fd4abf364fa3532b56da3c52/Podfile#L6-L21) 中定义你想要的 key，Keys 会检测尚未设置的 key。如果你需要指定一个与 target 名称不同的 project 名称，请使用关键字 `:target` 来指定它。

```ruby
plugin 'cocoapods-keys', {
  :project => "Eidolon",
  :keys => [
    "ArtsyAPIClientSecret",
    "ArtsyAPIClientKey",
    "HockeyProductionSecret",
    "HockeyBetaSecret",
    "MixpanelProductionAPIClientKey",
    ...
  ]}
```

> 请不要在键名中使用破折号 ([原因见 Issue#197](https://github.com/orta/cocoapods-keys/issues/197))
> 
> 例如，将任何类似于 `WRONGLY-DEFINED-KEY` 的 key 转换为 `CorrectlyDefinedKey`。

然后运行 `pod install` 会提示尚未设置的 key，你可以确保每个人都有相同的设置。



## 其他用法

你可以通过运行以下命令在每个项目的基础上保存密钥：

```bash
$ bundle exec pod keys set KEY VALUE
```

运行以下命令列出所有已知的钥匙:

```bash
$ bundle exec pod keys
```


例如：

```bash
  $ cd MyApplication
  $ bundle exec pod keys set "NetworkAPIToken" "AH2ZMiraGQbyUd9GkNTNfWEdxlwXcmHciEOH"
  Saved NetworkAPIToken to MyApplication.

  $ bundle exec pod keys set "AnalyticsToken" "6TYKGVCn7sBSBFpwfSUCclzDoSBtEXw7"
  Saved AnalyticsToken to MyApplication.

  $ bundle exec pod keys
  Keys for MyApplication
   ├  NetworkAPIToken - AH2ZMiraGQbyUd9GkNTNfWEdxlwXcmHciEOH
   └  AnalyticsToken - 6TYKGVCn7sBSBFpwfSUCclzDoSBtEXw7

  GIFs - /Users/orta/dev/mac/GIFs
   └ redditAPIToken & mixpanelAPIToken
```


在下一次的 `pod install` 或 `pod update` 之后，Keys 将在你的 Pods 项目中添加一个新的`Keys` pod，支持 static libraries 和 frameworks。请注意，你必须在 Podfile 中添加 `plugin 'cocoapods-keys'`，以便 keys 注册后能够工作。这为你的 keys 提供了一个来自 Cocoa 代码的 API。例如，上面的应用代码看起来像：

```objc
#import "ORAppDelegate.h"
#import <Keys/MyApplicationKeys.h>
#import <ARAnalytics/ARAnalytics.h>

@implementation ORAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    MyApplicationKeys *keys = [[MyApplicationKeys alloc] init];
    [ARAnalytics setupWithAnalytics:@{
        ARGoogleAnalyticsID : keys.analyticsToken;
    }];
}

@end
```

一些文档也可用 [在 Swift 项目中使用 cocoapods-keys](https://github.com/orta/cocoapods-keys/blob/master/SWIFT_PROJECTS.md)



### 其他命令

Cocoapods-keys 有3个其他命令：

* `bundle exec pod keys get [key] [optional project]` 这将把键的值输出到 STDOUT，这对脚本编写很有用。
* `bundle exec pod keys rm [key] [optional project]` 将从项目中移除密钥。
* 如果包含通配符，它将删除与该模式相匹配的键。例如：`bundle exec pod keys rm "G*og*”` 将删除*所有*以'G'开头，中间有'og'，最后有任何东西的键。要删除所有的键，可以运行 `bundle exec pod keys rm “*"` 或者 `bundle exec pod keys rm —all`。
* `bundle exec pod keys generate [optional project]` 将生成混淆的 Objective-C  keys 类（主要用于内部）。



### 持续集成

在你的 CI 中乱用钥匙串很少是个好主意，所以钥匙串会在查找钥匙串之前寻找一个相同字符串的环境变量。你也可以在你的项目文件夹中创建一个 `.env` 文件。



### 维护状态

从 Artsy 的角度来看，CocoaPods Keys 是有效的 "已完成" 软件。它已经完成了我们多年来所需要的一切。所以，我不建议提出请求新功能的 issues，仅仅是因为我们不会自己实现它们。我们肯定会继续确保它正常工作，并且我们也在生产环境中使用它。



### 安全

密钥安全是困难的。现在，即使是最大的应用程序也会被[泄露](https://threatpost.com/twitter-oauth-api-keys-leaked-030713/77597/)其密钥。Twitter 安全团队的 John Adams 在 [Quora](https://www.quora.com/Twitter-product-1/How-were-the-Twitter-iPhone-and-Android-OAuth-key) 上对这一点做了精辟的总结。

> 把这个问题放在 "你是否应该在软件中存储密钥” 的话题下更为合适。许多公司都这样做。这绝不是一个好主意。

> 当开发者这样做时，其他开发者可以使用调试器和字符串搜索命令从正在运行的应用程序中提取这些密钥。有许多关于如何做到这一点的讲座，你可以自己去找找看。

> 许多人认为，在代码中混淆这些键会有所帮助。这通常是没有用的，因为你可以直接运行一个调试器，找到功能齐全的密钥。


所以总而言之，存储密钥的理想方法是不存储密钥。实际上，尽管大多数应用程序都嵌入了密钥，他们这样做并为密钥添加了一些基本的混淆。然而，意图明显的应用程序破解者可以在几分钟内将其提取出来。



## 参考

* [Introduction to Cocoapods-Keys.](https://medium.com/@eelia/introduction-to-cocoapods-keys-840493b98ef1)
