## LLDB

LLDB Debugger（LLDB，low level debugger）是一个开源、底层调试器，具有 REPL（Read-Eval-Print Loop，交互式解释器）、C++ 和 Python 插件，位于 Xcode 窗口底部控制台中，也可以在 terminal 中使用。具有流向控制（flow control）和数据检查（data inspection）功能。

LLDB 使用了 LLVM 项目中的一些组件，如编译器、解释器、构建器等。LLDB 是非常强大的工具，可以输出代码中的变量，访问 macOS 系统底层的 Unix，进行个性化配置等，且整个过程无需终止会话。

随着 Xcode 5 的发布，LLDB 已经取代了 GDB，成为了 Xcode 工程中默认的调试器。

---

LLDB 是新一代高性能调试器。它构建为一组可重用的组件，可以高度利用较大的 LLVM 项目中的现有库，例如 Clang 表达式解析器和 LLVM 反汇编程序。

LLDB 是 Mac OS X 上 Xcode 的默认调试器，支持在桌面和 iOS 设备和模拟器上调试 C，Objective-C 和 C ++。
LLDB 项目中的所有代码都是在标准 LLVM 许可证下提供的，这是一种开源的“BSD 风格”许可证。

---


### LLDB 命令

命令列表参考：<https://lldb.llvm.org/use/map.html>

```bash
<command> [<subcommand>...] [--<option> [<option-value>]]... [argument]...
<命令名称> <命令动作> [--可选项 [可选项的值]] [参数1 [参数2...]]
```

命令                     | 描述 
---------------- | ---------------
break NUM               | 在指定的行上设置断点。
bt                      | 显示所有的调用栈帧。该命令可用来显示函数的调用顺序。
clear                   | 删除设置在特定源文件、特定行上的断点。其用法为：clear FILENAME:NUM。
continue                | 继续执行正在调试的程序。该命令用在程序由于处理信号或断点而导致停止运行时。
display EXPR            | 每次程序停止后显示表达式的值。表达式由程序定义的变量组成。
file FILE               | 装载指定的可执行文件进行调试。
help NAME               | 显示指定命令的帮助信息。
info break              | 显示当前断点清单，包括到达断点处的次数等。
info files              | 显示被调试文件的详细信息。
info func               | 显示所有的函数名称。
info local              | 显示当函数中的局部变量信息。
info prog               | 显示被调试程序的执行状态。
info var                | 显示所有的全局和静态变量名称。
kill                    | 终止正被调试的程序。
list                    | 显示源代码段。
make                    | 在不退出 gdb 的情况下运行 make 工具。
next                    | 在不单步执行进入其他函数的情况下，向前执行一行源代码。
print EXPR              | 显示表达式 EXPR 的值。
print-object            | 打印一个对象
print (int) name        | 打印一个类型
print-object [artist description]   | 调用一个函数
set artist = @"test"    | 设置变量值



### 输出变量

当程序停止在 breakpoint 后，我们就可以控制其下一步执行的命令。LLDB 提供了以下三种输出变量方法：

命令 | 是否运行代码 | 输出格式
 -- | -- | -- 
expression -- 简写为 p、print | YES | 默认格式
expression -O — 简写为 po | YES | 若存在自定义格式，以自定义格式输出。否则，使用默认格式输出。
frame variable 简写为 f v | NO | 默认格式



### `expression` 命令

`expression` 命令在当前线程验证表达式，并使用 LLDB 默认格式显示结果。

语法：`expression <cmd-options> -- <expr>`

```bash
# 输出变量值
(lldb) expression count
# 修改变量值
(lldb) expression count = 10
# 执行 string 的拼接方法
(lldb) expression [string stringByAppendingString:@"string"]
# 修改 view 的颜色
(lldb) expression self.view.backgroundColor = [UIColor redColor]
(lldb) expression [CATransaction flush]

# 输出视图层次结构，并更新指定视图颜色
(lldb) po [[[UIApplication sharedApplication] keyWindow] recursiveDescription]
(lldb) po [[[[UIApplication sharedApplication] delegate] window] recursiveDescription]
(lldb) e id $myView = (id)0x1093044e0
(lldb) e (void)[$myView setBackgroundColor:[UIColor blueColor]]
(lldb) e (void)[CATransaction flush]

# 获取根视图控制器
(lldb) e id $nvc = [[[UIApplication sharedApplication] keyWindow] rootViewController]

# 查找按钮的 target
(lldb) e id $myButton = (id)0x109304650
(lldb) po [$myButton allTargets]
	{(
		<HQLRegixViewController: 0x109608c40>,
	)}
(lldb) po [$myButton actionsForTarget:(id)0x109608c40 forControlEvent:0]
<__NSArrayM 0x2803d3990>(
testButtionAction:
)
```

### `print` 命令
`print` 命令输出变量，它是 `expression --` 的缩写

```bash
(lldb) print <expr>
(lldb) p <expr>
(lldb) expression -- <expr>
(lldb) e -- <expr>

# 调用对象的 description 方法
# 输出变量 someVariable 的描述信息
(lldb) expression --object-description -- someVariable
(lldb) e -O -- someVariable
(lldb) po someVariable

# 输出当前 view 信息
(lldb) po [self view]
<UIView: 0x1093044e0; frame = (0 0; 375 812); autoresize = RM+BM; layer = <CALayer: 0x280d89300>>
```

### `frame variable` 命令，可简写为 `f v`

`frame variable` 命令显示当前堆栈的变量。默认输出当前堆栈所有参数和所有局部变量。

语法：`frame variable <cmd-option> [<variable-name> ...]`

```
(lldb) frame variable
```


### `thread` 线程

语法：`thread <subcommand> [<subcommand-options>]`

```bash
# 程序通常在多个线程同时执行代码，获取当前线程所在处理器线程列表
(lldb) thread list

# Backtrace 回溯，查看线程堆栈信息
(lldb) thread backtrace
(lldb) thread backtrace all
```

### 通知中心

```bash
(lldb) p NSNotificationCenter.defaultCenter().debugDescription
(String) $R10 = "<NSNotificationCenter:0x134e0cb10>\nName, Object, Observer,  Options
UIAccessibilityForceTouchSensitivityChangedNotification, 0x19b0bbb60, 0x134d5d2e0, 1400
UIAccessibilityForceTouchSensitivityChangedNotification, 0x19b0bbb60, 0x134d605f0, 1400
...
UIContentSizeCategoryDidChangeNotification, 0x19b0bbb60, 0x134e5c2a0, 1400"

# 增加控制台输出字符串的最大长度
(lldb) set set target.max-string-summary-length 50000
```

### 查看 frame 的值

需要导入 `UIKit` 框架：

```bash
(lldb) e @import UIKit
(lldb) p self.view.frame
(CGRect) $0 = (origin = (x = 0, y = 0), size = (width = 375, height = 667))

(lldb) print (CGRect)[view frame]
(CGRect) $1 = (origin = (x = 0, y = 0), size = (width = 200, height = 100))
```



### 更新 UI 视图的背影颜色

```bash
(lldb) expr self.view.backgroundColor = UIColor.red 
(lldb) continue
```




### 格式化输出数据

#### 1. 封装 log 函数

Swift:

```swift
func DLog<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) { 
    #if DEBUG 
        print("<\((file as NSString).lastPathComponent) : \(line)>, \(method) \(message)")
    #endif
}
```

Objective-C:

```objc
#ifdef __Objective-C__

// 开发模式下打印日志，否则不打印
#ifdef DEBUG
  #define NSSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
  #define NSSLog(...)
#endif

#endif
```

#### 2. 代替 `NSLog()`，打印对象的内部属性

![](https://tva1.sinaimg.cn/large/008i3skNgy1gwcf8tomftj30tu0ez415.jpg)



### 添加异常断点（Exception Breakpoint）

让调试器为导致应用崩溃或引发异常的那行代码自动设置断点。并添加一个 Action：

```bash
po $arg1
```

![](https://tva1.sinaimg.cn/large/008i3skNgy1gwcgmhv85hj30d807vdg4.jpg)

### 添加符号断点（Symbolic Breakpoint）

Symbolic Breakpoint 为符号断点，可以针对某一个方法 (函数) 设置断点并暂停执行；有时候，我们并不清楚会在什么情况下调用某一个函数，那我们可以通过符号断点来跟踪获取调用该函数的程序堆栈。

示例，为 CoreText 框架的 `CTFontLogSystemFontNameRequest` 函数设置符号断点：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gwdjfq4eoaj30d806j3yr.jpg)


### 解决 CUICatalog: Invalid asset name supplied: (null) 问题

参考：<https://stackoverflow.com/questions/22011106/error-cuicatalog-invalid-asset-name-supplied-null-or-invalid-scale-factor>

当调用 `[UIImage imageNamed:]` 方法时，可能存在图片不存在或者传入的图片名为 nil。就可以通过添加符号断点（Symbolic Breakpoint）解决该问题：

Symbol 设置为：`[UIImage imageNamed:]` 捕获需要拦截的方法。

Condition 设置为：`[(NSString*)$x2 length] == 0` 判断方法传入参数字符串长度是否为 0 或者为 `nil`。

![](https://tva1.sinaimg.cn/large/008i3skNgy1gwdjojzv9fj30d806jaac.jpg)

### 解决视图布局约束歧义问题

![](https://tva1.sinaimg.cn/large/008i3skNgy1gwdjtegoe4j30d80803yt.jpg)



1. 添加 Symbolic Breakpoint 符号断点，`UIViewAlertForUnsatisfiableConstraints`
2. Action 设置：

```bash
# Objective-C
po [[UIWindow keyWindow] _autolayoutTrace]

# Swift
expr -l objc++ -O -- [[UIWindow keyWindow] _autolayoutTrace]
```

`_autolayoutTrace ` 用于查找存在的 Ambiguous Layouts.

3. 显示自动布局存在问题的视图：

```bash
expr ((UIView *)0x282f46210).backgroundColor = [UIColor redColor]

expression ((UIView *)address).backgroundColor = [UIColor redColor]
```




## 其他工具

[chisel](https://github.com/facebook/chisel)，⭐️8.7K - FaceBook 开源的 lldb 调试命令集合。

[FLEX](https://github.com/FLEXTool/FLEX)，⭐️12.6K - Flipboard 开源的一系列在应用中调试的工具集。

[lowmad](https://github.com/bangerang/lowmad)，一个用于管理 LLDB 中的脚本和配置的命令行工具。

@老峰：在开发调试中我们经常会使用 LLDB 命令 Debug，有时也有自定义 LLDB 命令的需求。lowmad 就是用于管理和生成 LLDB 脚本的命令行工具，它提供了简洁易用的命令来生成或安装脚本命令，另外作者开源了 lldb_commands 自定义 LLDB 命令，如 find_label、color、nudge 等，感兴趣的读者不妨来研究一哈。



## 参考

* [The LLDB Debugger](https://lldb.llvm.org/index.html)
* [GDB to LLDB command map](https://lldb.llvm.org/use/map.html)
* [与调试器共舞 - LLDB 的华尔兹](https://objccn.io/issue-19-2/) ⭐️
* [Dancing in the Debugger — A Waltz with LLDB](https://www.objc.io/issues/19-debugging/lldb-debugging/#poking-around-without-a-breakpoint)
* [用 LLDB 调试 Swift 代码](https://juejin.cn/post/6844903560291811335)⭐️
* [简书：iOS 常用调试方法：LLDB 命令@QiShare](https://www.jianshu.com/p/7d1ec700e903) ⭐️
* [OSChina：Xcode LLDB Debug 教程](https://my.oschina.net/notting/blog/115294)
* [Session 429 Beyond po](https://xiaozhuanlan.com/topic/5438071296)
* [二进制文件分析之常用命令](https://xiaozhuanlan.com/topic/8604312975)
* [iOS Crash 分析：符号化系统库方法](http://www.cocoachina.com/articles/897588?filter=ios)
* [iOS 常用调试方法：静态分析](https://www.jianshu.com/p/d0b9fd8ffadc)


