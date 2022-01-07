> 原文：[Swift Tutorial Part 2: Types and Operations](https://www.raywenderlich.com/6364-swift-tutorial-part-2-types-and-opera)

欢迎来到学习 Swift 的迷你系列的第二部分!

本章是[第一部分：表达式、变量和常量](https://www.raywenderlich.com/?p=199292)的续篇。我们建议你从本系列教程的第一部分开始学习，以获得最大的收获。

现在是时候学习更多关于类型的知识了! 从形式上看，一个类型描述了一系列值和可以对它们进行的操作。

在本教程中，你将学习如何处理 Swift 编程语言中的不同类型。你将学习类型之间的转换，还将了解类型推断，这将使你作为程序员的生活变得更加简单。

最后，你将学习元组类型，它允许你创建由多个值组成的任何类型。


## 开始

有时，你会有一种格式的数据，需要将其转换为另一种格式。天真的尝试方式是这样的：

```swift
var integer: Int = 100
var decimal: Double = 12.5
integer = decimal
```

如果你试图这样做，Swift 会抱怨，并在第三行吐出一个错误：

`Cannot assign value of type 'Double' to type 'Int'`

有些编程语言并不那么严格，会自动进行这样的类型转换。经验表明，这种自动转换是软件产生错误的万恶之源，而且往往会损害性能。Swift 阻止你把一种类型的值赋给另一种类型，这就避免了上述问题。

记住，计算机依靠程序员来告诉它们该怎么做。在 Swift 中，这包括对类型转换的明确说明。如果你想让转换发生，你必须这样说。

你需要明确地写出你想转换的类型，而不是简单地赋值。你可以这样做：

```swift
var integer: Int = 100
var decimal: Double = 12.5
integer = Int(decimal)
```

第三行的赋值语句现在明确地告诉 Swift，你想从原始类型 `Double` 转换到新类型 `Int`。

> 注意：在这种情况下，将小数点后的值分配给整数会导致精度的损失。整数变量最后的值是12，而不是12.5。这就是明确的重要性。Swift 想确保你知道你在做什么，以及你可能会因为执行类型转换而最终丢失数据。

## 操作混合类型

到目前为止，你只看到了独立作用于整数或 Double 类型的运算符。但是，如果你有一个整数，你想把它乘以一个浮点数呢？

也许你以为你可以这样做：

```swift
let hourlyRate: Double = 19.5
let hoursWorked: Int = 10
let totalCost: Double = hourlyRate * hoursWorked
```

如果你尝试这样做，你会在最后一行得到一个错误：

```text
Binary operator '*' cannot be applied to operands of type 'Double' and 'Int'
```

这是因为，在 Swift 中，你不能将 `*` 运算符应用于混合类型。这个规则也适用于其他算术运算符。一开始可能会觉得很惊讶，但 Swift 是相当有帮助的。

Swift 迫使你明确说明，当你想用 Int 乘以 Double 时，你想要表达的意图，因为结果只能是一种类型。你想让结果是 Int，在执行乘法之前将 Double 转换为 Int？或者你想让结果是一个 Double，在执行乘法之前将 Int 转换为 Double？

在这个例子中，你希望结果是一个 Double 类型。你不想要一个 Int，因为在这种情况下，Swift 会把 `hourlyRate` 常数转换成 Int 来执行乘法，把它四舍五入到19，失去 Double 的精度。

你需要告诉 Swift 你想让它把 `hoursWorked` 常量看作是一个 Double，像这样：

```swift
let hourlyRate: Double = 19.5
let hoursWorked: Int = 10
let totalCost: Double = hourlyRate * Double(hoursWorked)
```

现在，当 Swift 将每个操作数相乘时都是一个 Double，所以 `totalCost` 也是一个 Double 类型的数值。

## 类型推断

到此为止，每次你看到一个变量或常量的声明时，它都伴随着一个相关的类型，像这样：

```swift
let integer: Int = 42
let double: Double = 3.14159
```

你可能会问自己。"既然赋值的右侧已经是一个 Int 或一个 Double，为什么我一定要写上：Int 和 Double？" 可以肯定的是，这是多余的；你不需要做太多的工作就可以看到这一点。

事实证明，Swift 的编译器也能推断出这一点。它不需要你一直告诉它类型--它可以自己想出来。这是通过一个叫做**类型推断**的过程完成的。不是所有的编程语言都有这个功能，但 Swift 有，而且这是 Swift 语言的关键组成部分。

因此，你可以在大多数你看到类型的地方简单地放弃类型声明。

例如，考虑下面的常量声明：

```swift
let typeInferredInt = 42
```

有时，检查一个变量或常量的推断类型是很有用的。你可以在 playground 中通过按住 Option 键并点击变量或常量的名称来完成这个任务。Xcode 将显示一个像这样的弹出窗口：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/072223.png)

Xcode 通过给你提供声明来告诉你推断的类型，如果没有类型推断，你将不得不使用这个声明。在这种情况下，该类型是Int。

它也适用于其他类型：

```swift
let typeInferredDouble = 3.14159
```

点击这个选项，可以看到以下内容：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/080535.png)

类型推断并不神奇。Swift 只是在做你的大脑很容易做到的事情。不使用类型推断的编程语言往往会让人感觉很啰嗦，因为你每次声明一个变量或常量时，都需要指定通常很明显的类型。

有时，你想定义一个常量或变量，并确保它是一个特定的类型，即使你要分配给它的是一个不同的类型。你在前面看到了如何从一种类型转换到另一种类型。例如，考虑下面的情况：

```swift
let wantADouble = 3
```

在这里，Swift 将 `wantADouble` 的类型推断为 Int。但如果你想要的是 Double 呢？

你可以这样做：

```swift
let actuallyDouble = Double(3)
```

这与你之前看到的类型转换是一样的。

另一个选择是根本不使用类型推断，而是做以下工作：

```swift
let actuallyDouble: Double = 3
```

还有第三个选项，像这样：

```swift
let actuallyDouble = 3 as Double
```

这使用了一个你以前没有见过的新关键词，即 `as`，它也进行了一个类型转换。

> 注意：像3这样的字面值没有类型。只有在表达式中使用它们，或将它们赋值给一个常量或变量时，Swift才会为它们推断出一个类型。
> 一个不包含小数点的字面数字值也可以作为一个 Int 和一个 Double 使用。这就是为什么你被允许将数值3分配给常量`actuallyDouble`。
>
> 含有小数点的数值不能是整数。这意味着你可以避免讨论整个问题，如果你一开始就这样做：
>
> `let wantADouble = 3.0`
>
> 对不起! (不是对不起!) :]

## Strings

数字在编程中是必不可少的，但它们并不是你在应用程序中需要处理的唯一数据类型。文本也是一种极为常见的数据类型，例如人的姓名、地址，甚至是一本书的文字。所有这些都是一个应用程序可能需要处理的文本的例子。

大多数计算机编程语言将文本存储在一种叫做 `String` 的数据类型中。本教程的这一部分向你介绍了字符串，首先向你介绍字符串概念的背景，然后向你展示如何在 Swift 中使用它们。

### 计算机如何表示字符串

计算机认为字符串是单个字符的集合。所有的代码，无论用什么编程语言，都可以简化为原始数字。字符串也不例外!

这听起来可能非常奇怪。字符怎么会是数字呢？从根本上说，计算机需要能够将一个字符翻译成计算机自己的语言，它通过给每个字符分配一个不同的数字来做到这一点。这就形成了一个从字符到数字的双向映射，被称为字符集。

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/082252.png)

当你在键盘上按下一个字符键时，你实际上是在向计算机传达该字符的数字。你的文字处理程序将这个数字转换成字符的图片，最后将这个图片呈现给你。

### Unicode

在孤立的情况下，计算机可以自由选择它喜欢的任何字符集映射。如果计算机想让字母a等于数字10，那就这样吧。但是，当计算机之间开始相互交谈时，它们需要使用一个共同的字符集。如果两台计算机使用不同的字符集，那么，当一台计算机向另一台计算机传输字符串时，它们最终会认为这些字符串包含不同的字符。

多年来有几个标准，但最现代的标准是 Unicode。它定义了今天几乎所有计算机都使用的字符集映射。

> 注：你可以在其官方网站上阅读更多关于Unicode的信息，http://unicode.org。

考虑一下 cafe 这个词。Unicode 标准告诉你，这个词的字母应该像这样被映射到数字上：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/082454.png)

与每个字符相关的数字被称为码位。因此，在上面的例子中，c使用代码点99，a使用代码点97，以此类推。

当然，Unicode不仅适用于英语中使用的简单拉丁字符，如c、a、f和e，它还可以让你映射来自世界各地语言的字符。cafe 这个词来自法语，在法语中被写成café。Unicode对这些字符的映射是这样的：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/082548.png)

而这里是一个使用汉字的例子（根据谷歌翻译，它的意思是 "计算机编程"）：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/082622.png)

你可能听说过emojis，它是可以在你的文本中使用的小图片。事实上，这些图片只是普通的字符，也是由Unicode映射的。比如说：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/082648.png)

这些只是两个字符。它们的码位是非常大的数字，但每个码位仍然只是一个码位。计算机认为它们与其他两个字符没有区别。

> 注："emoji "一词来自日语："e "表示图片，"moji "表示字符。

## Swift 中的字符串

Swift，像任何一门完善的编程语言一样，可以直接处理字符和字符串。它分别通过数据类型 `Character` 和 `String` 来实现。在本节中，你将了解这些数据类型以及如何使用它们。

### Character 和 String

`Character` 类型可以存储单个字符。如：

```swift
let characterA: Character = "a"
```

它可以存储任何字符--甚至是一个表情符号：

```swift
let characterDog: Character = "🐶"
```

但是这种数据类型被设计成只能存储单一字符。另一方面，`String` 数据类型可以存储多个字符。如：

```swift
let stringDog: String = "Dog"
```

这个表达式的右边就是所谓的字符串字面量，它是 Swift 的语法，用来表示一个字符串。

当然，类型推断在这里也适用。如果你去掉上面声明中的类型，那么 Swift 就会做正确的事情，让 `stringDog` 成为一个 String 常量：

```swift
let stringDog = "Dog" // Inferred to be of type String
```

> 注意：在 Swift 中没有所谓的字符字面。一个字符只是一个长度为1的字符串。然而，Swift 推断任何字符串字面的类型都是String，所以如果你想用 Character 来代替，你必须明确类型。

### 字符串拼接

你能做的远不止创建简单的字符串。有时，你需要操作一个字符串，一个常见的方法是将其与另一个字符串结合。

在Swift中，你可以用一个相当简单的方法来做这件事：使用加法运算符。就像你可以加数字一样，你也可以加字符串：

```swift
var message = "Hello" + " my name is "
let name = "Lorenzo"
message += name // "Hello my name is Lorenzo"
```

你需要将 `message` 声明为一个变量，而不是一个常量，因为你想修改它。你可以像第一行那样把字符串字面符号加在一起，你也可以像最后一行那样把字符串变量或常量加在一起。

也可以将字符添加到一个字符串中。然而，Swift 对类型的严格要求意味着你在这样做时必须明确，就像你在处理数字时必须明确，如果一个是 Int，另一个是 Double。

要向字符串中添加一个 character 字符，你要这样做：

```swift
let exclamationMark: Character = "!"
message += String(exclamationMark) // "Hello my name is Lorenzo!"
```

通过这段代码，你在将字符添加到消息中之前明确地将其转换为字符串。

### 字符串插值

你也可以通过使用插值来建立一个字符串，这是一种特殊的 Swift 语法，让你以一种易于阅读的方式创建一个字符串：

```swift
let name = "Lorenzo"
let messageInOne = "Hello my name is \(name)!" // "Hello my name is Lorenzo!"
```

上面的例子比上一节的例子可读性强多了。这是对字符串字面语法的扩展，即用其他值替换字符串的某些部分。你把你想给字符串的值放在小括号里，前面加一个反斜杠。

这种语法的工作方式与从其他数据类型（如数字）建立字符串的方式相同：

```swift
let oneThird = 1.0 / 3.0
let oneThirdLongString = "One third is \(oneThird) as a decimal."
```

这里，你在插值中使用了一个 `Double`。在这段代码的最后，你的 `oneThirdLongString` 常量将包含以下内容：

```
One third is 0.3333333333333333 as a decimal.
```

当然，实际上需要无限的字符来表示小数的三分之一，因为它是一个重复的小数。用 `Double` 进行字符串插值，你没有办法控制结果字符串的精度。

这是使用字符串插值的一个不幸的结果；它使用起来很简单，但没有提供自定义输出的能力。

### 多行字符串

Swift 有一个很好的方法来表达包含多行的字符串。当你需要把一个很长的字符串放在你的代码中时，这可能是相当有用的。

你可以这样做：

```swift
let bigString = """
  You can have a string
  that contains multiple
  lines
  by
  doing this.
  """
print(bigString)
```

三个双引号标志着这是一个多行字符串。方便的是，第一个和最后一个新行并不成为字符串的一部分。这使得它更加灵活，因为你不必将这三个双引号与字符串放在同一行。

在上面的例子中，它将打印如下：

```
You can have a string
that contains multiple
lines
by
doing this.
```

请注意，多行字符串字面中的两个空格被从结果中剥离出来。Swift看的是最后三个双引号行的前导空格的数量。以此为基准，Swift要求它上面的所有行至少有这么多的空格，这样它就可以从每行中删除。这可以让你用漂亮的缩进来格式化你的代码，而不影响输出。

## 元组

有时，数据是成对的或三倍的。这方面的一个例子是二维网格上的一对（x，y）坐标。同样地，三维网格上的一组坐标由一个x值、一个y值和一个z值组成。

在Swift中，你可以通过使用元组以一种非常简单的方式来表示这些相关的数据。

元组是一种类型，表示由任何类型的一个以上的值组成的数据。你可以在你的元组中拥有任意多的值。例如，你可以定义一对二维坐标，其中每个轴的值是一个整数，像这样：

```swift
let coordinates: (Int, Int) = (2, 3)
```

坐标的类型是一个包含两个Int值的元组。元组内的值的类型，在这种情况下是Int，用逗号隔开，周围有括号。创建元组的代码基本相同，每个值都由逗号隔开，并由圆括号包围。

类型推断也可以推断出元组的类型：

```swift
let coordinatesInferred = (2, 3) // Inferred to be of type (Int, Int)
```

你可以类似地创建一个 Double 值的元组，像这样：

```swift
let coordinatesDoubles = (2.1, 3.5) // Inferred to be of type (Double, Double)
```

或者你可以混合和匹配组成元组的类型，像这样：

```swift
let coordinatesMixed = (2.1, 3) // Inferred to be of type (Double, Int)
```

而这里是如何访问元组内的数据：

```swift
let coordinates = (2, 3)
let x1 = coordinates.0
let y1 = coordinates.1
```

你可以通过元组中的下标索引来引用元组中的每个项目，从零开始。因此，在这个例子中，x1等于2，y1等于3。

> 注意：从零开始是计算机编程中的一种常见做法，被称为零点索引。
> 在前面的例子中，可能不是很明显，索引0的第一个值是x坐标，索引1的第二个值是y坐标。这就再次说明了为什么总是以避免混淆的方式来命名你的变量是很重要的。

幸运的是，Swift 允许你对元组的各个部分进行命名，你可以明确每个部分代表什么。比如说：

```swift
let coordinatesNamed = (x: 2, y: 3) // Inferred to be of type (x: Int, y: Int)
```

在这里，代码注释了 `coordinatesNamed` 的值，以包含元组中每个部分的标签。

然后，当你需要访问元组的每个部分时，你可以通过它的名字来访问它：

```swift
let x2 = coordinatesNamed.x
let y2 = coordinatesNamed.y
```

这就更清楚、更容易理解了。更多的时候，命名你的元组的组成部分是有帮助的。

如果你想同时访问元组的多个部分，就像上面的例子一样，你也可以使用速记语法来使之更容易：

```swift
let coordinates3D = (x: 2, y: 3, z: 1)
let (x3, y3, z3) = coordinates3D
```

这就声明了三个新的常数，x3、y3和z3，并依次将元组的每一部分分配给它们。该代码等同于以下内容：

```swift
let coordinates3D = (x: 2, y: 3, z: 1)
let x3 = coordinates3D.x
let y3 = coordinates3D.y
let z3 = coordinates3D.z
```

如果你想忽略元组中的某个元素，你可以用下划线替换声明中的相应部分。例如，如果你在进行二维计算，并想忽略坐标3D的Z坐标，那么你可以写如下：

```swift
let (x4, y4, _) = coordinates3D
```

这一行代码只声明了 `x4` 和 `y4` 变量。`_` 是特殊字符，只是意味着你暂时忽略这部分。

> 注意：你会发现，你可以在整个 Swift 中使用下划线--也叫**通配符**--来忽略一个值。

## 一大堆数字类型
你一直在用 Int 来表示整数。一个 Int 在大多数现代硬件上用64位表示，而在较老的--或资源较紧张的--系统上用32位表示。Swift 提供了更多使用不同存储量的数字类型。对于整数，你可以使用显式符号类型 Int8、Int16、Int32 和 Int64。这些类型分别消耗1、2、4和8字节的存储空间。这些类型中的每一个都使用1位来表示符号。

如果你只处理非负值，有一组明确的无符号类型可以使用。这些类型包括 UInt8, UInt16, UInt32 和 UInt64。虽然你不能用这些类型来表示负值，但额外的1位可以让你表示比有符号类型大一倍的值。

下面是对不同整数类型及其存储特性的总结。大多数情况下，你只想使用Int。如果你的代码与另一个使用这些更精确大小的软件进行交互，或者你需要对存储大小进行优化，这些就变得很有用。

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/155710.png)

你一直在使用 Double 来表示小数。Swift提供了一个 Float 类型，它的范围和精度都比 Double 小，但需要一半的存储。现代硬件已经为Double 进行了优化，所以除非你有充分的理由，否则你应该使用它。

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/155839.png)

大多数时候，你只需要使用 Int 和 Double 来表示数字，但是，每隔一段时间，你可能会遇到其他类型。你已经知道如何处理它们了。例如，假设你需要将一个Int16与一个UInt8和一个Int32加在一起。你可以这样做。

```swift
let a: Int16 = 12
let b: UInt8 = 255
let c: Int32 = -100000

let answer = Int(a) + Int(b) + Int(c) // Answer is an Int
```

## 幕后原理窥探：Protocols

尽管有十几种不同的数字类型，但它们都相当容易理解和使用。这是因为它们都大致上支持相同的操作。换句话说，一旦你知道如何使用Int，使用任何一种类型都是非常简单的。

Swift 真正伟大的功能之一是它如何使用所谓的协议来正式确定类型通用性的想法。通过学习一个协议，你马上就能理解使用该协议的整个类型家族是如何工作的。

以 Integers 整数为例，其功能可以这样图示：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/160022.png)

箭头表示遵守（有时称为采用）一个协议。虽然这张图没有显示整数类型符合的所有协议，但它让你了解事情是如何组织的。

Swift 是第一个基于协议的语言。当你开始了解这些类型所依据的协议时，你就可以开始以其他语言无法实现的方式利用这个系统。

## 何去何从？

你可以使用本教程顶部或底部的下载材料按钮下载最终的操场。为了提高你的Swift技能，你会发现一些小练习要完成。如果你被卡住了，或者你需要一些帮助，可以随时利用配套的解决方案。

在本教程中，你已经了解到类型是编程的一个基本部分。它们允许你正确地存储你的数据。你在这里还看到了一些类型，包括字符串和图元，以及一堆数字类型。

在下一部分，你将学习布尔逻辑和简单的控制流。继续阅读第三部分：流控制，以继续这个系列。

如果有任何问题或意见，请在下面的讨论中告诉我们。

本教程取自《Swift学徒》第四版第三章，可在 raywenderlich.com 商店购买。

请看一下，并让我们知道你的想法!
