> 原文链接：[字节跳动 Swift 培训 - 字符串介绍](http://pjhubs.com/2020/07/06/swiftguide-string/)

## 前言

本文章为 Swift 培训系列课程《字符串》环节，分为四大部分，涵盖 Swift 字符串与 Objective-C（下文简称 OC）字符串区别对比、Swift 字符串支持的操作、注意点以及总结，并结合个人使用经验帮助各位同学快速掌握 Swift 字符串核心要点，准确落地到实际场景中。

## 区别于联系

Swift 中 `String` 类型底层进行了对 `NSString` 类型的实现，可以兼容原先对 `NSString` 使用的各种操作。Swift 的 `String` 类型与 OC `NSString` 最大的区别就是 `String` 是一个结构体（`Struct`）类型，是值类型，并且遵循了例如集合等协议，可以利用函数式编程上的一些操作来调整并优化我们对字符串的操作。关于集合可见此篇文章。

对于 Swift 的 `String` 是否支持 `Collection` 协议贯穿了整个 Swift 前期。Swift 1.x 中 `String` 是遵循 `Collection` 协议的，Swift 2.x 和 Swift 3.x 时代去除了，并且着手放弃 `Index` 这一索引抽象转而使用 `Int`。但从 Swift 4.x 开始直到现在又把 `Collection` 协议的遵循加了回去。（下文细说）

在以往使用「集合」时，我们下意识的会写出 `array[2]` 等类似的代码，我们默认认为 `array` 集合里的元素从 `0` 开始，并且认为 `array` 集合里的每一个元素都是等长（占据的内存字节？）的。

Swift 的 `String` 是由一个个 `Character` 类型的字符组成，可以通过遍历的方式检索到每一个字符。`String` 类型是基于 Unicode 建立的，可以基于默认情况下直接使用 Unicode 的便利来处理字符串，但在涉及到本地化的一些操作时，需要额外注意由于 Unicode 编码带来的额外问题。

在 Swift 5 之前，字符串内容可以使用 UTF-16（Unicode）和 ASCII 两种编码方式进行表示，在 Swift 5 中均通过 UTF-8 编码单位集合来表示（详见此篇文章），暴露给外部是由一个个 `Character` 组成，而每一个 `Character `由 1~4 个 UTF-8 编码单位组成。因此，当 `String` 作为 `Character` 的集合被外部使用时，`String ` 中的每一个元素都不一定等长。在检索 `String` 中的某一个字符时，总是要依赖 `String` 的实例去生成 `Index`，而不能直接生成。结合 `Index` 的内存布局：

![](https://s2.loli.net/2022/01/14/li9sHvh5DCVLp7o.png)

可以看出 `Index` 里记录了码位的偏移量，并且其中的 UTF-8 字符编码个数不定，每个 `String` 下的 `index` 所标记出的偏移量都会有差异，所以 `Index` 总是要依赖 `String` 的实例去生成。

从 `Index` 的内存布局中可以发现其有一个完整的缓存体系，这种方式在使用过程对性能的消耗是比较大的，一旦 `Index` 生成了，整个取值操作复杂度都降低到了 `O(1)`。

我们日常在 OC 中字符串的类型为 `NSString` 和 `NSMutableString`，针对可变字符串和不可变字符串有意的通过两个类型进行区分，而在 Swift 中，只需要通过 `let` 和 `var` 的变量修饰符进行定义，即可通过编译器的能力在编译时推断出字符串的类型。

```objc
// OC
NSString *string = @"不可变字符串";
NSMutableString *mutableString = @"可变字符串";
```

```swift
// Swift
let string = "不可变字符串"
var mutableString = "可变字符串"
```

在上面的这个 Swift 例子中，字符串的类型信息从表达式树（expression tree）的叶子节点传向根节点，换句话说，`let string = "不可变字符串"` 中，`string` 变量的类型首先根据 `"不可变字符串"` 的类型进行推断，然后将该类型信息传递到根节点（变量 `string`）。

同样，在 Swift 中类型信息可以反方向传递，如下面的例子中 `floatValue` 通过显式的类型注解指定了字面量 `3.1415` 的类型为 `Float` 而不是 `Double` 类型。关于此类问题在此不做展开，点到为止。

```swift
// Swift
let floatValue: Float = 3.1415
let doubleValue = 2.333
```

### 计算长度

在日常的需求开发时，我们经常会遇到计算字符串的长度来做一些 UI 上的调整，比如在某些情况下无法关联确定约束后的布局，需要提前计算出高度的卡片。这个时候如果不在输入端限制 emoji 等特殊字符的输入，可能就会出现因为编码原因导致获取到的字符串长度不对等问题，比如 Attribute 渲染和移动光标等操作。

```swift
// OC
NSString *string = @"2333💅";
NSLog(@"%lu", (unsigned long)string.length); // 6
// length 方法返回的是以 UTF-16 编码方式返回的字符数量
```

```swift
// Swift
let string = "2333💅"
print(string.count) // 5
```

从视觉上看，我们期望在 `NSString` 中获取到 `2333💅` 的字符串长度为「5」，但由于 `NSString` 历史感很浓重，他就是**字符**的数组，只会单纯的计算字符数量（默认情况），在官方文档中对 `NSString` 的编码格式也作出了说明。

> A string object presents itself as a sequence of UTF–16 code units. You can determine how many UTF-16 code units a string object contains with the length method and can retrieve a specific UTF-16 code unit with the character(at:) method. These two “primitive” methods provide basic access to a string object.
>
> 字符串对象以序列化的 UTF-16 编码单元呈现。你可以用 `length` 方法确定一个字符串对象包含多少个 UTF-16 编码单元，并可以用 `character(at:)` 方法检索一个特定的 UTF-16 编码单元。这两个 "原始（primitive）" 方法提供了对字符串对象的基本访问。

而在 UTF-16 中 emoji 表情 `💅` 占用了两个字符的长度，但如果我们换一个 emoji，它们在 UTF-16 编码中的字符长度均不一样，比如下面的这几个，在 `NSString` 中处理此类带 emoji 的长度就是一件相对恶心的问题了。

```swift
// OC

NSString *string = @"1️⃣";
NSLog(@"%lu", (unsigned long)string.length); // 3

NSString *string = @"🇨🇳";
NSLog(@"%lu", (unsigned long)string.length); // 4

NSString *string = @"👩‍👩‍👧‍👧";
NSLog(@"%lu", (unsigned long)string.length); // 11
```

```swift
// Swift
let emoji = "1⃣️"
print(emoji.count) // 1
print(emoji.utf16.count) // 3
print(emoji.utf8.count) // 7

let flag = "🇨🇳"
print(flag.count) // 1
print(flag.utf16.count) // 4
print(flag.utf8.count) // 8

// :family_woman_woman_girl_girl:
let family = "👩‍👩‍👧‍👧"
print(family.count) // 1
print(family.utf16.count) // 11
print(family.utf8.count) // 25
```

> 注
> :family_woman_woman_girl_girl: 的字符编码 `U+ 1F468 200D 1F469 200D 1F467 200D 1F466`，它在底层是由四个单独的 Emoji 和三个零宽度连接符组合而成的。因此占据的 UTF-16 编码位数是 `4*2 + 3 = 11`。



### 多行文字字面量

在 Swift 中，我们对「多行文字」的处理变得更加简洁，也更加符合感官理解。

```objc
// OC
NSString *limerick = @"A lively young damsel named Menzies\n"
        @"Inquired: «Do you know what this thenzies?»\n"
        @"Her aunt, with a gasp,\n"
        @"Replied: \"It's a wasp,\n"
        @"And you're holding the end where the stenzies.\n";
```

```swift
// Swift
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
```



### 本地化

#### 转换大小写

转化大小写时，很多时候我们会下意识的直接调用 `String.uppercased()` 方法进行，但这只是单纯的对传入的字符 / 字符串进行大小写转换，未考虑到不同国家下的不同语言对字母的不同理解，如下文中的 `i` 在土耳其语和美国英语中的转大写时出现了不同的形式。

```swift
var insertString = "i"
print(insertString.uppercased(with: Locale(identifier: "tr-tr"))) // İ
print(insertString.uppercased(with: Locale(identifier: "en_US"))) // I

print(insertString.uppercased(with: Locale.current)) // I，推荐
print(insertString.uppercased()) // I，不推荐
```

#### 格式化

与「转换大小写相同」的情况类似，大多数情况下，格式化字符串时我们并没有去考虑本地化，严格来说这种方法得到的字符串是不能直接显示在用户界面上的，如果需要进行本地化处理，我们需要使用提供本地化的格式化方法。这部分内容与「转换大小写」基本一致，不做展开。



### 判空

在 Swift 中判断一个字符串是否为空，刚开始很容易就延续 OC 中的 `length` 方法从而调用 `count` 方法来进行，**虽然表现上没有啥问题**，但在 Swift 中的 `count` 方法是通过内部调用 `distance` 来比对 `startIndex` 和 `endIndex` 两个索引遍历进行的判断。因此更加推荐使用 `isEmpty` 方法直接比对 `startIndex` 和 `endIndex`。

```objc
NSString *insertString = @"bytedance";
// 第一种
if ([insertString.length == 0]) {
    
}

// 其它。还有很多粒度更细的判空操作，不做展开。
```

```swift
if ("bytedance".isEmpty) {
    // 推荐
}

if ("bytedance".count == 0) {
    // 不推荐
}
```

### 常规操作

#### 前插

```swift
NSMutableString *insertString = [NSMutableString stringWithString:@"bytedance"];
[insertString insertString:@"ixigua" atIndex:0];
NSLog(@"%@", insertString);
// ixiguabytedance
```

```swift
// 第一种
var insertString = "bytedance"
insertString.insert(contentsOf: "ixigua", at: insertString.startIndex)
print(insertString) // ixiguabytedance

// 第二种
var insertString = "bytedance"
print("ixigua" + insertString) // ixiguabytedance

// 第三种（只是为了演示，插值法这么用显得多余）
var insertString = "bytedance"
let ixiguaString = "ixigua"
print("\(ixiguaString)" + insertString) // ixiguabytedance
```

#### 中插

如果我们想要把一个字符串插入到另外一个字符串的某个位置中，核心点在于这个位置索引的获取。绝大多数情况下，我们都需要先确定当前被插入字符串的范围 range，然后再根据 range 来确定插入的具体位置

```objc
NSMutableString *insertString = [NSMutableString stringWithString:@"bytedance"];
        
[insertString insertString:@"ixigua" atIndex:0];
NSLog(@"%@", insertString); // ixiguabytedance

NSRange range = [insertString rangeOfString:@"byte"];
[insertString insertString:@"@" atIndex:range.location];
NSLog(@"%@", insertString); // ixigua@bytedance
```

```swift
var insertString = "ixiguabytedance"
let startIndex = insertString.index(insertString.startIndex, offsetBy: 6)
insertString.insert(contentsOf: "@", at: startIndex)
print(insertString) // ixigua@bytedance
```

#### 后插 / 追加

在 OC 中给字符串末尾添加新的字串总是会不断的调用 `appendString` 方法，但在 Swift 中我们可以仅仅使用被重载处理过的 `+` 操作符来完成这件事。

```objc
NSMutableString *insertString = [NSMutableString stringWithString:@"bytedance"];
[insertString appendString:@"ixigua"];
NSLog(@"%@", insertString);
```

```swift
var insertString = "bytedance"
insertString = insertString + "ixigua"
print(insertString)
```

#### 指定位置之前 / 后的字符串

```objc
NSString *firstString = @"bytedance";
NSLog(@"%@", [firstString substringToIndex:4]); // byte
NSLog(@"%@", [firstString substringFromIndex:4]); // dance
```

```swift
let firstString = "Apple😂1⃣️"
print(firstString.prefix(6)) // Apple😂
print(firstString.suffix(5)) // ple😂1⃣️
```

当我们在 Swift 中取出 `String` 的字串时，如 `prefixString`，此时它的类型为 `Substring`，可以对 `prefixString` 使用与 `String` 类似的操作方法，但需要注意的是，`Substring` 会与 `String` 共用同一块内存，`Substring` 不适合做跨域的持久化操作，否则原先的 `String` 内存将会一直保留到 `Substring` 不再被使用为止。

#### 覆盖 / 替换

```objc
NSMutableString *insertString = [NSMutableString stringWithString:@"bytedance"];
NSRange range = {0,0};
[insertString replaceCharactersInRange:range withString:@"ixigua"];
NSLog(@"%@", insertString); // ixiguabytedance
```

```swift
var insertString = "bytedanceClub"
let range = insertString.range(of: "bytedance")!
insertString.replaceSubrange(range, with: "ixigua")
print(insertString) // ixiguaClub
```

替换 / 覆盖在 OC 和 Swift 中都属于相对费劲的操作，虽说核心也是在框定 range，但根据不同的需求可以组合出不同的实现方式，在此只做点睛，各位同学可以根据具体业务场景来进行调整和优化。

### 比较

因为 Swift 的字符串 `String` 是符合 `Comparable` 协议的，刚开始接触 Swift 可能会不经意的写出比对两个字符串大小的操作，比如：

```swift
let firstString = "bytedance"
let secondString = "ixigua"

if (firstString > secondString) {
    print("wow") // 不会打印
}
```

这是因为通过 Unicode 对照算法来比较两个字符串，看其结果是否小于 0，表现上就是左边的字符串小于右边。如果这个对照算法的结果为 0，则代表两个字符串在该对照算法下是相对的，对照算法可见[这篇文章](http://unicode.org/reports/tr10/#Main_Algorithm)。所以如果出现了需要比较两个字符串大小的地方，应该通过调用 `count` 方法进行。

通过 `compare` 方法的比较是对比的字母序，并且是按位比较。

```objc
NSString *firstString = @"bytedance";
NSComparisonResult result = [firstString compare:@"a"]; // NSOrderedDescending
```

```swift
let firstString = "bytedance"
let result = firstString.compare("a") // orderedDescending，降序
```

`result` 是 `NSComparisonResult` 类型枚举值。

| NSComparisonResult  | 结果                         |
| ------------------- | ---------------------------- |
| NSOrderedAscending  | 左字符串有比右字符串大的字符 |
| NSOrderedSame       | 相等                         |
| NSOrderedDescending | 左字符串有比右字符串小的字符 |

为了能够更好的比较两个字符串大小，系统提供了各种 options 类型供我们在不同的场景下进行使用，但需要注意的是，在不同国家和地方下的不同字母顺序是不同的，需要同上文所说的那般结合 Local 进行判断，细节不再展开。

### 搜索

#### 前 / 中 / 后缀

```objc
NSString *firstString = @"bytedance";
if ([firstString hasPrefix:@"b"]) {
    NSLog(@"wow"); // wow
}
if ([firstString containsString:@"te"]) {
    NSLog(@"emmm"); // emmm
}
if ([firstString hasSuffix:@"e"]) {
    NSLog(@"yep"); // yep
}
```

```swift
if (firstString.hasPrefix("b")) {
    print("wow")
}
if (firstString.contains("te")) {
    print("emmm")
}
if (firstString.hasSuffix("e")) {
    print("yep")
}
```

#### 搜索字符串

在 OC 中字符串中的字串相对容易的可以获取到，但在 Swift 中字符串截取反而是一件刚开始会摸不着头脑的操作，虽然前文也说了，Swift 字符串可以直接转为 `NSString` 后通过使用 `NSString` 的方法进行操作，但这么弄和 Swift 设计出的 `String` 初衷就不对了。

```objc
NSString *firstString = @"bytedance";
NSRange range = [firstString rangeOfString:@"byte"]; // location = 0, length = 4
```

```swift
// 这不是唯一方法。
let firstString = "bytedance"
let range = firstString.range(of: "byte")!
let location = firstString.distance(from: firstString.startIndex, to: range.lowerBound) // 0
let length = firstString.distance(from: firstString.startIndex, to: range.upperBound) // 4
```



## 参考资料

开始梳理 Swift 字符串的内容后，发现以前对 Swift 的字符串认识与现在已经有了一些区别，以上仅为笔者从个人使用角度出发列出需要注意的地方，做了些索引的工作，各位同学如果有余力可以多多阅读以下列出的参考资料，若有说明不到位的地方，望指出。

* https://objccn.io/issue-9-1/
* https://objccn.io/issue-9-2/
* https://swiftgg.gitbook.io/swift/swift-jiao-cheng/03_strings_and_characters#string-literals
* https://www.logcg.com/archives/3253.html
* [http://epingwang.me/2017/06/29/2017-06-29 - 探索 iOS 中 Emoji 表情的编码与解析 /](http://epingwang.me/2017/06/29/2017-06-29-探索iOS中Emoji表情的编码与解析/)
* https://developer.apple.com/documentation/foundation/nsstring
* https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/stringsClusters.html



