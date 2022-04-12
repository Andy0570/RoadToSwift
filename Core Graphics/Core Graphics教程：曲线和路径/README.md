参考：

* [Core Graphics Tutorial: Arcs and Paths](https://www.raywenderlich.com/349664-core-graphics-tutorial-arcs-and-paths)

* [Apple: Quartz 2D Programming Guide](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007533-SW1)



在本教程中，您将学习如何绘制曲线和路径。特别是，您将通过在底部添加整齐的曲线、线性渐变和适合曲线弧度的阴影来增强分组列表的每个 footer。所有这一切都是通过使用 Core Graphics 的力量实现的！



### [相交弦定理](https://www.mathopenref.com/chordsintersecting.html)

当两个弦在一个圆内相交时，它们的线段的乘积相等。

![](https://www.mathopenref.com/images/chordsintersecting/chords.gif)

每个弦在它们相交的地方被切成两段。一根弦被切割成两条线段 A 和 B。另一根弦被切割成线段 C 和 D。

$$
A * B = C * D
$$


根据相交弦定理，已知 a、b、c 的长度，就可以求出 d 的长度，继而可以得到圆的半径：
$$
r = (c+d)/2
$$
<img src="https://koenig-media.raywenderlich.com/uploads/2018/12/arcs-and-paths-to-be-cords.png" style="zoom: 50%;" />

