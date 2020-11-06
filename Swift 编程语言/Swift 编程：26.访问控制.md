**访问控制**可以限定其它源文件或模块对你的代码的访问。这个特性可以让你隐藏代码的实现细节，并且能提供一个接口来让别人访问和使用你的代码。

你可以明确地给单个类型（类、结构体、枚举）设置访问级别，也可以给这些类型的属性、方法、构造器、下标等设置访问级别。协议也可以被限定在一定访问级别的范围内使用，包括协议里的全局常量、变量和函数。

Swift 不仅提供了多种不同的访问级别，还为某些典型场景提供了**默认的访问级别**，这样就不需要我们在每段代码中都显式声明访问级别。如果你只是开发一个单 target 的应用程序，完全可以不用显式声明代码的访问级别。


## 模块和源文件

Swift 中的访问控制模型基于**模块**和**源文件**这两个概念。

**模块**指的是独立的代码单元，框架或应用程序会作为一个独立的模块来构建和发布。在 Swift 中，一个模块可以使用 `import` 关键字导入另外一个模块。

在 Swift 中，Xcode 的每个 target（例如框架或应用程序）都被当作独立的模块处理。如果你是为了实现某个通用的功能，或者是为了封装一些常用方法而将代码打包成独立的框架，这个框架就是 Swift 中的一个模块。当它被导入到某个应用程序或者其他框架时，框架的内容都将属于这个独立的模块。

**源文件**就是 Swift 模块中的源代码文件（实际上，源文件属于一个应用程序或框架）。尽管我们一般会将不同的类型分别定义在不同的源文件中，但是同一个源文件也可以包含多个类型、函数等的定义。

## 访问级别

Swift 为代码中的实体提供了五种不同的访问级别。这些访问级别不仅与源文件中定义的实体相关，同时也与源文件所属的模块相关。

* `open` 和 `public` 级别可以**让实体被同一模块源文件中的所有实体访问，在模块外也可以通过导入该模块来访问源文件里的所有实体**。通常情况下，你会使用 `open` 或 `public` 级别来指定框架的外部接口。`open` 和 `public` 的区别在后面会提到。
* `internal` 级别**让实体被同一模块源文件中的任何实体访问，但是不能被模块外的实体访问**。通常情况下，如果某个接口只在应用程序或框架内部使用，就可以将其设置为 `internal` 级别。
* `fileprivate` **限制实体只能在其定义的文件内部访问**。如果功能的部分实现细节只需要在文件内使用时，可以使用 fileprivate 来将其隐藏。
* `private` **限制实体只能在其定义的作用域，以及同一文件内的 `extension` 访问**。如果功能的部分细节只需要在当前作用域内使用时，可以使用 `private` 来将其隐藏。

`open` 为最高访问级别（限制最少），`private` 为最低访问级别（限制最多）。

`open` 只能作用于类和类的成员，它和 `public` 的区别主要在于 **`open` 限定的类和成员能够在模块外能被继承和重写**，在下面的 子类 这一节中有详解。将类的访问级别显式指定为 `open` 表明你已经设计好了类的代码，并且充分考虑过这个类在其他模块中用作父类时的影响。


### 访问级别的基本原则

Swift 中的访问级别遵循一个基本原则：**实体不能定义在具有更低访问级别（更严格）的实体中**。

例如：
* 一个 `public` 的变量，其类型的访问级别不能是 `internal`，`fileprivate` 或是 `private`。因为无法保证变量的类型在使用变量的地方也具有访问权限。
* 函数的访问级别不能高于它的参数类型和返回类型的访问级别。因为这样就会出现函数可以在任何地方被访问，但是它的参数类型和返回类型却不可以的情况。

### 默认访问级别

你代码中所有的实体，如果你不显式的指定它们的访问级别，那么它们将都有一个 `internal` 的默认访问级别，（有一些例外情况，本文稍后会有说明）。因此，多数情况下你不需要显示指定实体的访问级别。

### 单 target 应用程序的访问级别

当你编写一个单 target 应用程序时，应用的所有功能都是为该应用服务，而不需要提供给其他应用或者模块使用，所以你不需要明确设置访问级别，使用默认的访问级别 `internal` 即可。但是，你也可以使用 `fileprivate` 或 `private` 访问级别，用于隐藏一些功能的实现细节。

### 框架的访问级别

当你开发框架时，就需要把一些对外的接口定义为 `open` 或 `public` 访问级别，以便使用者导入该框架后可以正常使用其功能。这些被你定义为对外的接口，就是这个框架的 API。

### 单元测试 target 的访问级别

当你的应用程序包含单元测试 target 时，为了测试，测试模块需要访问应用程序模块中的代码。默认情况下只有 `open` 或 `public` 级别的实体才可以被其他模块访问。然而，如果在导入应用程序模块的语句前使用 `@testable` 特性，然后在允许测试的编译设置（**Build Options** -> **Enable Testability**）下编译这个应用程序模块，单元测试目标就可以访问应用程序模块中所有内部级别的实体。


## 访问控制语法

通过修饰符 `open`、`public`、`internal`、`fileprivate`、`private` 来声明实体的访问级别：

```swift
public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}
```


## 自定义类型

```swift
public class SomePublicClass {                  // 显式 public 类
    public var somePublicProperty = 0            // 显式 public 类成员
    var someInternalProperty = 0                 // 隐式 internal 类成员
    fileprivate func someFilePrivateMethod() {}  // 显式 fileprivate 类成员
    private func somePrivateMethod() {}          // 显式 private 类成员
}

class SomeInternalClass {                       // 隐式 internal 类
    var someInternalProperty = 0                 // 隐式 internal 类成员
    fileprivate func someFilePrivateMethod() {}  // 显式 fileprivate 类成员
    private func somePrivateMethod() {}          // 显式 private 类成员
}

fileprivate class SomeFilePrivateClass {        // 显式 fileprivate 类
    func someFilePrivateMethod() {}              // 隐式 fileprivate 类成员
    private func somePrivateMethod() {}          // 显式 private 类成员
}

private class SomePrivateClass {                // 显式 private 类
    func somePrivateMethod() {}                  // 隐式 private 类成员
}
```


### 元组类型

元组的访问级别将**由元组中访问级别最严格的类型来决定**。

例如，如果你构建了一个包含两种不同类型的元组，其中一个类型为 `internal`，另一个类型为 `private`，那么这个元组的访问级别为 `private`。


### 函数类型

函数的访问级别**根据访问级别最严格的参数类型或返回类型的访问级别来决定**。但是，如果这种访问级别不符合函数定义所在环境的默认访问级别，那么就需要明确地指定该函数的访问级别。


### 枚举类型

**枚举成员的访问级别和该枚举类型相同**，你不能为枚举成员单独指定不同的访问级别。


## 子类

你可以继承同一模块中的所有有访问权限的类，也可以继承不同模块中被 `open` 修饰的类。一个子类的访问级别不得高于父类的访问级别。例如，父类的访问级别是 `internal`，子类的访问级别就不能是 `public`。



## 常量、变量、属性、下标

常量、变量、属性不能拥有比它们的类型更高的访问级别。