### 参考

* [[译] Xcode 和 LLDB 高级调试教程：第 1 部分](https://juejin.cn/post/6844903871756828686)

* [[译] Xcode 和 LLDB 高级调试教程：第 2 部分](https://juejin.cn/post/6844903885321011213)

* [[译] Xcode 和 LLDB 高级调试教程：第 3 部分](https://juejin.cn/post/6844903896368824334)

* [[译] 用 LLDB 调试 Swift 代码](https://juejin.cn/post/6844903560291811335)

* [[译] 断点：像专家一样调试代码](https://juejin.cn/post/6844903558366625805)

  




---

[Introduction to Xcode Frame Debug - A Sherlock Holmes Adventure](https://holyswift.app/introduction-to-xcode-frame-debug-a-sherlock-holmes-adventure)

在 iOS 开发过程中经常要和 View 打交道，难免会遇到 View 显示异常的问题。本文从 Xcode Debug View 工具入手，介绍了几种调试 View 不显示的线索，主要包括：

* 检查 View 是否在父视图上
* 检查 `alpha` 属性
* 检查 `hidden` 属性
* 检查 `frame` 是否超出父视图

这几种方式都比较常规。最后还介绍了一个小技巧，遇到设置了 `clipsToBounds = true` 的父视图，通过 *Show Clipped Content* 能显示被裁切的子视图。

