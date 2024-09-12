> 原文：[Core Text Tutorial for iOS: Making a Magazine App](https://www.kodeco.com/578-core-text-tutorial-for-ios-making-a-magazine-app)

**Core Text 是一个低层级（low-level）的文本引擎，当与 Core Graphics/Quartz 框架一起使用时，可以让你对布局和格式进行更细粒度的控制。**

在 iOS 7 中，Apple 发布了一个名为 **Text Kit** 的高层级（high-level）的框架，它可以存储、布局和显示具有各种排版特征的文本。尽管 Text Kit 功能强大并且通常在布局文本时足够使用了，但 Core Text 可以提供更多控制。比如，**如果你需要直接使用 Quartz，请使用 Core Text。如果你需要构建自己的布局引擎，Core Text 将帮助你生成“字形并利用精细排版的所有功能将它们相对定位”**。

本教程将带你完成使用 Core Text…for Zombies 创建一个非常简单的杂志应用程序的过程！

哦，《僵尸月刊》的读者已经好心同意，只要你忙于在本教程中使用它们，就不会吃掉你的大脑……所以你可能想尽快开始！ 

注意：要充分利用本教程，你需要首先了解 iOS 开发的基础知识。如果你是 iOS 开发新手，你应该首先查看此网站上的[其他教程](https://www.kodeco.com/ios)。

## 开始

打开 Xcode，使用 **Single View Application Template** 模板创建一个新的 Swift 项目，并将其命名为 **CoreTextMagazine**。

接下来，将 Core Text 框架添加到你的项目中：

1. 单击项目导航栏中的项目文件（左侧的条带）
2. 在“General”下，向下滚动到底部的“Frameworks, Libraies, and Embedded Content”
3. 单击“+”并搜索“CoreText”
4. 选择“CoreText.framework”并单击“Add”按钮。就是这样！

现在项目已经设置完毕，是时候开始编写代码了。

## 添加 Core Text 视图

作为初学者，你将创建一个自定义 `UIView`，它将在其 `draw(_:)` 方法中使用 Core Text。

创建一个名为 `CTView` 的新 Cocoa Touch 类文件，该文件是 `UIView` 的子类。

打开 `CTView.swift`，并在 `import UIKit` 下添加以下内容：

```swift
import CoreText
```

接下来，将此新的自定义视图设置为应用程序中的主视图。打开 **Main.storyboard**，打开右侧的 **Utilities** 菜单，然后选择顶部工具栏中的 **Identity Inspector** 图标。在 Interface Builder 的左侧菜单中，选中 **View** 视图。 **Utilities** 菜单的 **Class** 字段现在应该显示 **UIView**。要对主视图控制器的视图进行子类化，请在 **Class** 字段中输入 **CTView** 并按下键盘的 Enter 键。

![](https://koenig-media.raywenderlich.com/uploads/2017/06/Screen-Shot-2017-06-07-at-12.43.13-PM.png)

接下来，打开 `CTView.swift` 文件，并将注释掉的 `draw (_:)` 替换为以下内容：

```swift
// 1.当视图创建后，draw(_:) 会自动运行以渲染视图的底层。
override func draw(_ rect: CGRect) {
    // 2.解包将要用于绘制的当前图形上下文。
    guard let context = UIGraphicsGetCurrentContext() else { return }

    // 3.创建一条用于限制绘图区域的路径，在这里是整个视图的边界（bounds）。
    let path = CGMutablePath()
    path.addRect(bounds)

    // 4.在 Core Text 中，使用 NSAttributedString（而不是 String 或 NSString）来保存 text 及其属性。
    let attrString = NSAttributedString(string: "Hello World")
    // 5.CTFramesetterCreateWithAttributedString 使用 NSAttributedString 来创建 CFAttributedString，
    // CTFramesetter 将管理你引用的字体和画框（drawing frames）
    let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)

    // 6.通过让 CTFramesetterCreateFrame 渲染 path 中的整个字符串来创建 CTFrame。
    let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)

    // 7.CTFrameDraw 在给定上下文中绘制 CTFrame。
    CTFrameDraw(frame, context)
}
```

这就是绘制一些简单文本所需的全部！构建、运行并查看结果。

![](https://koenig-media.raywenderlich.com/uploads/2017/06/Screen-Shot-2017-06-07-at-12.47.10-PM-157x320.png)

啊哦…… 这似乎不对，是吗？**与许多底层 API 一样，Core Text 使用 Y 轴翻转坐标系**。更糟糕的是，内容也跟着垂直翻转了！

直接在 `guard let context` 语句下面添加以下代码来修复内容方向：

```swift
// Flip the coordinate system
context.textMatrix = .identity
context.translateBy(x: 0, y: bounds.size.height)
context.scaleBy(x: 1.0, y: -1.0)
```

此代码通过对视图上下文应用转换来翻转内容。

构建并运行应用程序。不用担心状态栏重叠，稍后你将学习如何使用 `margin` 来解决此问题。

![](https://koenig-media.raywenderlich.com/uploads/2017/06/Screen-Shot-2017-06-07-at-12.49.19-PM-157x320.png)

恭喜你开发出第一个 Core Text 应用程序！僵尸们对你的进步很满意。

## 理论知识：Core Text 对象模型

如果你对 `CTFramesetter` 和 `CTFrame` 有点困惑 – 没关系，因为现在是时候进行一些澄清了。 :]

Core Text 对象模型如下所示：

![](https://koenig-media.raywenderlich.com/uploads/2011/06/CTClasses-500x340.jpg)

当你创建 `CTFramesetter` 引用类型并为其提供 `NSAttributedString` 时，会自动创建 `CTTypesetter` 实例以供你管理字体。接下来，你将使用 `CTFramesetter` 创建一个或多个将在其中渲染文本的帧（frames）。

当创建 frame 时，你可以为其提供要在其矩形内渲染文本的子范围。 Core Text 自动为每行文本创建一个 `CTLine`，并为每段具有相同格式的文本创建一个 `CTRun`。例如，如果一行中有多个红色单词，Core Text 将创建一个 `CTRun`，然后为接下来的纯文本单词创建另一个 `CTRun`，然后为粗体单词创建另一个 `CTRun`...。Core Text 会根据以下属性为你创建 `CTRun`：即你提供的 `NSAttributedString`。此外，每个 `CTRun` 对象都可以采用不同的属性，因此，你可以对字距、连字、宽度、高度等进行精细控制。

## 进入杂志应用程序！

下载并解压[僵尸杂志资源](http://www.raywenderlich.com/downloads/zombieMagMaterials.zip)。

将文件夹拖到你的 Xcode 项目中。出现提示时，请确保选中 **Copy items if needed**（根据需要复制项目/资源） 和 **Create groups**。

要创建应用程序，你需要将各种属性应用于文本。你将创建一个简单的文本标记解析器（markup parser ），它将使用标签（tag）来设置杂志的格式。

创建一个名为 `MarkupParser` 的新 Cocoa Touch 类文件，它是 `NSObject` 的子类。

首先，快速浏览一下 `zombies.txt` 文件。看看它如何在整个文本中包含括号内的格式标记？ `img src` 标签引用杂志的图像，`font color/face` 标签描述文本颜色和字体。

打开 `MarkupParser.swift` 文件，并将其内容替换为以下内容：

```swift
import UIKit
import CoreText

class MarkupParser: NSObject {

    // MARK: - Properties
    var color: UIColor = .black
    var fontName: String = "Arial"
    var attrString: NSMutableAttributedString!
    var images: [[String: Any]] = []

    // MARK: - Initializers
    override init() {
        super.init()
    }

    // MARK: - Internal
    func parseMarkup(_ markup: String) {
      
    }
}
```

在这里，你添加了用于保存字体（`fontName`）和文本颜色（`color`）的属性，并设置了它们的默认值；创建了一个变量来保存由 `parseMarkup(_:)` 生成的 Attributed String；最后创建了一个数组，该数组最终将保存文本中图像的大小、位置和文件名的字典信息。

编写解析器通常是一项艰难的工作，但本教程的解析器将非常简单，并且仅支持打开标签 - 这意味着标签将设置其后面的文本的样式，直到找到新标签。文本标记将如下所示：

```html
These are <font color="red">red<font color="black"> and
<font color="blue">blue <font color="black">words.
```

并产生如下输出：

```text
These are red and blue words.
```

让我们开始解析吧！

将以下内容添加到 `parseMarkup(_:)` 中：

```swift
// 1.attrString 最初是空的，但最终将包含解析后的文本。
attrString = NSMutableAttributedString(string: "")

do {
    // 2.该正则表达式将文本块与紧跟其后的标签进行匹配。
    let regex = try NSRegularExpression(pattern: "(.*?)(<[^>]+>|\\Z)",
                                        options: [.caseInsensitive, .dotMatchesLineSeparators])
    // 3.在整个标记范围内搜索正则表达式匹配项，然后生成包含 NSTextCheckingResult 类型的数组。
    let chunks = regex.matches(in: markup, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: markup.count))
  
} catch _ {
}
```

1. `attrString` 最初是空的，但最终将包含解析后的文本（也就是**将 HTML 字符串转换为 Swift 支持的 Attributed String 字符串**）。
2. 该正则表达式将文本块与紧跟其后的标签进行匹配。它说：“浏览字符串，直到找到左括号，然后浏览字符串，直到找到右括号（或文档末尾）。”
3. 在整个标记范围内搜索正则表达式匹配项，然后生成包含 `NSTextCheckingResult` 类型的数组。

Tips：要了解有关正则表达式的更多信息，请查看 NSRegularExpression 教程。

现在你已将所有文本和格式化标记解析为 `chunks`，你将循环遍历 `chunks` 以构建属性字符串。

但在此之前，你是否注意到 `matches(in:options:range:)` 如何接受 `NSRange` 作为参数？当你将 `NSRegularExpression` 函数应用于你的标记字符串时，将会有大量的 `NSRange` 到 `Range` 的转换。 Swift 一直是我们所有人的好朋友，所以它值得伸出援助之手。

仍然在 `MarkupParser.swift` 中，将以下扩展添加到文件末尾：

```swift
// MARK: - String
extension String {
    // 将 NSRange 转化为 Range
    func range(from range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex),
              let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex),
              let from = String.Index(from16, within: self),
              let to = String.Index(to16, within: self) else {
            return nil
        }

        return from ..< to
    }
}
```

该函数将 `NSRange` 表示的字符串的起始和结束索引转换为 `String.UTF16View.Index` 格式，即字符串的 UTF-16 代码单元集合中的位置；然后将每个 `String.UTF16View.Index` 转换为 `String.Index` 格式；当组合起来后，会产生 Swift 的范围格式：`Range`。只要索引有效，该方法就会返回原始 `NSRange` 的 `Range` 表示形式。

现在 Swift 可以歇一会了。是时候回去处理文本和标签块了。

![](https://koenig-media.raywenderlich.com/uploads/2017/06/zombie-thumbsup.png)

在 `parseMarkup(_:)` 内部添加以下 `let` 块（在 `do` 块内）：

```swift
let defaultFont: UIFont = .systemFont(ofSize: UIScreen.main.bounds.size.height / 40)
// 1.循环遍历 chunks
for chunk in chunks {
    // 2.获取当前 NSTextCheckingResult 的范围，解包可选类型 Range<String.Index> 
    // 并继续处理该 chunk（只要它存在）。 
    guard let markupRange = markup.range(from: chunk.range) else { continue }
    // 3.将 chunk 分成由 "<" 分隔的部分，第一部分包含文本，第二部分包含标签（如果存在）
    let parts = markup[markupRange].components(separatedBy: "<")
    // 4.使用 fontName 创建字体，当前默认为 "Arial"，且相对屏幕尺寸大小
    let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height / 40) ?? defaultFont
    // 5.创建用于保存字体格式的字典，将其应用于 parts[0] 以创建属性字符串，然后将该字符串附加到结果字符串。
    let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        as [NSAttributedString.Key : Any]
    let text = NSMutableAttributedString(string: parts[0], attributes: attrs)
    attrString.append(text)
}
```

要处理 “font” 标签，请在 `attrString.append (text)` 之后插入以下内容：

```swift
// 1.如果 parts 数量少于 2，则跳过本次循环的剩余部分，否则，将第二部分存储为 tag
if parts.count <= 1 { continue }
let tag = parts[1]
// 2.如果 tag 以 “font” 开头，则创建一个正则表达式来查找字体的 “color” 值，
// 然后使用该正则表达式枚举标签所匹配的 “color” 值，在这里，应该只有一个匹配的颜色值
if tag.hasPrefix("font") {
    let colorRegex = try NSRegularExpression(pattern: "(?<=color=\")\\w+",
                                          options: NSRegularExpression.Options(rawValue: 0))
    colorRegex.enumerateMatches(in: tag,
        options: NSRegularExpression.MatchingOptions(rawValue: 0),
        range: NSMakeRange(0, tag.count)) { (match, _, _) in
        
        // 3.如果 enumerateMatches(in:options:range:using:) 返回的有效 match 与 tag 的有效范围匹配
        // 则找到该指定值（比如 <font color="red"> 返回 “red”），并附加 "Color" 以创建 UIColor 选择子。
        // 执行该选择子，然后将类的颜色设置为返回的颜色（如果存在），如果不存在则将其设置为默认值黑色。
        if let match = match, 
            let range = tag.range(from: match.range) {
            let colorSel = NSSelectorFromString(tag[range] + "Color")
            color = UIColor.perform(colorSel).takeRetainedValue() as? UIColor ?? .black
        }
    }

    // 4.同样，创建一个正则表达式来处理字体的 “face” 值。如果找到匹配项，请将 fontName 设置为该字符串。
    let faceRegex = try NSRegularExpression(pattern: "(?<=face=\")[^\"]+",
                                         options: NSRegularExpression.Options(rawValue: 0))
    faceRegex.enumerateMatches(in: tag,
        options: NSRegularExpression.MatchingOptions(rawValue: 0),
        range: NSMakeRange(0, tag.count)) { (match, _, _) in

        if let match = match,
           let range = tag.range(from: match.range) {
            fontName = String(tag[range])
        }
    }
} //end of font parsing
```

做得好！现在 `parseMarkup(_:)` 可以获取标记并为 Core Text 生成 `NSAttributedString`。

是时候将你的应用程序喂给一些僵尸了！我的意思是，向你的应用程序提供一些僵尸...zombies.txt，就是这样。 ;]

实际上 `UIView` 的工作是显示给它的内容，而不是加载内容。打开 `CTView.swift` 并在上面添加以下内容：`draw(_:)`：

```swift
// MARK: - Properties
var attrString: NSAttributedString!

// MARK: - Internal
func importAttrString(_ attrString: NSAttributedString) {
    self.attrString = attrString
}
```

接下来，从 `draw(_:)` 中删除 `let attrString = NSAttributedString (string: "Hello World")`。

在这里，你创建了一个实例变量来保存属性字符串，并创建了一个在应用程序的其他位置设置它的方法。

接下来，打开 `ViewController.swift` 并将以下内容添加到 `viewDidLoad()` 中：

```swift
// 1.将 zombie.txt 文件中的文本加载到 String 中
guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }

do {
    let text = try String(contentsOfFile: file, encoding: .utf8)
    // 2.创建一个新的解析器，输入文本，然后将返回的属性字符串传递给 ViewController 的 CTView。
    let parser = MarkupParser()
    parser.parseMarkup(text)
    (view as? CTView)?.importAttrString(parser.attrString)
} catch _ {
}
```

构建并运行应用程序！

![](https://koenig-media.raywenderlich.com/uploads/2017/06/Screen-Shot-2017-06-07-at-12.58.34-PM-157x320.png)

棒极了？只需要大约 50 行解析代码，你就可以简单地使用文本文件来保存杂志应用程序的内容。

## 基本的杂志布局

如果你认为一本关于僵尸新闻的月刊可能只占一小页，那你就大错特错了！幸运的是，Core Text 在布局列时变得特别有用，因为 `CTFrameGetVisibleStringRange` 可以告诉你一个给定的 `frame` 适合多少文本。意思是，你可以先创建一个列（column），然后一旦满了，你可以创建另一个列...

对于这个应用程序，你必须打印列（column），然后是页面（page），然后是整本杂志，以免冒犯不死族，所以...是时候将你的 `CTView` 转换为 `UIScrollView` 的子类了。

打开 `CTView.swift` 并将类 `CTView` 更改为：

```swift
class CTView: UIScrollView {
```

看到了吗，僵尸？该应用程序现在可以支持永恒的不死冒险！是的——现在只需一行代码即可实现滚动和分页。

![](https://koenig-media.raywenderlich.com/uploads/2017/06/zombie-happy.png)

到目前为止，你已经在 `draw(_:)` 中创建了 `framesetter` 和 `frame`，但由于你将拥有许多具有不同格式的列，因此最好创建单独的列实例。

创建一个名为 `CTColumnView` 的新 Cocoa Touch 类文件，该文件是 `UIView` 的子类。

打开 `CTColumnView.swift` 并添加以下初始代码：

```swift
import UIKit
import CoreText

class CTColumnView: UIView {

    // MARK: - Properties
    var ctFrame: CTFrame!
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init(frame: CGRect, ctFrame: CTFrame) {
        super.init(frame: frame)
        self.ctFrame = ctFrame
        backgroundColor = .white
    }

    // MARK: - Life Cycle
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Flip the coordinate system
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        CTFrameDraw(ctFrame, context)
    }
}
```

此代码呈现 `CTFrame`，就像你最初在 `CTView` 中所做的那样。指定初始化方法 `init(frame:ctframe:)` 设置：

1. 视图的 `frame` 值；
2. 要绘制到上下文中的 `CTFrame`；
3. 并且视图的背景颜色为白色；

接下来，创建一个名为 `CTSettings.swift` 的新 swift 文件，该文件将保存你的列设置。

将 `CTSettings.swift` 的内容替换为以下内容：

```swift
import UIKit

class CTSettings {
    // MARK: - Properties
    let margin: CGFloat = 20 // 页边距
    let columnsPerPage: CGFloat! // 每页的栏数
    var pageRect: CGRect! // page 大小
    var columnRect: CGRect! // 每页每列的大小

    // MARK: - Initializers
    init() {
        // 在 iPad 上显示两栏，在 iPhone 上显示一栏
        columnsPerPage = UIDevice.current.userInterfaceIdiom == .phone ? 1: 2
        // 通过插入页边距来计算 page 大小
        pageRect = UIScreen.main.bounds.insetBy(dx: margin, dy: margin)
        // 每页每列的宽度 = page 的宽度 / 每页的栏数
        columnRect = CGRect(x: 0,
                            y: 0,
                            width: pageRect.width / columnsPerPage,
                            height: pageRect.height).insetBy(dx: margin, dy: margin)
    }
}
```

打开 `CTView.Swift`，将全部内容替换为以下内容：

```swift
import UIKit
import CoreText

class CTView: UIScrollView {
		
  	// 1. buildFrames(withAttrString:andImages:) 将创建 CTColumnView 的实例，然后添加到 scrollView 中。
    func buildFrames(withAttrString attrString: NSAttributedString, 
                     andImages images: [[String: Any]]) {
				// 2.启动 scrollView 的分页。因此，每当用户停止滚动时，scrollView 就会滚动到位，以便一次恰好显示一整页。
        isPagingEnabled = true
        // 3.framesetter 将创建属性文本每一列的 CTFrame
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        // 4.pageView 将作为每个页面中列的子视图的容器视图
        var pageView = UIView()
        var textPos = 0 // 下一个字符
        var columnIndex: CGFloat = 0 // 当前列
        var pageIndex: CGFloat = 0 // 当前页面
        // 通过 settings 配置项，可以访问应用的边距、每页列数、页面尺寸和设置
        let settings = CTSettings()
        // 循环遍历 attrString 并逐列布置文本大小，直到文本位置到达末尾
        while textPos < attrString.length {
          // MARK: TODO
    }
```

是时候开始循环 `attrString` 了。在 `while textPos < attrString.length {` 中添加以下内容：

```swift
// 1. 如果列索引/每页的列数 = 0，则表明该列是其页面上的第一列，则创建一个新的 pageView 来保存该列
if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {
    columnIndex = 0
    pageView = UIView(frame: settings.pageRect.offsetBy(dx: pageIndex * bounds.width, dy: 0))
    addSubview(pageView)
    // 2.增加页面索引
    pageIndex += 1
}
// 3.第一列 x 轴的原点 = pageView 的宽度 / 每页的列数
let columnXOrigin = pageView.frame.size.width / settings.columnsPerPage
// 列的偏移量 = 该列的原点 * 列索引
let columnOffset = columnIndex * columnXOrigin
// 当前列的 frame = 标准列的 frame 加上偏移量
let columnFrame = settings.columnRect.offsetBy(dx: columnOffset, dy: 0)
```

接下来，在下面添加以下 `columnFrame` 初始化代码：

```swift
// 1.创建一个与列大小相同的 CGMutablePath，然后从 textPos 开始，渲染一个新的 CTFrame，其中包含尽可能多的文本。
let path = CGMutablePath()
path.addRect(CGRect(origin: .zero, size: columnFrame.size))
let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, nil)
// 2.使用 CGRect 的 columnFrame 和 CTFrame 的 ctframe 创建一个 CTColumnView，然后将该列添加到 pageView。
let column = CTColumnView(frame: columnFrame, ctFrame: ctframe)
pageView.addSubview(column)
// 3.使用 CTFrameGetVisibleStringRange(_:) 计算列中包含的文本范围
let frameRange = CTFrameGetVisibleStringRange(ctframe)
// textPos 累加该范围长度以反映当前文本位置
textPos += frameRange.length
// 4.在循环到下一列之前将列索引增加 1
columnIndex += 1
```

最后在循环后设置滚动视图的内容大小：

```swift
contentSize = CGSize(width: CGFloat(pageIndex) * bounds.size.width,
                height: bounds.size.height)
```

通过将内容大小设置为屏幕宽度乘以页数，僵尸现在可以滚动到最后。

打开 `ViewController.swift`，并替换：

```swift
(view as? CTView)?.importAttrString(parser.attrString)
```

改为：

```swift
(view as? CTView)?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)
```

在 iPad 上构建并运行应用程序。检查双列布局！左右拖动可在页面之间移动。看起来不错。 :]

![](https://koenig-media.raywenderlich.com/uploads/2017/06/Screen-Shot-2017-06-08-at-12.41.06-PM-353x500.png)

你有列和格式化文本，但缺少图片。使用 Core Text 绘制图像并不是那么简单 - 它毕竟是一个文本框架 - 但在你已经创建的 markup parser 的帮助下，添加图像应该不会太糟糕。

## 在 Core Text 中绘制图片

虽然 Core Text 不能绘制图片，但作为布局引擎，它可以留出空白，为图片腾出空间。通过设置 `CTRun` 的委托，你可以确定 `CTRun` 的上升空间、下降空间和宽度。就像这样：

![](https://koenig-media.raywenderlich.com/uploads/2011/06/CTRunDelegate-500x223.jpg)

当 Core Text 到达带有 `CTRunDelegate` 的 `CTRun` 时，它会询问委托，“我应该为这块数据留出多少空间？”通过在 `CTRunDelegate` 中设置这些属性，你可以在图像文本中留下空白。

首先添加对“img”标签的支持。打开 `MarkupParser.swift` 并找到 `} //end of font parsing`。之后立即添加以下内容：

```swift
// 1.如果 tag 以 img 开头，则使用正则表达式搜索图片的 src 值，即文件名
else if tag.hasPrefix("img") {

          var filename:String = ""
          let imageRegex = try NSRegularExpression(pattern: "(?<=src=\")[^\"]+",
                                                   options: NSRegularExpression.Options(rawValue: 0))
          imageRegex.enumerateMatches(in: tag,
                                      options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                      range: NSMakeRange(0, tag.count)) { (match, _, _) in

              if let match, let range = tag.range(from: match.range) {
                  filename = String(tag[range])
              }
          }
          // 2.将图片宽度设置为列的宽度，以便图片保持宽高比
          let settings = CTSettings()
          var width: CGFloat = settings.columnRect.width
          var height: CGFloat = 0

          if let image = UIImage(named: filename) {
              height = width * (image.size.height / image.size.width)
              // 3.如果图片的高度对于列来说太长，则设置适合的高度，并等比例调整图片的宽度
              // 由于图像后面的文本将包含空白属性，因此包含空白信息的文本必须与图像位于同一列中，
              // 因此将图像高度设置为 settings.columnRect.height - font.lineHeight。
              if height > settings.columnRect.height - font.lineHeight {
                  height = settings.columnRect.height - font.lineHeight
                  width = height * (image.size.width / image.size.height)
              }
          }
  }
```

接下来，在 `if let` 图像块之后立即添加以下内容：

```swift
// 1.将包含图像大小、文件名和文本位置的字典附加到 images 数组。
images += [["width": NSNumber(value: Float(width)),
            "height": NSNumber(value: Float(height)),
            "filename": filename,
            "location": NSNumber(value: attrString.length)]]

// 2.定义 RunStruct 用于保存描述空白位置的属性
struct RunStruct {
    let ascent: CGFloat // 图片的高度
    let descent: CGFloat
    let width: CGFloat // 图片的宽度
}
// 初始化一个包含 RunStruct 的指针
let extentBuffer = UnsafeMutablePointer<RunStruct>.allocate(capacity: 1)
extentBuffer.initialize(to: RunStruct(ascent: height, descent: 0, width: width))

// 3.CTRunDelegateCallbacks 返回属于 RunStruct 类型指针的 ascent、descent 和 width 属性
var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { pointer in

}, getAscent: { pointer -> CGFloat in
    let d = pointer.assumingMemoryBound(to: RunStruct.self)
    return d.pointee.ascent
}, getDescent: { pointer -> CGFloat in
    let d = pointer.assumingMemoryBound(to: RunStruct.self)
    return d.pointee.descent
}, getWidth: { pointer -> CGFloat in
    let d = pointer.assumingMemoryBound(to: RunStruct.self)
    return d.pointee.width
})

// 4.使用 CTRunDelegateCreate 创建将回调和数据参数绑定在一起的委托实例。
let delegate = CTRunDelegateCreate(&callbacks, extentBuffer)

// 5.创建一个包含委托实例的属性字典，然后将一个空格附加到 attrString，该字符串保存文本中的空白位置和大小信息。
let attrDictionaryDelegate = [(kCTRunDelegateAttributeName as NSAttributedString.Key): (delegate as Any)]
attrString.append(NSAttributedString(string: " ", attributes: attrDictionaryDelegate))
```

现在 `MarkupParser` 正在处理“img”标签，你需要调整 `CTColumnView` 和 `CTView` 来渲染它们。

打开 `CTColumnView.swift`。在 `var ctFrame:CTFrame` 下面添加以下内容！保存列的图像和 frames：

```swift
var images: [(image: UIImage, frame: CGRect)] = []
```

接下来，将以下内容添加到 `draw(_:)` 的底部：

```swift
// 循环遍历每个图像，并将其绘制到适当 frame 内的上下文中
for imageData in images {
    if let image = imageData.image.cgImage {
        let imgBounds = imageData.frame
        context.draw(image, in: imgBounds)
    }
}
```

接下来打开 `CTView.swift` 并将以下属性添加到类的顶部：

```swift
// MARK: - Properties
var imageIndex: Int!
```

这标志着 `images` 数组的第一个元素。

接下来在 `buildFrames(withAttrString:andImages:)` 下面添加以下内容：

```swift
func attachImagesWithFrame(_ images: [[String: Any]], 
                           ctframe: CTFrame,
                           margin: CGFloat,
                           columnView: CTColumnView) {
		// 1.获取 ctframe 中包含 CTLine 实例的数组
    let lines = CTFrameGetLines(ctframe) as NSArray
    // 2.使用 CTFrameGetOrigins 将 ctframe 的 line 原点复制到 origins 数组中。
    // 通过设置长度为 0 的范围，CTFrameGetOrigins 将知道遍历整个 CTFrame。
    var origins = [CGPoint](repeating: .zero, count: lines.count)
    CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
    // 3.设置 nextImage 以包含当前图像的属性数据。
    // 如果 nextImage 包含图像的位置，则将其解包并继续；否则，早点返回。
    var nextImage = images[imageIndex]
    guard var imgLocation = nextImage["location"] as? Int else {
        return
    }
    // 4.循环遍历文本行
    for lineIndex in 0..<lines.count {
        let line = lines[lineIndex] as! CTLine
				// 5.如果该行的 glyph runs，文件名和带有文件名的图像都存在，则循环该行的 glyph runs。
        if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun],
           let imageFilename = nextImage["filename"] as? String,
           let img = UIImage(named: imageFilename) {
            for run in glyphRuns {
								// MARK: TODO
            }
        }
    }
}
```

接下来，在 glyph run 的 for 循环中添加以下内容：

```swift
// 1.如果当前 run 不包含 nextImage，则跳过循环的剩余部分，否则，在此处渲染图片
let runRange = CTRunGetStringRange(run)
if runRange.location > imgLocation || runRange.location + runRange.length <= imgLocation {
    continue
}
// 2.使用 CTRunGetTypgraphicBounds 计算图像宽度并将高度设置为返回的 ascent。
var imgBounds: CGRect = .zero
var ascent: CGFloat = 0
imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
imgBounds.size.height = ascent
// 3.使用 CTLineGetOffsetForStringIndex 获取 line 的 x 轴偏移量，然后将其添加到 imgBounds 的原点。
let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
imgBounds.origin.x = origins[lineIndex].x + xOffset
imgBounds.origin.y = origins[lineIndex].y
// 4.将图片及其 frame 添加到当前 CTColumnView。
columnView.images += [(image: img, frame: imgBounds)]
// 5.增加图片索引。如果 images[imageIndex] 处有图片，请更新 nextImage 和 imgLocation，
// 以便它们引用下一个图片。
imageIndex! += 1
if imageIndex < images.count {
    nextImage = images[imageIndex]
    imgLocation = (nextImage["location"] as AnyObject).intValue
}
```

![](https://koenig-media.raywenderlich.com/uploads/2017/04/runBounds-421x500.png)

好的！伟大的实现！快到了——最后一步。

在 `buildFrames(withAttrString:andImages:)` 内的 `pageView.addSubview(colum)` 代码的正上方添加以下内容以附加图像（如果存在）：

```swift
if images.count > imageIndex {
    attachImagesWithFrame(images, ctframe: ctframe, margin: settings.margin, columnView: column)
}
```

在 iPhone 和 iPad 上构建并运行！

![](https://koenig-media.raywenderlich.com/uploads/2017/06/Screen-Shot-2017-06-08-at-12.51.19-PM-590x500.png)

恭喜！感谢你的辛勤工作，僵尸饶恕了你的大脑！ :]

## 何去何从？

在[这里](https://koenig-media.raywenderlich.com/uploads/2017/06/CoreTextMagazine-Final.zip)查看完整的项目。

正如简介中提到的，**Text Kit** 通常可以替代 **Core Text**；因此，请尝试使用 **Text Kit** 编写相同的教程，看看效果如何。也就是说，这个 **Core Text** 教程不会白费！ **Text Kit** 提供到 **Core Text** 的免费桥接，因此你可以根据需要在框架之间轻松进行转换。

有任何问题、意见或建议吗？加入下面的论坛讨论吧！
