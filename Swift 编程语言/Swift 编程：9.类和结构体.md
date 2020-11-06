## 类与结构体的对比

在 Swift 中类和结构体有很多共同之处，它们都能：

* 定义属性用来存储值；
* 定义方法用于提供功能；
* 定义下标脚本用来允许使用下标语法访问值；
* 定义初始化器用于初始化状态；
* 可以被扩展来默认所没有的功能；
* 遵循协议来针对特定类型提供标准功能。

类有而结构体没有的额外功能：

* 继承允许一个类继承另一个类的特征；
* 类型转换允许你在运行检查和解释一个类实例的类型；
* 反初始化器允许一个类实例释放任何其所被分配的资源；
* 引用计数允许不止一个对类实例的引用。

### 定义语法

使用关键字 `struct` 定义结构体，使用关键字 `class` 定义类，并将它们的具体定义放在一对大括号中：

```swift
struct SomeStructure {
    // 在这里定义结构体
}
class SomeClass {
    // 在这里定义类
}
```

以下是定义结构体和定义类的示例：

```swift
// 定义结构体，描述一个基于像素的显示器分辨率
struct Resolution {
    var width = 0;
    var height = 0;
}

// 定义类，描述一个视频显示的特定视频模式
class VideoMode {
    var resolution = Resolution()
    var interlaced = false // Bool 类型，是否隔行扫描视频
    var frameRate = 0.0    // 回放帧率
    var name: String?      // 视频名称，可选项 String 类型。
}

// 通过初始化器语法创建结构体和类的实例
let someResolution = Resolution()
let someVideoMode = VideoMode()

// 结构体类型的成员初始化器
let vga = Resolution(width: 640, height: 480)
```


💡 结构体和枚举是值类型，类是引用类型。




