## Chisel

[Chisel](https://github.com/facebook/chisel) 是一个 LLDB 命令的集合，用于协助调试 iOS 应用程序。

要全面概述 LLDB，以及了解 Chisel 如何完善它，请阅读 Ari Grant 的文章 [与调试器共舞 - LLDB 的华尔兹](https://objccn.io/issue-19-2/) ，见 [objc.io](https://objccn.io/) 第19期。

## 安装

```bash
brew update
brew install chisel
```

如果 `.lldbinit` 文件不存在，你可以通过打开 terminal 终端创建并打开它：

```bash
touch .lldbinit                                                               open .lldbinit
```

然后将以下行添加到 `~/. lldbinit` 文件中：

```bash
# ~/.lldbinit
...
command script import /usr/local/opt/chisel/libexec/fbchisellldb.py
```

或者，下载 chisel 并在你的 `~/.ldbinit` 文件中添加以下一行：

```bash
# ~/.lldbinit
...
command script import /path/to/fbchisellldb.py
```

这些命令将在下次Xcode启动时可用。

## 命令

有许多命令，这里列出部分。完整的命令请参考 [Wiki](https://github.com/facebook/chisel/wiki)

| 命令            | 描述                                                     |
| --------------- | ------------------------------------------------------- |
| pviews          | 打印 key window 下视图的递归描述                             |
| pvc             | 打印 key window 下视图控制器的递归描述                       |
| visualize       | 在 Mac 上的「预览」应用中显示 `UIImage`、`CGImageRef`、`UIView`、`CALayer`、图片信息的 `NSData`、`UIColor`、`CIColor` 或 `CGColorRef` |
| fv              | 在层次结构中查找类名与提供的 regex 匹配的视图                |
| fvc             | 在层次结构中查找类名与提供的 regex 匹配的视图控制器          |
| show/hide       | 显示或隐藏给定的视图或图层                                   |
| mask/unmask     | 用一个透明的矩形覆盖一个视图或图层，使其可视化               |
| border/unborder | 为视图或图层添加边框，使其可视化                             |
| caflush         | 重新渲染（如果在动画过程中执行该命令，就直接渲染出动画结束效果） |
| bmessage        | 在类方法或实例方法上设置符号断点，而不必担心层次结构中的哪个类实际实现了该方法。 |
| wivar           | 在一个对象的实例变量上设置观察点                             |
| presponder      | 打印指定对象的响应链                                       |



## 自定义命令

您可以添加本地的自定义命令：

```bash
#!/usr/bin/python
# Example file with custom commands, located at /magical/commands/example.py

import lldb
import fbchisellldbbase as fb

def lldbcommands():
  return [ PrintKeyWindowLevel() ]
  
class PrintKeyWindowLevel(fb.FBCommand):
  def name(self):
    return 'pkeywinlevel'
    
  def description(self):
    return 'An incredibly contrived command that prints the window level of the key window.'
    
  def run(self, arguments, options):
    # It's a good habit to explicitly cast the type of all return
    # values and arguments. LLDB can't always find them on its own.
    lldb.debugger.HandleCommand('p (CGFloat)[(id)[(id)[UIApplication sharedApplication] keyWindow] windowLevel]')
```

然后剩下的就是在 `lldbinit` 中添加寻找该命令的源代码。在 `fbobjclldb.py` 模块中有一个专门针对这一点的 python 函数 `loadCommandsInDirectory`。

```bash
# ~/.lldbinit
...
command script import /path/to/fbobjclldb.py
script fbobjclldb.loadCommandsInDirectory('/magical/commands/')
```

还有内置的支持，可以非常容易地指定命令采用的参数和选项。查看例如使用的 `border` 和 `pinvocation` 命令。

