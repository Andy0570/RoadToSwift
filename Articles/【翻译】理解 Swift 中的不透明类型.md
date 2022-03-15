> 原文：[Understanding opaque types in Swift](https://tanaschita.com/20220206-understanding-opaque-types-in-swift/)
>
> 了解如何在 Swift 和 SwiftUI 中使用不透明的返回类型。



Swift 5.1 引入了一种新的语言特性，称为不透明类型（opaque types）。不透明类型使我们能够返回具体类型而无需公开它。让我们直接跳到一个例子来看看这意味着什么。

假设我们有一个名为 `Tea` 的协议。想象一下，不同种类的茶可能有不同的标识符类型，比如 `String` 或 `Int`，所以我们添加了一个名为 `Identifier` 的关联类型。

```swift
protocol Tea {
    associatedtype Identifier
    var id: Identifier { get }
}
```

使用这个协议，我们现在可以构建具体的茶类型，例如 `GreenTea`。

```swift
struct GreenTea: Tea {
    let id: String
    init(id: String) {
        self.id = id
    }
}
```

现在，我们要构建一个方法，返回商店中当前最受欢迎的茶。由于将来可能会改变，我们不想返回具体的茶类型，所以我们决定返回协议。

```swift
// 获取商店中当前最受欢迎的茶
func favoriteTea() -> Tea {
    return GreenTea(id: "someId")
}
// Protocol 'Tea' can only be used as a generic constraint because it has Self or associated type requirements
```

上面的方法不会编译，错误 `Protocol Tea can only be used as a generic constraint because it has Self or associated type requirements（Protocol Tea 只能用作泛型约束，因为它具有 Self 或关联类型需求）`。当使用协议作为返回类型时，编译器不会保留返回值的类型标识，因此我们不能以这种方式使用协议。

这就是不透明类型派上用场的地方：

```swift
// 获取商店中当前最受欢迎的茶
func favoriteTea() -> some Tea {
    return GreenTea(id: "someId")
}
```

正如我们在上面看到的，不透明类型是用 `some` 关键字定义的。返回一个不透明类型几乎就像返回一个协议。在这两种情况下，调用者都看不到具体类型。不同之处在于，与协议不同，不透明类型仍然指的是特定类型。

但是，当使用不透明的返回类型时，我们不能返回不同的类型，例如取决于其他一些值。我们可以使用没有关联类型的协议来做到这一点。

```swift
func favoriteTea() -> some Tea {
    someCondition ?  GreenTea(id: "someId") : AppleTea(id: 256783)
}
// Compiler error.
```

这会导致编译器错误 `Function declares an opaque return type, but the return statements in its body do not have matching underlying types（函数声明了一个不透明的返回类型，但其主体中的返回语句没有匹配的基础类型）`。不过，我们仍然可以返回相同具体类型的不同茶。

### SwiftUI 中的不透明类型

您可能已经注意到 SwiftUI 使用不透明的返回类型来构建视图。

```swift
var body: some View {
}
```

这样，SwiftUI 可以防止视图层次结构的确切类型信息能够执行诸如差异之类的任务。同时，我们不需要指定这个视图层次结构的确切类型——这可能会变得相当复杂。

在 SwiftUI 中使用不透明类型时，您可能已经偶然发现了前面提到的问题。

```swift
private var nameView: some View {
    if isEditable {
        return TextField("Your name", text: $name)
    } else {
        return Text(name)
    }
}
```

上面的代码无法编译，并出现错误消息 `Function declares an opaque return type, but the return statements in its body do not have matching underlying types`。这篇关于如何避免在 SwiftUI 中使用 `AnyView` 的文章介绍了我们如何仍然可以使用条件语句构建视图层次结构的解决方案。









