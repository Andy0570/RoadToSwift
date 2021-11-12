LLDB Debugger（LLDB，low level debugger）是一个开源、底层调试器，具有 REPL（Read-Eval-Print Loop，交互式解释器）、C++ 和 Python 插件，位于 Xcode 窗口底部控制台中，也可以在 terminal 中使用。具有流向控制（flow control）和数据检查（data inspection）功能。

LLDB 使用了 LLVM 项目中的一些组件，如编译器、解释器、构建器等。LLDB 是非常强大的工具，可以输出代码中的变量，访问 macOS 系统底层的 Unix，进行个性化配置等，且整个过程无需终止会话。

随着 Xcode 5 的发布，LLDB 已经取代了 GDB，成为了 Xcode 工程中默认的调试器。

---

LLDB 是新一代高性能调试器。它构建为一组可重用的组件，可以高度利用较大的 LLVM 项目中的现有库，例如 Clang 表达式解析器和 LLVM 反汇编程序。

LLDB 是 Mac OS X 上 Xcode 的默认调试器，支持在桌面和 iOS 设备和模拟器上调试 C，Objective-C 和 C ++。
LLDB 项目中的所有代码都是在标准 LLVM 许可证下提供的，这是一种开源的“BSD 风格”许可证。

---



### LLDB 命令结构

```bash
<command> [<subcommand>...] [--<option> [<option-value>]]... [argument]...
<命令名称> <命令动作> [--可选项 [可选项的值]] [参数1 [参数2...]]
```

### 输出变量

当程序停止在 breakpoint 后，我们就可以控制其下一步执行的命令。LLDB 提供了以下三种输出变量方法：

命令 | 是否运行代码 | 输出格式
 -- | -- | -- 
expression -- 简写为 p、print | YES | 默认格式
expression -O — 简写为 po | YES | 若存在自定义格式，以自定义格式输出。否则，使用默认格式输出。
frame variable 简写为 f v | NO | 默认格式



### lowmad

<https://github.com/bangerang/lowmad>


@老峰：在开发调试中我们经常会使用 LLDB 命令 Debug，有时也有自定义 LLDB 命令的需求。lowmad 就是用于管理和生成 LLDB 脚本的命令行工具，它提供了简洁易用的命令来生成或安装脚本命令，另外作者开源了 lldb_commands 自定义 LLDB 命令，如 find_label、color、nudge 等，感兴趣的读者不妨来研究一哈。






### 参考

* [The LLDB Debugger](https://lldb.llvm.org/index.html)
* [GDB to LLDB command map](https://lldb.llvm.org/use/map.html)
* [与调试器共舞 - LLDB 的华尔兹](https://objccn.io/issue-19-2/) ⭐️
* [Dancing in the Debugger — A Waltz with LLDB](https://www.objc.io/issues/19-debugging/lldb-debugging/#poking-around-without-a-breakpoint)
* [简书：iOS 常用调试方法：LLDB 命令@QiShare](https://www.jianshu.com/p/7d1ec700e903) ⭐️
* [OSChina：Xcode LLDB Debug 教程](https://my.oschina.net/notting/blog/115294)
* [Session 429 Beyond po](https://xiaozhuanlan.com/topic/5438071296)
* [二进制文件分析之常用命令](https://xiaozhuanlan.com/topic/8604312975)
* [iOS Crash 分析：符号化系统库方法](http://www.cocoachina.com/articles/897588?filter=ios)
* [iOS 常用调试方法：静态分析](https://www.jianshu.com/p/d0b9fd8ffadc)
