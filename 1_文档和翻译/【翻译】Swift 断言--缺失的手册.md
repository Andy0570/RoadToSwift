> 原文：[Swift asserts - the missing manual](https://blog.krzyzanowskim.com/2015/03/09/swift-asserts-the-missing-manual/)

> **断言（assertion）** - 对事实或信仰的一种自信而有力的陈述。积极地宣布或陈述的事物，往往没有任何支持或证明。

断言是很好的[调试工具](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID335)。每当我需要检查我的代码是否符合预期时，我可以使用断言，然后异常将被抛出或（应用）终止运行。

标准的 Swift 库有五个断言函数，它们在影响代码的执行流程上各有千秋：

1. `assert()`
2. `assertionFailure()`
3. `precondition()`
4. `preconditionFailure()`
5. `fatalError()`


我不会在这里讨论 `NSAssert` 系列，因为它依赖于 Cocoa Foundation，与 Swift 本身的联系不是那么紧密。



## assert()

从 C 语言中得知，`assert()` 是我遇到的第一个断言。正如预期的那样，`assert()` 只在调试模式下运行（这是编程语言中对断言的一般规则）。

例如：

当函数 `transformString()` 接收到空的可选类型时，将意料之外的 `nil` 追加到字符串将导致应用程序终止运行，正如预期的那样，应用程序将直接崩溃：

```swift
func transformString(string: String?) -> String {
    return string! + "_transforme" // expected error if string == nil
}
```

但是，我可以在我的代码中明确地添加检查，这样它就会在可控条件下失败。使用 `assert()`，我可以检查是否满足所需的条件，如果不满足，立即向开发人员报告问题：

```swift
func transformString(string: String?) -> String {
    assert(string != nil, "Invalid parameter") // 这里
    return string! + "_transforme"
}
```

断言终止表明我的代码遇到了一个错误，或者发生了未处理的情况，我需要调查原因。

这种检查可以用来标记 "程序员的错误"，这就是为什么它**只在调试版本中被检查**。对于发布版本，带有 `assert()` 的行被省略了（条件没有被评估），因此， `transformString()` 的行为是 undefined（无论如何，这个会崩溃，但一般来说，它就是 undefined）。



## Debug 还是 Release?

基于此，重要的是要知道什么选项决定了构建是 Debug 模式还是 Release 模式？对于 Swift 来说，这取决于 **SWIFT_OPTIMIZATION_LEVEL** 设置：

![](https://blog.krzyzanowskim.com/content/images/2015/03/SWIFT_OPTIMIZATION_LEVEL-1.png)

```swift
SWIFT_OPTIMIZATION_LEVEL = -Onone 	   // debug
SWIFT_OPTIMIZATION_LEVEL = -O          // release
SWIFT_OPTIMIZATION_LEVEL = -Ounchecked // unchecked release
```

==注意==：将 `GCC_PREPROCESSOR_DEFINITIONS` 设置为 `DEBUG`，`ENABLE_NS_ASSERTIONS` 在这里不重要。



## assertionFailure()

`assertionFailure()` 的名字与 `assert()` 相似，但不能混淆。主要区别是 `assertionFailure()` 向编译器提示，在这里，给定的上下文（"if"分支，或函数上下文）结束，使其 `@noreturn` 有效。在调试模式下，应用程序将直接终止，但在发布模式下，行为是未定义的。这就是为什么编译器警告说 `assertionFailure()` 后面的代码==将永远不会被执行==。

![](https://blog.krzyzanowskim.com/content/images/2015/03/assertionFailure-1.png)

```swift
func tassertionFailure() {
    assertionFailure("nope")
    print("ever")
}
```



## precondition()

`precondition()` 确保给定的条件得到满足。如果条件没有得到满足，应用程序将被终止。这比简单的 `assert()` 更重要。条件在调试和发布版本中均被检查。

```swift
func tprecodition() {
    precondition(1 == 2, "not equal")
    print("not equal") // will never be executed
}
```

对于未检查的优化级别（unchecked optimization level, -Ounchecked），编译器将假定该条件总是被满足。



## preconditionFailure()

`preconditionFailure()` 意味着致命的错误。这与 `assertionFailure()` 类似，唯一的区别是 `preconditionFailure()` 会放出陷阱，而 `assertionFailure()` 不会。在这种情况下，应用程序将终止调试和发布版本的编译，而会编译未检查的发布版本（见下面的注意事项）：

```swift
func tpreconditionFailure() {
    preconditionFailure("fatal error")
    print("not") // will never be executed
}
```

==注意==。对于未检查的编译，编译器可能认为这个函数永远不会被调用。所以如果你决定采用未检查的编译方式，那么最好使用 `fatalError()`。



##### 陷阱在哪里 ?

我没能从 `preconditionFailure()` 中捕捉到 `SIGTRAP`。它应该是被触发的，但我无法观察到它。我试着拆解`preconditionFailure()` 和 `assertionFailure()`，两者看起来非常相似（这是 Hopper 的代码）。

```swift
func tpreconditionFailure()
```

```swift
int __TF6result20tpreconditionFailureFT_T_() {
    rax = _TFSSCfMSSFT21_builtinStringLiteralBp8byteSizeBw7isASCIIBi1__SS();
    var_18 = 0x1;
    var_20 = rcx;
    var_28 = "AssertionPlayground.playground/contents.swift";
    var_30 = LODWORD(0x2d);
    var_38 = LODWORD(0x18);
    _TTSf4s_s_s_s___TFSs16_assertionFailedFTVSs12StaticStringSSS_Su_T_("fatal error", LODWORD(0xb), LODWORD(0x2), rax, var_18, var_20, var_28, 0x2d, 0x2, 0x18);
    rax = (*_TFSSCfMSSFT21_builtinStringLiteralBp8byteSizeBw7isASCIIBi1__SS)();
    return rax;
}
```

```swift
func tpreconditionFailure()
```

```swift
int __TF6result17tassertionFailureFT_T_() {
    rax = _TFSSCfMSSFT21_builtinStringLiteralBp8byteSizeBw7isASCIIBi1__SS();
    var_18 = 0x1;
    var_20 = rcx;
    var_28 = "AssertionPlayground.playground/contents.swift";
    var_30 = LODWORD(0x2d);
    var_38 = LODWORD(0x1d);
    _TTSf4s_s_s_s___TFSs16_assertionFailedFTVSs12StaticStringSSS_Su_T_("fatal error", LODWORD(0xb), LODWORD(0x2), rax, var_18, var_20, var_28, 0x2d, 0x2, 0x1d);
    rax = (*_TFSSCfMSSFT21_builtinStringLiteralBp8byteSizeBw7isASCIIBi1__SS)();
    return rax;
}
```

两者似乎都调用了相同的`_TTSf4s_s_s___TFSs16_assertionFailedFTVSs12StaticStringSSS_Su_T_`。事实上，我不能说我是对的，还是我错过了更大的东西，我只能说我不能用 Xcode 6.3(6D532l) 捕获到陷阱。

## CheatSheet

|                       | debug  | release | release     |
| :-------------------- | :----- | :------ | :---------- |
| function              | -Onone | -O      | -Ounchecked |
| assert()              | YES    | NO      | NO          |
| assertionFailure()    | YES    | NO      | NO**        |
| precondition()        | YES    | YES     | NO          |
| preconditionFailure() | YES    | YES     | YES**       |
| fatalError()*         | YES    | YES     | YES         |

YES - 方法执行，如果条件评估失败，则终止应用运行。 
NO - 方法不会执行，也不会终止应用运行。
`*` 不是真正的断言，它被设计为总是终止代码的执行，不管是什么。
`**` 编译器可以假设这个函数永远不会被调用。



## 总结

断言你的代码是一个好的做法。总是这样。对于 Swift，你必须明智地选择哪种断言技术是合适的，除非你想伤害自己。牢记每一个断言对调试和发布版本的后果是什么。在提交给 App Store 之前，一定要对发布版本的质量进行保证。
