泛型代码让你能根据自定义的需求，编写出适用于任意类型的、灵活可复用的函数及类型。你可避免编写重复的代码，而是用一种清晰抽象的方式来表达代码的意图。


### 泛型函数

创建泛型函数。

使用泛型函数交换两个任意类型的值：

```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
```

泛型版本的函数使用**占位符类型名**（这里叫做 `T` ），而不是 **实际类型名**（例如 `Int`、`String` 或 `Double`），**占位符类型名并不关心 `T` 具体的类型，但它要求 `a` 和 `b` 必须是相同的类型**，`T` 的实际类型由每次调用 `swapTwoValues(_:_:)` 来决定。


### 类型参数

上面 `swapTwoValues(_:_:)` 例子中，占位类型 `T` 是一个类型参数的例子，**类型参数**指定并命名一个占位类型，并且紧随在函数名后面，使用一对尖括号括起来（例如 `<T>`）

类型参数会在函数调用时被实际类型所替换。

你可提供多个类型参数，将它们都写在尖括号中，用逗号分开。

> 💡 
> 类型参数就是，在泛型函数中，用尖括号 `<>` 扩起来的首字母大写的参数。
> 相当于一个类型的占位符，声明的时候咱也不知道它是什么类型，它只是充当类似“形式参数”的作用，起一个占位符作用，因此可以用于任意类型，抽象程度高了，适用性就广。



### 命名类型参数

通常使用单个字符表示。

使用大写字母开头的驼峰命名法！



### 泛型类型

创建泛型类型。

除了**泛型函数**，Swift 还允许**自定义泛型类型**。这些自定义类、结构体和枚举可以适用于任意类型，类似于 `Array` 和 `Dictionary`。


**栈（Stack）** 是一个“后进先出”的有序集合。

```swift
// ----------------------------------
// 实现一个非泛型版本的栈，该版本只能处理 Int 类型
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// ----------------------------------
// 定义一个泛型 Stack 结构体，支持处理任意类型
// 用占位类型参数 <Element> 代替了实际的 Int 类型
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// 初始化一个 String 类型的 Stack 实例
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuasro")
// 栈中现在有 4 个字符串

let fromTheTop = stackOfStrings.pop()
// fromTheTop 的值为“cuatro”，现在栈中还有 3 个字符串
```


### 泛型扩展

为泛型类型添加扩展（`extension`）。

当对泛型类型进行扩展时，你并不需要提供类型参数列表作为定义的一部分。原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。


```swift
// 扩展泛型类型 Stack
extension Stack {
    // 添加一个只读计算属性，读取并返回当前栈顶元素
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
```



### 类型约束

为泛型类型添加约束条件。

`swapTwoValues(_:_:)` 函数和 `Stack` 适用于任意类型。不过，如果能**对泛型函数或在泛型类型中添加特定的类型约束**，这将在某些情况下非常有用。**类型约束**指定类型参数必须继承自指定类、遵循特定的协议或协议组合。

在一个类型参数名后面放置一个类名或者协议名，并用冒号进行分隔，来定义类型约束。下面将展示泛型函数约束的基本语法（与泛型类型的语法相同）：

```swift
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // 这里是泛型函数的函数体部分
}
```

上面这个函数有两个泛型类型参数。第一个类型参数 `T` 必须是 `SomeClass` 子类；第二个类型参数 `U` 必须遵循 `SomeProtocol` 协议。



#### 普通函数：在一个 `String` 数组中查找给定 `String` 值的索引

```swift
// 这个查找函数只支持 String 类型
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}
// 打印：The index of llama is 2
```



#### 相同功能的泛型函数，支持任意类型

```swift
// 泛型函数：在一个数组中查找给定值的索引，支持任意类型
// 但不是所有的自定义 Swift 类型都支持通过等式符（==）进行比较
// 因此，该泛型类型还必须遵守 Equatable 协议，以支持相等性（==）比较
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(of: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
```

### 关联类型（`associatedtype`）

> 💡  
>  
> 在协议（`protocol`）中添加关联类型（`associatedtype`）作为占位符类型，而这个关联类型是泛型类型！

定义一个协议时，**声明一个或多个关联类型作为协议定义的一部分**将会非常有用。关联类型为协议中的某个类型提供了一个占位符名称，其代表的实际类型在协议被遵循时才会被指定。关联类型通过 `associatedtype` 关键字来指定。

```swift
protocol Container {
    
    // 声明一个关联类型 Item
    associatedtype Item
    
    // 通过 append(_:) 方法添加一个新元素到容器中
    mutating func append(_ item: Item)
    
    // 计算属性，通过 coount 属性获取容器中元素的数量，并返回一个 Int 值
    var count: Int { get }
    
    // 下标属性，通过索引值类型为 Int 的下标检索到容器中的每一个元素
    subscript(i: Int) -> Item { get }
}

// ------------------------------
// 非泛型版本 IntStack 类型，使其遵循 Container 协议
struct IntStack: Container {
    // MARK: IntStack 的原始实现部分
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // MARK: Container 协议的实现部分
    // 指定 Item 为 Int 类型
    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// ------------------------------
// 让泛型 Stack 结构体遵循 Container 协议
struct Stack<Element>: Container {
    // MARK: Stack<Element> 的原始实现部分
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    // MARK: Container 协议的实现部分
    // 协议中的关联类型 Item 即为该结构体中的泛型类型 Element
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
```


#### 扩展现有类型来指定关联类型

Swift 的 `Array` 类型已经提供 `append(_:)` 方法，`count` 属性，以及带有 `Int` 索引的下标来检索其元素。这三个功能都符合 `Container` 协议的要求，也就意味着你只需要声明 `Array` 遵循 `Container` 协议，就可以扩展 `Array`，使其遵从 `Container` 协议。你可以通过一个空扩展来实现这点，正如通过扩展采纳协议中的描述：

```swift
extension Array: Container {}
```

#### 给关联类型添加约束

```swift
protocol Container {
    // 要求关联类型 Item 必须遵循 Equatable 协议
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
```

#### 在关联类型约束里使用协议

协议可以作为它自身的要求出现。

```swift
protocol Container {
    // 要求关联类型 Item 必须遵循 Equatable 协议
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

protocol SuffixableContainer: Container {
    // Suffix 是一个关联类型
    // 约束一：它必须遵循 SuffixableContainer 协议（就是当前定义的协议）
    // 约束二：它的 Item 类型必须是和容器里的 Item 类型相同
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    // suffix(_:) 方法返回容器中从后往前给定数量的元素，并把它们存储在一个 Suffix 类型的实例里
    func suffix(_ size: Int) -> Suffix
}
```


### 泛型 where 语句

「类型约束」让你能够为泛型函数、下标、类型的类型参数定义一些强制要求。

**对关联类型添加约束**通常是非常有用的。你可以通过定义一个泛型 `where` 子句来实现。通过泛型 `where` 子句让关联类型遵从某个特定的协议，以及某个特定的类型参数和关联类型必须类型相同。你可以通过将 `where` 关键字紧跟在类型参数列表后面来定义 `where` 子句，`where` 子句后跟一个或者多个针对关联类型的约束，以及一个或多个类型参数和关联类型间的相等关系。你可以在函数体或者类型的大括号之前添加 `where` 子句。

```swift
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// 定义一个名为 allItemsMatch 的泛型函数。用来检查两个 Container 实例是否包含相同顺序的相同元素。
// 如果所有的元素能够匹配，那么返回 true，否则返回 false。
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {
        
        // 检查两个容器含有相同数量的元素
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // 检查每一对元素是否相等
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // 匹配所有元素，返回 true
        return true
}
```


### 具有泛型 where 子句的扩展

在扩展中添加泛型 `Where` 子句

你也可以使用泛型 `where` 子句作为扩展的一部分。

```swift
// 使用泛型 where 语句为扩展添加新的条件，只有当栈中的元素遵守 Equatable 协议时
// 扩展才会添加 isTop(_:) 方法
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
```


### 包含上下文关系的 where 分句

当你使用泛型时，可以为没有独立类型约束的声明添加 `where` 分句。

例如，你可以使用 `where` 分句为泛型添加下标，或为扩展方法添加泛型约束

```swift
// 通过 where 分句让新的方法声明其调用所需要满足的类型约束
extension Container {
    func average() -> Double where Item == Int {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count-1] == item
    }
}

let numbers = [1260, 1200, 98, 37]
print(numbers.average())
// 输出 "648.75"
print(numbers.endsWith(37))
// 输出 "true"
```

当 `Item` 是整型时为 `Container` 添加 `average()` 方法。
当 `Item` 遵循 `Equatable` 时添加 `endsWith(_:)` 方法。
两个方法都通过 `where` 分句对 `Container` 中定义的泛型 `Item` 进行了约束。

如果不使用包含上下文关系的 `where` 分句，需要写两个扩展，并为每个扩展分别加上 `where` 分句。下面的例子和上面的具有相同效果。

```swift
extension Container where Item == Int {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
}
extension Container where Item: Equatable {
    func endsWith(_ item: Item) -> Bool {
        return count >= 1 && self[count-1] == item
    }
}
```

### 具有泛型 where 子句的关联类型

你可以在关联类型后面加上具有泛型 `where` 的字句。

例如，建立一个包含迭代器（`Iterator`）的容器，就像是标准库中使用的 `Sequence` 协议那样。你应该这么写：

```swift
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    /*
     迭代器（Iterator）的泛型 where 子句要求：无论迭代器是什么类型，迭代器中的元素类型，必须和容器项目的类型保持一致。
     */
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    // makeIterator() 则提供了容器的迭代器的访问接口。
    func makeIterator() -> Iterator
}
```

一个协议继承了另一个协议，你通过在协议声明的时候，包含泛型 `where` 子句，来添加了一个约束到被继承协议的关联类型。例如，下面的代码声明了一个 `ComparableContainer` 协议，它要求所有的 `Item` 必须是 `Comparable` 的。

```swift
protocol ComparableContainer: Container where Item: Comparable { }
```

### 泛型下标

下标可以是泛型，它们能够包含泛型 `where` 子句。你可以在 `subscript` 后用尖括号来写占位符类型，你还可以在下标代码块花括号前写 `where` 子句。

```swift
protocol Container {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// 定义一个 Container 协议的扩展
extension Container {
    // 尖括号中的泛型参数 Indices，必须是遵守标准库中的 Sequence 协议的类型
    // 下标使用的单一参数 indices，必须是 Indices 的实例对象
    // 泛型 where 子句要求 Sequence（Indices）的迭代器，其所有的元素都是 Int 类型。
    //   这样就能确保在序列（Sequence）中的索引和容器（Container）里面的索引类型是一致的。
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
```