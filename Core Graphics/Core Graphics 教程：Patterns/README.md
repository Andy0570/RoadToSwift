参考：

[Core Graphics Tutorial: Patterns](https://www.raywenderlich.com/21462527-core-graphics-tutorial-patterns)

阅读难度：⭐️⭐️⭐️⭐️



**Core Graphics** 是一组功能强大且友好的 API，用于在 UIKit 应用程序中进行绘图。除了 shape 和 gradient 等基元之外，使用 Core Graphics，您还可以编写 pattern。**Core Graphics Pattern** 是可以平铺以填充区域的任意图形操作集。您可以使用重复的形状为您的应用程序创建华丽的背景。**Core Graphics Pattern** 是一种缩放绘图以填充屏幕上任何形状的高效方式。



### 使用 Pattern 时考虑性能

Core Graphics Pattern 非常快。你可以使用以下几个选项来绘制 pattern：

* 使用你在本教程中完成的 Core Graphics pattern API。
* 使用 UIKit 包装器方法，例如 `UIColor (patternImage:)`。
* 通过在一个 loop 循环中调用 Core Graphics 方法绘制所需的 pattern。

如果你的 pattern 只需要绘制一次，那么 UIKit 包装器方法是最简单的。它的性能也应该可以与底层的 Core Graphics 调用相媲美。何时使用它的一个示例是绘制静态背景图案。

Core Graphics 可以在后台线程中工作，这与在主线程上运行的 UIKit 不同。 Core Graphics pattern 在复杂的绘图或动态模式下性能更高。

在循环中绘制 pattern 是最慢的选择。 Core Graphics pattern 只进行一次绘制调用并缓存结果，从而提高效率。





