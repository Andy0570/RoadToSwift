> 原文：[AttributedString Tutorial for Swift: Getting Started](https://www.raywenderlich.com/29501177-attributedstring-tutorial-for-swift-getting-started)
>
> 在 SwiftUI 中构建 Markdown 预览器时，了解如何使用 iOS 15 的新 `AttributedString` 值类型格式化文本和创建自定义样式。

构建精美的应用程序不仅仅依赖于图像——它也延伸到了文本。不同样式的属性字符串可以大大提高内容的吸引力。在本教程中，您将了解 iOS 15 和 macOS 12 中新引入的 `AttributedString` 值类型。您还将了解如何利用其功能（包括使用 Markdown 进行格式化）在应用程序中处理更多文本。

本教程将涵盖：

* 新的 `AttributedString` 和从 Objective-C 桥接的旧 `NSAttributedString` 之间的差异。
* 使用 Markdown 格式化和设置属性字符串的样式。
* 属性字符串的结构以及如何更改它。
* 创建和呈现自定义属性。
* 编码和解码属性字符串及其自定义属性。

> 注意：本教程假设您熟悉 iOS 编程，其中通常包括使用字符串。如果您是新手，请考虑从 SwiftUI Apprentice 之类的书或您的第一个 iOS 和 SwiftUI 应用程序：从零开始的应用程序之类的视频课程开始。请随意尝试本教程并跳入论坛（链接如下）提问！

## 开始

通过单击教程顶部或底部的下载材料下载起始项目。
您将构建的应用程序 Markdown Preview 允许您键入基本文本字符串，然后将其转换为属性字符串。然后，它将这个属性字符串保存到您创建的库中。
首先在 starter 文件夹中打开 MarkdownPreview.xcodeproj。构建并运行应用程序以查看您的起点。

![](https://koenig-media.raywenderlich.com/uploads/2021/11/AttributedString_1-231x500.png)

屏幕的第一部分允许您选择一个主题。一组主题已包含在项目中，但还没有任何效果。

![](https://koenig-media.raywenderlich.com/uploads/2021/11/AttributedString_2-231x500.png)

您将把这个应用程序的工作分为五个部分：

1. 将 Markdown 字符串转换为属性字符串。
2. 将主题应用于文本而不永久更改其属性。
3. 创建可以成为 Markdown 一部分的自定义属性。
4. 创建一个可以呈现新的自定义属性的文本视图。
5. 将属性字符串保存到库中。

## AttributedString vs. NSAttributedString

在开始项目之前，有必要了解一些关于 `AttributedString` 与旧 `NSAttributedString` 的比较。具体来说，它：

* 是一等的 Swift 公民，并利用了 Swift 的特性，类似于 `String` 和 `NSString` 之间的区别。
* 是一个值类型，而旧的 `NSAttributedString` 是一个引用类型。
* 遵守 `Codable` 协议。您可以直接对 `AttributedString` 对象及其属性进行编码和解码，就像使用普通字符串一样。
* 具有与 `String` 相同的字符计数行为。
* 完全可本地化。您甚至可以直接在本地化文件中定义文本中的样式！
* 最重要的是，`AttributedString` 完全支持 Markdown 语法。

## 使用 Markdown

Markdown 是一种流行的用于格式化文本的标记语言。它可以格式化整个文档——而不仅仅是段落。您可能会惊讶地发现，在 raywenderlich.com 上发布的所有书籍都是完全用 Markdown 编写的。 :]

> 注意：您可以从 [Markdown 备忘录](https://www.markdownguide.org/cheat-sheet/)中了解有关 Markdown 语法的更多信息。



在 **Raw Markdown** 文本输入框中输入 Markdown 格式的字符串，并注意文本在 Rendered Markdown 区域中显示为原样。 Markdown 属性尚未转换为文本样式。

![](https://koenig-media.raywenderlich.com/uploads/2021/11/AttributedString_3-231x500.png)

在 Views 组中打开 MarkdownView.swift，然后转到 `convertMarkdown(_:)`。此方法处理将原始文本转换为 `AttributedString`。如果您使用标准初始化程序 `AttributedString(_:)`，则您的文本本身不会被视为 Markdown。将方法的实现更改为：

```swift
// 1
guard var attributedString = try? AttributedString(markdown: string) else {
  // 2
  return AttributedString(string)
}
// 3
printStringInfo(attributedString)
// 4
return attributedString
```

您添加的代码执行以下操作：

1. 尝试使用初始化器 `AttributedString(markdown:)` 将原始字符串转换为属性字符串。
2. 如果失败，则它使用默认初始化程序创建一个属性字符串，而不使用任何 Markdown 样式。
3. 打印有关属性字符串的一些信息。此方法当前为空。您将在下一节中实现它。
4. 返回在 Markdown 初始化程序中成功的属性字符串。

构建并运行。在 Raw Markdown 区域中输入您之前尝试过的相同 Markdown 字符串，然后查看它现在的显示方式：

![](https://koenig-media.raywenderlich.com/uploads/2021/12/AttributedString_4-231x500.png)



## 检查 AttributedString 的结构

`AttributedString` 对象由 characters 字符组成，您可以像计算普通字符串一样对它们进行计数。但它也由 `AttributedString.Runs` 组成。

**Runs** 是 `AttributedString` 的一部分，描述了文本中哪些字符适用的样式。每个 run 都包含一个子字符串范围和应用于它的样式。如果您的文本是纯文本并且没有样式，那么您的属性字符串将仅包含一个 run。如果您的 `AttributedString` 使用多种样式，那么它将被分解为许多 run。你很快就会更深入了解。

## 字符和索引

要更好地了解 characters 字符是什么，请返回 Views/MarkdownView.swift，然后转到 `printStringInfo(_:)`。实现如下：

```swift
// 1
print("The string has \(attributedString.characters.count) characters")
// 2
let characters = attributedString.characters
// 3
for char in characters {
  print(char)
}
```

这是上面代码中发生的事情：

1. 打印属性字符串中的字符数。
2. 创建一个包含 `AttributedString.CharacterView` 的变量，您将对其进行迭代以分别获取每个字符的值。
3. 遍历此集合并一一打印字符的值。



构建并运行。输入这个原始的 Markdown 字符串来尝试一下：

```markdown
This is **Bold text** and this is _italic_
```

您将在 Xcode 的控制台中看到 `printStringInfo(_:)` 的输出：

```
The string has 36 characters
```

原始字符串是 42 个字母。但是当被视为 Markdown 时，作为 Markdown 语法一部分的 `**` 和 `_` 字符不再是实际字符串的一部分。它们变成了属性或样式，而不是内容。

在日志中向上滚动一点，您会发现上一个日志中的字符数是 37。这发生在您输入最后一个 _ 之前，当时字符串是：

```swift
This is **Bold text** and this is _italic
```

您没有输入斜体语法的结束符 `_`，因此 `AttributedString` 尚未将此部分视为斜体。开头和结尾字符都必须存在，否则它们将被视为内容的一部分。

![](https://koenig-media.raywenderlich.com/uploads/2021/12/AttributedString_5-231x500.png)

请注意，不应用斜体样式，并且 `_` 是属性字符串中内容的一部分。



## Runs

查看您在上面输入的属性字符串，您可以这样描述它：

* `This is` 使用常规样式。
* `Bold text` 使用粗体样式。
* `and this is`使用常规样式。
* `italic` 使用正确的 Markdown 格式化，斜体将使用斜体样式。

这些部分按顺序描述了字符串及其属性。如果您尝试合并第一和第三部分，因为它们具有相同的样式，您最终会在定义应用常规样式的顺序时遇到一些复杂性。

这与运行以及它们如何描述属性字符串非常相似。

在 Views/MarkdownView.swift 中 `printStringInfo(_:)` 的末尾添加以下内容：

```swift
// 1
print("The string has \(attributedString.runs.count) runs")
// 2
let runs = attributedString.runs
// 3
for run in runs {
  // 4
  print(run)

  // 5
  if let textStyle = run.inlinePresentationIntent {

    // 6
    if textStyle.contains(.stronglyEmphasized) {
      print("Text is Bold")
    }
    if textStyle.contains(.emphasized) {
      print("Text is Italic")
    }
  // 7
  } else {
    print("Text is Regular")
  }
}
```

以下是代码中发生的事情：

1. 打印属性字符串中存在的运行次数。
2. 为运行集合创建一个变量。
3. 遍历集合。
4. 打印运行的描述。
5. 如果运行具有样式 `inlinePresentationIntent` 的值，则存储其值以供使用。该值是一个选项集。它可以保存一个或多个值，其中每个值都由一个位表示。
6. 如果存储的值有 `.stronglyEmphasized` 作为选项，则打印“Text is Bold”。或者，如果它有 `.emphasized`，则打印“Text is Italic”。
7. 如果没有值，这意味着文本没有这种样式，所以打印“Text is Regular”。

构建并运行。输入与之前相同的文本并检查日志：

```text
The string has 4 runs
This is  {
  NSPresentationIntent = [paragraph (id 1)]
}
Text is Regular
Bold text {
  NSPresentationIntent = [paragraph (id 1)]
  NSInlinePresentationIntent = NSInlinePresentationIntent(rawValue: 2)
}
Text is Bold
 and this is  {
  NSPresentationIntent = [paragraph (id 1)]
}
Text is Regular
italic {
  NSPresentationIntent = [paragraph (id 1)]
  NSInlinePresentationIntent = NSInlinePresentationIntent(rawValue: 1)
}
Text is Italic
```

运行次数为四，因为您之前已将其分解。通过检查每次运行的详细信息，您会发现它们也具有相同的结构：文本和可用样式及其值。

请注意，粗体样式的值为 `NSInlinePresentationIntent(rawValue: 2)`，斜体的值为 `NSInlinePresentationIntent(rawValue: 1)`。注意原始值。输入以下字符串作为原始 Markdown：

```markdown
This is **Bold text** and this is _italic_ and this is **_both_**
```

该字符串有六次运行。最后一个的 `NSInlinePresentationIntent` 样式值为 `NSInlinePresentationIntent(rawValue: 3)`。这意味着它是斜体和粗体。每个选项都由一个位表示。所以，2^0 + 2^1 = 3。它不必完全是粗体或斜体。



## 应用主题

从运行的详细信息中可以看出，您创建的属性字符串没有指定任何字体名称或大小。它只有粗体和斜体样式。
属性字符串可以定义字体名称、大小、颜色和许多其他属性。但在这个应用程序中，你会以不同的方式构建它。您希望有一组主题可供您选择以应用于字符串。想象一下，您正在为 Markdown 创建一个文本编辑器，并且您希望用户能够在打印文档之前选择主题或样式。这意味着主题不会改变用户输入的原始 Markdown，但所选主题将决定最终文档的外观。



### 定义主题样式

iOS 15 提供了一种将一组样式打包在一起的方法，以便您可以在属性字符串上批量应用它们。通过使用 `AttributeContainer` 来执行此操作。

转到 Models 组中的 TextTheme.swift 并在枚举中添加此计算属性：

```swift
var attributeContainer: AttributeContainer {
  var container = AttributeContainer()
  switch self {
  case .menlo:
    container.font = .custom("Menlo", size: 17, relativeTo: .body)
    container.foregroundColor = .indigo
  case .times:
    container.font = .custom("Times New Roman", size: 17, relativeTo: .body)
    container.foregroundColor = UIColor.blue
  case .important:
    container.font = .custom("Courier New", size: 17, relativeTo: .body)
    container.backgroundColor = .yellow
  default:
    break
  }
  return container
}
```

这会根据当前枚举值创建一个具有不同属性的容器。每个都有不同的字体和前景色或背景色。

接下来，转到 Views/MarkdownView.swift 并在 `convertMarkdown(_:)` 中，在调用 `printStringInfo(_:)` 之前，添加以下内容：

```swift
attributedString.mergeAttributes(selectedTheme.attributeContainer)
```

这告诉您从 Markdown 创建的属性字符串将其属性与主题属性容器中的属性合并。
构建并运行。更改主题几次，看看结果如何从一个主题变为另一个主题。

![](https://koenig-media.raywenderlich.com/uploads/2021/12/AttributedString_6-231x500.png)



## 创建自定义属性

到目前为止，您已经了解了很多关于 Swift 的新 `AttributedString` 以及如何使用它来做不同事情的知识。但是您可能有几个问题，例如：

* 如何定义新属性？
* 如何结合现有样式在文本上创建新效果？
* 新属性的 Markdown 应该是什么样的？
* 属性字符串将如何识别新属性以及它将如何呈现？

这些都是很好的问题。首先要介绍的是 Markdown 允许直接添加属性，如下所示：

```swift
Some regular text then ^[text with an attribute](theAttributeKey: 'theValue')

Some regular text then ^[text with two attributes]
  (theAttributeKey: 'theValue', otherAttributeKey: 'theOtherValue')
```

在上面的 Markdown 示例中，您有两个自定义属性：`theAttributeKey` 和 `otherAttributeKey`。这是有效的 Markdown 语法，但要让 `AttributedString` 理解这些属性，您需要定义一个属性范围（Attribute Scopes）。

### Attribute Scopes

属性范围有助于从 Markdown 或编码的属性字符串中解码属性。已经为 Foundation、UIKit、AppKit 和 SwiftUI 定义了范围。

解码属性时，仅使用一个作用域。后三者包括 Foundation 的范围。
如果你在想：“说够了——告诉我这一切是如何运作的！”，这是完全可以理解的。 :]
在 Models 组中创建一个名为 AttributeScopes.swift 的新 Swift 文件并添加以下内容：

```swift
import SwiftUI

public enum CustomStyleAttributes {
  public enum Value: String, Codable {
    case boldcaps, smallitalics
  }

  public static var name = "customStyle"
}

public enum CustomColorAttributes {
  public enum Value: String, Codable {
    case danger, highlight
  }

  public static var name = "customColor"
}
```

这些枚举是您将创建的两个自定义属性。它们中的每一个都有一个子类型枚举，其中包含允许的值和将出现在 Markdown 中的键名的字符串表示：

* `CustomStyleAttributes` 修改文本以使其粗体和大写或斜体和小写。
* `CustomColorAttributes` 影响颜色：
  * `danger` 为文本添加红色背景和黄色虚线下划线。
  * `highlight` 为文本添加黄色背景和红色虚线下划线。

在同一文件中添加以下内容：

```swift
// 1
public extension AttributeScopes {
  // 2
  struct CustomAttributes: AttributeScope {
    let customStyle: CustomStyleAttributes
    let customColor: CustomColorAttributes
    // 3
    let swiftUI: SwiftUIAttributes
  }
  // 4
  var customAttributes: CustomAttributes.Type { CustomAttributes.self }
}

// 5
public extension AttributeDynamicLookup {
  subscript<T: AttributedStringKey>(
    dynamicMember keyPath: KeyPath<AttributeScopes.CustomAttributes, T>
  ) -> T {
    self[T.self]
  }
}
```

`AttributedString` 可以通过以下方式理解 Markdown 中的自定义键：

1. 创建现有 `AttributeScopes` 类型的扩展。
2. 创建一个新的子类型来保存您希望使用的所有自定义属性。
3. 指定将引用现有属性的属性。由于这个应用程序在 SwiftUI 中，因此它是 `SwiftUIAttributes`。或者，您可以使用 `FoundationAttributes`、`UIKitAttributes` 或 `AppKitAttributes`。否则，现有属性将不会被编码和解码。
4. 指定引用类型本身的属性。
5. 在 `AttributeDynamicLookup` 上指定一个扩展，并覆盖下标（`dynamicMember:`)。这有助于您将 `CustomAttributes` 直接称为 `KeyPath`。

在您尝试之前，您创建的第一个枚举必须符合 `CodableAttributedStringKey`，因为您将在属性字符串和 `MarkdownDecodableAttributedStringKey` 中将它们用作 `Codable` 属性，因为您将在 Markdown 中使用它们。将枚举的声明更改为：

```swift
public enum CustomStyleAttributes: CodableAttributedStringKey, 
  MarkdownDecodableAttributedStringKey {
```

```swift
public enum CustomColorAttributes: CodableAttributedStringKey, 
  MarkdownDecodableAttributedStringKey {
```

最后，在 Views/MarkdownView.swift 中，更改从 Markdown 初始化属性字符串的方式：

```swift
guard var attributedString = try? AttributedString(
  markdown: string,
  including: AttributeScopes.CustomAttributes.self,
  options: AttributedString.MarkdownParsingOptions(
    allowsExtendedAttributes: true)) else {
    return AttributedString(string)
  }
```

构建并运行。输入以下 Markdown 以测试您的更改：

```swift
^[BoldCaps and Danger](customStyle: 'boldcaps', customColor: 'danger'), 
^[SmallItalics and Highlighted](customStyle: 'smallitalics', 
customColor: 'highlight')
```

>  注意：如果您复制并粘贴上面的 Markdown，请确保删除换行符。

![](https://koenig-media.raywenderlich.com/uploads/2021/12/AttributedString_7-231x500.png)

属性字符串看起来像没有任何样式的普通字符串。但是检查日志，您会看到以下内容：

```text
BoldCaps and Danger {
	customColor = danger
	customStyle = boldcaps
	NSPresentationIntent = [paragraph (id 1)]
}
.
.
SmallItalics and Highlighted {
	customStyle = smallitalics
	customColor = highlight
	NSPresentationIntent = [paragraph (id 1)]
}
```

属性字符串具有正确的自定义属性，因此它们被正确解码。少了什么东西？

此时，UI 不知道如何处理这些属性。来自属性字符串的信息被正确存储，但 SwiftUI.Text 完全不知道，它正在呈现属性字符串。

### 渲染自定义属性

要正确呈现您的自定义属性，您需要创建自己的视图来使用它们。您可能认为您需要自己绘制文本并处理屏幕上的低级渲染操作。您无需担心任何这些！这个类比你想象的要简单得多。您需要做的就是将自定义属性转换为标准 Text 视图可以理解的普通属性，然后正常使用 Text 视图。

在 Subviews 组中创建一个新的 SwiftUI 视图，并将其命名为 CustomText.swift。将文件的内容替换为以下内容：

```swift
import SwiftUI

public struct CustomText: View {
  // 1
  private var attributedString: AttributedString

  // 2
  private var font: Font = .system(.body)

  // 3
  public var body: some View {
    Text(attributedString)
  }

  // 4
  public init(_ attributedString: AttributedString) {
    self.attributedString = 
      CustomText.annotateCustomAttributes(from: attributedString)
  }

  // 5
  public init(_ localizedKey: String.LocalizationValue) {
    attributedString = CustomText.annotateCustomAttributes(
      from: AttributedString(localized: localizedKey, 
        including: \.customAttributes))
  }

  // 6
  public func font(_ font: Font) -> CustomText {
    var selfText = self
    selfText.font = font
    return selfText
  }

  // 7
  private static func annotateCustomAttributes(from source: AttributedString) 
    -> AttributedString {
    var attrString = source

    return attrString
  }
}
```

浏览这个新视图的细节——在这里，你：

1. 存储将出现的属性字符串。
2. 存储字体并使用 Font.system(body) 设置默认值。
3. 确保视图的主体具有标准的 SwiftUI.Text 来呈现存储的属性字符串。
4. 设置一个类似于 SwiftUI.Text 的初始化程序以将属性字符串作为参数。然后，使用此字符串调用私有 annotateCustomAttributes(from:)。
5. 给一个类似的初始化器一个本地化键，然后从本地化文件创建一个属性字符串。
6. 添加一个方法来创建并返回带有修改字体的视图副本。
7. 在这种方法中不做任何有意义的事情——至少现在是这样。这才是真正的工作所在。目前，它所做的只是将参数复
8. 制到变量中并返回。你很快就会实现它。

接下来，在 Views/MarkdownView.swift 中，将显示转换后的 Markdown 的视图类型从 `Text` 更改为 `CustomText`。 HStack 的内容应该是：

```swift
CustomText(convertMarkdown(markdownString))
  .multilineTextAlignment(.leading)
  .lineLimit(nil)
  .padding(.top, 4.0)
Spacer()
```

构建并运行。确保你没有破坏任何东西。没有什么应该看起来与以前不同。

返回 Subviews/CustomText.swift 并在 annotateCustomAttributes(from:) 中的 return 之前添加以下内容：

```swift
// 1
for run in attrString.runs {
  // 2
  guard run.customColor != nil || run.customStyle != nil else {
    continue
  }
  // 3
  let range = run.range
  // 4
  if let value = run.customStyle {
    // 5
    if value == .boldcaps {
      let uppercased = attrString[range].characters.map {
        $0.uppercased() 
      }.joined()
      attrString.characters.replaceSubrange(range, with: uppercased)
      attrString[range].inlinePresentationIntent = .stronglyEmphasized
    // 6
    } else if value == .smallitalics {
      let lowercased = attrString[range].characters.map {
        $0.lowercased() 
      }.joined()
      attrString.characters.replaceSubrange(range, with: lowercased)
      attrString[range].inlinePresentationIntent = .emphasized
    }
  }
  // 7
  if let value = run.customColor {
    // 8
    if value == .danger {
      attrString[range].backgroundColor = .red
      attrString[range].underlineStyle =
        Text.LineStyle(pattern: .dash, color: .yellow)
    // 9
    } else if value == .highlight {
      attrString[range].backgroundColor = .yellow
      attrString[range].underlineStyle =
        Text.LineStyle(pattern: .dot, color: .red)
    }
  }
}
```

这可能看起来像一个很长的代码块，但实际上非常简单。这是它的作用：

1. 在属性字符串中的可用运行上循环。
2. 跳过对 customColor 和 customStyle 没有任何价值的任何运行。
3. 存储运行范围以备后用。
4. 检查运行是否具有 customStyle 的值。
5. 如果该值是粗体大写字母，则从运行范围内的字符创建一个字符串并将它们转换为大写。将运行范围内的属性字符串中的文本替换为新的大写字符，然后应用粗体样式 strongEmphasized。
6. 否则，如果值为 smallitalics，则执行与上述相同的操作，不同之处在于使用强调斜体样式的小写字符。
7. 如果 customColor 有值，则不使用 else 进行检查。
8. 如果值为危险，则将背景颜色设置为红色，将下划线样式设置为黄色虚线。
9. 否则，如果值为高亮，则将黄色背景和下划线样式设置为红色虚线。

构建并运行。尝试与上一个示例相同的 Markdown。

![](https://koenig-media.raywenderlich.com/uploads/2021/12/AttributedString_8-231x500.png)

现在您的自定义属性是可见的。尝试选择不同的主题。正如预期的那样，您的主题改变了文本的样式。切换主题也有效。
您的属性字符串在出现时不会更改。您的自定义视图会复制它，因此它可以安全地更改，与原始视图分开。



## 保存样式字符串

应用程序的最后一部分是构建字符串库。该应用程序应显示所有已保存属性字符串的列表，并使用 Markdown 预览器添加新字符串。

首先，将应用的导航流程更改为先打开列表而不是预览器。从本教程的材料中打开资产，然后将 SavedStringsView.swift 拖到 Views 组中。如果需要，请务必检查复制项目。





