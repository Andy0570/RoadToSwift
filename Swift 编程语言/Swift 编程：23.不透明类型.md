具有**不透明返回类型**的函数或方法会**隐藏返回值的类型信息**。函数不再提供具体的类型作为返回类型，而是根据它支持的协议来描述返回值。

在处理模块和调用代码之间的关系时，隐藏类型信息非常有用，因为返回的底层数据类型仍然可以保持私有。而且不同于返回协议类型，不透明类型能保证类型一致性 —— 编译器能获取到类型信息，同时模块使用者却不能获取到。



## 不透明类型解决的问题


```swift
protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    // draw() 函数的功能是：绘制 ASCII 符号构成的几何图形
    func draw() -> String {
        var result = [String]()
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())
//    *
//    **
//    ***


// 利用泛型来实现垂直翻转之类的操作
// 局限：翻转操作的结果会暴露我们用于构造结果的泛型类型<T: Shape>：
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())
//    ***
//    **
//    *


// 定义一个 JoinedShape<T: Shape, U: Shape> 结构体，能将几何图形垂直拼接起来
// 它也暴露了构造所用的具体类型，泄露了类型信息
struct JoinedShaped<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}


/**
 模块调用者不必要知道函数执行的内部逻辑和类型信息，如 smallTriangle、flippedTriangle
 */
let joinedTriangles = JoinedShaped(top: smallTriangle, bottom: flippedTriangle)
//print(joinedTriangles.draw())
//    *
//    **
//    ***
//    ***
//    **
//    *

```


## 返回一个不透明类型


**你可以认为不透明类型和泛型相反**。泛型允许调用一个方法时，为这个方法的形参和返回值指定一个与实现无关的类型。举个例子，下面这个函数的返回值类型就由它的调用者决定：

```swift
func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
```

不透明类型允许函数实现时，选择一个与调用代码无关的返回类型。

```swift
// 下面的例子返回了一个梯形，却没有直接输出梯形的底层类型
struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

// 该函数返回遵循 Shape 协议的给定类型，而不需指定任何具体类型。
func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}

let trapezoid = makeTrapezoid()
print(trapezoid.draw())
```

这样写 `makeTrapezoid()` 函数可以表明它公共接口的基本性质 —— 返回的是一个几何图形 —— 而不是部分的公共接口生成的特殊类型。上述实现过程中使用了两个三角形和一个正方形，还可以用其他多种方式重写画梯形的函数，都不必改变返回类型。



## 不透明类型和协议类型的区别

虽然使用不透明类型作为函数返回值，看起来和返回协议类型非常相似，但这两者有一个主要区别，就在于**是否需要保证类型一致性**。

一个不透明类型只能对应一个具体的类型，即便函数调用者并不能知道是哪一种类型；协议类型可以同时对应多个类型，只要它们都遵循同一协议。

总的来说，协议类型更具灵活性，底层类型可以存储更多样的值，而不透明类型对这些底层类型有更强的限定。


比如，这是 `flip(_:)` 方法不采用不透明类型，而采用**返回协议类型**的版本：


```swift
func protoFlip<T: Shape>(_ shape: T) -> Shape {
    return FlippedShape(shape: shape)
}
```

