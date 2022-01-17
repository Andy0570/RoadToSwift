> 系列原文：
> [Getting Started With Accessibility: VoiceOver](https://www.basbroek.nl/getting-started-voiceover)
> [Improving Accessibility: VoiceOver](https://www.basbroek.nl/improving-voiceover)
> [Verifying VoiceOver: Accessibility Inspector](https://www.basbroek.nl/verifying-voiceover)
> [Improving Accessibility: Voice Control](https://www.basbroek.nl/improving-voice-control)
> [Getting Started With Accessibility: Dynamic Type](https://www.basbroek.nl/getting-started-dynamic-type?utm_source=swiftlee&utm_medium=swiftlee_weekly&utm_campaign=issue_96)



动态字体可以让你在你的应用程序中支持不同的字体大小，这样用户就可以使用最适合他们的字体大小--从比系统默认值小的字体，到一大堆大字体。

......系统中还内置了一些智能设置，以支持那些空间有限而无法显示较大字体的情况。



## 介绍

Apple 的《Human Interface Guidelines》中的 [Typography 文档](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/#dynamic-type-sizes) 让你对整个排版的思维过程有一个很好的了解，特别是动态字体，另一页给出了更多关于如何处理文本的无障碍具体信息。

关于动态类型的好消息是，它几乎是开箱即用的。坏消息是 "几乎"。

为了确保你的元素支持动态类型，验证你的元素的 `adjustsFontForContentSizeCategory` 属性是否设置为 `true`：

```swift
let label = UILabel()
label.font = .preferredFont(forTextStyle: .body)
label.numberOfLines = 0
label.adjustsFontForContentSizeCategory = true
```

请注意：

* 我们使用提供系统字体的 `preferredFont(forTextStyle:)` API。如果你使用自定义字体，你必须确保你使用 `UIFontMetrics` 正确支持动态字体。
* 我们将标签的 `numberOfLines` 属性设置为 `0`。虽然这不是一个严格的要求，但你可以想象一下，如果使用较大的字体，可能会使用更多的行数来正确布局你的文本。
* 当首选内容尺寸（preferred content size）发生变化时，元素会自动调整其内容尺寸。

## 测试和改进

对你的元素进行这样的设置后，你就可以用不同的动态文本大小来审视应用程序的整体情况；可以通过改变全系统的文本大小（设置 > 辅助功能 > 显示和文本大小 > 更大的文本大小），或者以每个应用程序为基础（在iOS 15中）。设置">"辅助功能">"每个应用程序设置">"添加应用程序">"更大的文本"。
你可能会注意到你的应用程序中的某些地方，由于使用了更小（或更大）的字体，某些布局要么中断，要么变得有点尴尬。

虽然让所有的布局保持最佳状态而不管用户的文字大小是很有挑战性的，但有一个有用的 API 是 `isAccessibilityCategory`，它允许你查询是否正在使用可访问的文字大小。有了这些信息，你可以考虑将你的布局从水平方向切换到垂直方向，给你更多的空间来优雅地处理更大的文字尺寸。



## 大型的内容查看器（Large Content Viewer）

不幸的是，某些元素是以这样一种方式构建的，即它们不希望超过一定的尺寸。例如，tab bar items、segmented controls 和像 overlays 这样的东西。

为了解决这个问题，苹果在 iOS 11 中引入了 Large Content Viewer，我想是在 iOS 11 中。在 iOS 13 中，也引入了一个API，使我们能够为自定义控件采用大型内容查看器。大内容查看器是根据动态类型设置显示的：当使用可访问的文本大小时，不能增长大小的元素有望显示出来；之前提到的标签栏项目和分段控件开箱即用。

请注意，在撰写本文时，遗憾的是 SwiftUI 不支持 Large Content Viewer；你必须使用 UIKit 为自定义控件实现它。



## 总结

支持动态类型似乎只需要很少的改动，然而在现实中，大多数应用程序不会像这样为它带来很好的体验。

幸运的是，有一些 API 可以让我们根据文字大小来定制我们的布局，让我们可以改善这种体验，以适应较小和较大的文字大小。

让我知道你对这篇文章的想法，如果你有任何问题，我很愿意帮助你。











