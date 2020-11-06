## 下标的语法（`subscript`）

下标脚本允许你通过在实例名后面的方括号内写一个或多个值**对该类的实例进行查询**。它的语法类似于实例方法和计算属性。使用关键字 `subscript` 来定义下标，并且指定一个或多个输入形式参数和返回类型，与实例方法一样。

与实例方法不同的是，下标可以是读写也可以是只读的。这个行为通过与计算属性中相同的 `getter` 和 `setter` 传达：

```swift
subscript(index: Int) -> Int {
    get {
        // 在此处返回适当的下标值
    }
    set(newValue) {
        // 在此执行适当的设置操作
    }
}
```

`newValue` 的类型和下标的返回值一样。与**计算属性**一样，你可以选择不去指定 `setter` 的 (`newValue`) 形式参数。如果你没有提供的话，`setter` 默认的形式参数即为 `newValue`。

与只读计算属性一样，你可以给**只读下标**省略 `get` 关键字：

```swift
subscript(index: Int) ->  Int {
    // 在此处返回适当的下标值
}
```

下面是一个只读下标实现的栗子，它定义了一个 `TimeTable` 结构体来表示整数的 n 倍表：

```swift
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// six times three is 18
```

在这个栗子中，创建了一个 `TimeTable` 的新实例来表示三倍表。它表示通过给结构体的初始化器传入值 `3` 作为用于实例的 `multiplier` 形式参数。

你可以通过下标来查询 `threeTimesTable` ，比如说调用 `threeTimesTable[6]`。这条获取了三倍表的第六条结果，它返回了值 `18` 或者 `6` 的 `3` 倍。


## 下标用法

“下标” 确切的意思取决于它使用的上下文。通常下标是用来访问**集合**、**列表**或**序列**中元素的快捷方式。你可以在你自己特定的**类**或**结构体**中**自由实现下标来提供合适的功能**。

例如，Swift 的 `Dictionary` 类型实现了下标来对 `Dictionary` 实例中存放的值进行设置和读取操作。你可以在下标的方括号中通过提供字典键类型相同的键来设置字典里的值，并且把一个与字典值类型相同的值赋给这个下标：

```swift
// 定义一个 numberOfLegs 变量，并用一个字典字面量初始化出包含三个键值对的字典实例
var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
// 通过下标语法赋值来添加一个 String 键 “bird” 和 Int 值 2 到字典中
numberOfLegs["bird"] = 2
```


## 下标选项

下标可以接收任意数量的输入形式参数，并且这些输入形式参数可以是任意类型。下标也可以返回任意类型。下标可以使用变量形式参数和可变形式参数，但是**不能使用输入输出形式参数**或提供**默认形式参数值**。

如同可变形式参数和默认形式参数值中描述的那样，类似函数，下标也可以接收不同数量的形式参数并且为它的形式参数提供默认值。

类或结构体可以根据自身需要提供多个下标实现，合适被使用的下标会基于值类型或者使用下标时下标方括号里包含的值来推断。这个对多下标的定义就是所谓的*下标重载*。

通常来讲下标接收一个形式参数，但只要你的类型需要也可以**为下标定义多个参数**。

```swift
// 定义一个 Matrix 结构体，它呈现一个 Double 类型的二维矩阵。
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    
    // 初始化器
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        // 使用默认值创建数组
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    // 判断索引是否越界
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    // 下标语法，通过坐标（row, column) 返回值二维矩阵中的 Double 类型的值
    subscript(row: Int, column: Int) -> Double {
        get {
            // 通过断言检查下标的 row 和 column 是否有效
            assert(indexIsValid(row: row, column: column), "数组索引越界")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "数组索引越界")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
// grid = [0.0, 0.0, 0.0, 0.0]

matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
// [0.0, 1.5, 3.2, 0.0]
```

## 类型下标（`static subscript`）

实例下标，就是在对应类型的实例上使用下标语法。你同样也可以**定义类型本身的下标**。这类下标叫做**类型下标**。你可通过在 `subscript` 关键字前加 `static` 关键字来标记类型下标。在类里则使用 `class` 关键字，这样可以允许子类重写父类的下标实现。下面的例子展示了如何定义和调用类型下标：

```swift
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}

let mars = Planet[4]
print(mars)
// mars
```