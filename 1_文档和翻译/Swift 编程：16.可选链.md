*可选链式*调用是一种可以在当前值可能为 `nil` 的可选值上请求和调用属性、方法及下标的方法。如果可选值有值，那么调用就会成功；如果可选值是 `nil`，那么调用将返回 `nil`。多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为 `nil`，整个调用链都会失败，即返回 `nil`。

> 注意
> 
> Swift 的可选链式调用和 Objective-C 中向 `nil` 发送消息有些相像，但是 Swift 的可选链式调用可以应用于任意类型，并且能检查调用是否成功。


## 1. 使用可选链式调用代替强制解包

通过在想调用的属性、方法，或下标的可选值后面放一个问号（`?`），可以定义一个可选链。这一点很像在可选值后面放一个叹号（`!`）来强制解包它的值。它们的主要区别在于当可选值为空时可选链式调用只会调用失败，然而强制解包将会触发运行时错误。

为了反映可选链式调用可以在空值（`nil`）上调用的事实，不论这个调用的属性、方法及下标返回的值是不是可选值，它的返回结果都是一个可选值。你可以利用这个返回值来判断你的可选链式调用是否调用成功，如果调用有返回值则说明调用成功，返回 `nil` 则说明调用失败。

这里需要特别指出，可选链式调用的返回结果与原本的返回结果具有相同的类型，但是被包装成了一个可选值。例如，使用可选链式调用访问属性，当可选链式调用成功时，如果属性原本的返回结果是 `Int` 类型，则会变为 `Int?` 类型。

```swift
// Person 类有一个可选的 residence 属性，它的类型为 Residence?
class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

let john = Person()
// john.residence = nil

// 只要将一个 Residence 实例赋值给 john.residence，这样它就不再是 nil
john.residence = Residence()

// 使用 ! 强制解包 john 的 residence 属性
// let roomCount = john.residence!.numberOfRooms
// 这会引发运行时错误

// 使用「可选链式调用」的方式访问 john 的 residence 属性
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(x).")
} else {
    print("无法获得房间的数量.")
}
// 无法获得房间的数量.
// John's residence has 1 room(x).
```


## 2. 为可选链式调用定义模型类

通过使用可选链式调用可以调用多层属性、方法和下标。这样可以在复杂的模型中向下访问各种子属性，并且判断能否访问子属性的属性、方法和下标。

```swift
class Room {
    let name: String
    init(name: String) {
        self.name = name;
    }
}

class Address {
    var buildingName: String?
    var buildingNumber:  String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}

class Residence {
    // rooms 是一个存储 Room 实例的数组
    var rooms = [Room]()
    
    // 计算属性 numberOfRooms
    var numberOfRooms: Int {
        return rooms.count
    }
    
    // 下标语法
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    
    // 方法功能：打印 numberOfRooms 的值
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    
    // 可选属性，类型为 Address?
    var address: Address?
    
}

// Person 类有一个可选的 residence 属性，它的类型为 Residence?
class Person {
    var residence: Residence?
}
```



## 3. 通过可选链式调用访问属性

可以通过**可选链式调用**在一个可选值上**访问它的属性**，并判断访问是否成功。

```swift
let john = Person()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
Unable to retrieve the number of rooms.
```

还可以通过**可选链式调用**来**设置属性值**：

```swift
let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
john.residence?.address = someAddress
// 通过 john.residence 来设定 address 属性也会失败，因为 john.residence 当前为 nil
```

当可选链式调用失败时，等号右侧的代码不会被执行。但你很难看出来它有没有被执行，所以你可以使用一个函数来创建 `Address` 实例：

```swift
func createAddress() -> Address {
    print("函数被调用")
    
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    
    return someAddress
}

john.residence?.address = createAddress()
```


## 4. 通过可选链式调用来调用方法

可以通过可选链式调用来调用方法，并判断是否调用成功，即使这个方法没有返回值。

没有返回值的方法会隐式返回 `Void`。
如果在可选值上通过可选链式调用来调用这个方法，该方法的返回类型会是 `Void?`，而不是 `Void`。
通过判断返回值是否为 `nil` 可以判断调用是否成功：

```swift
if john.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}
// 打印：It was not possible to print the number of rooms.
```

同样的，可以据此判断通过可选链式调用为属性赋值是否成功。
通过可选链式调用给属性赋值会返回 `Void?`，通过判断返回值是否为 `nil` 就可以知道赋值是否成功：

```swift
let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"

if (john.residence?.address = someAddress) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
}
// 打印：It was not possible to set the address.
```



## 5. 通过可选链式调用访问下标


通过可选链式调用，我们可以在一个可选值上访问下标，并且判断下标调用是否成功。

> 注意
> 
> 通过可选链式调用访问可选值的下标时，应该**将问号放在下标方括号的前面而不是后面**。可选链式调用的问号一般直接跟在可选表达式的后面。

```swift
if let firstRoomName = john.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}
// 打印：Unable to retrieve the first room name.
```

类似的，可以通过下标，用可选链式调用来赋值：

```swift
john.residence?[0] = Room(name: "Bathroom")
```

### 5.1 访问可选类型的下标

如果下标返回可选类型值，比如 Swift 中 `Dictionary` 类型的键的下标，可以在下标的结尾括号后面放一个问号来在其可选返回值上进行可选链式调用：

```swift
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]

// 用可选链式调用把 “Dave” 数组中的第一个元素设为 91
testScores["Dave"]?[0] = 91

// 用可选链式调用把 “Bev” 数组中的第一个元素 +1
testScores["Bev"]?[0] += 1

// 该链式调用失败，因为 testScores 字典中没有 “Brian” 这个键
testScores["Brian"]?[0] = 72

// "Dave" 数组现在是 [91, 82, 84]，"Bev" 数组现在是 [80, 94, 81]
```


## 6. 连接多层可选链式调用

可以通过连接多个可选链式调用在更深的模型层级中访问属性、方法以及下标。然而，多层可选链式调用不会增加返回值的可选层级。

也就是说：
* 如果你访问的值不是可选的，可选链式调用将会返回**可选值**。
* 如果你访问的值就是可选的，可选链式调用不会让可选返回值变得“更可选”。

因此：
* 通过可选链式调用访问一个 `Int` 值，将会返回 `Int?`，无论使用了多少层可选链式调用。
* 类似的，通过可选链式调用访问 `Int?` 值，依旧会返回 `Int?` 值，并不会返回 `Int??`。

```swift
// 两层可选链式调用
// 尝试访问 john 中的 residence 属性中的 address 属性中的 street 属性
if let johnsStreet = john.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}
// 打印：Unable to retrieve the address.
```


### 6.1 在方法的可选返回值上进行可选链式调用

上面的例子展示了如何在一个可选值上通过可选链式调用来获取它的属性值。我们还可以在一个可选值上通过可选链式调用来调用方法，并且可以根据需要继续在方法的可选返回值上进行可选链式调用。

```swift
// 在一个可选值上通过「可选链式调用」来调用方法
if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}
```

如果要在该方法的返回值上进行可选链式调用，在方法的圆括号后面加上问号即可：

```swift
// 在一个可选值上通过「可选链式调用」来调用方法
if let beginsWithThe =
    john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
        if beginsWithThe {
            print("John's building identifier begins with \"The\".")
        } else {
            print("John's building identifier does not begin with \"The\".")
        }
}
```

> 注意
> 
> 在上面的例子中，在方法的圆括号后面加上问号是因为你要在 `buildingIdentifier()` 方法的**可选返回值**上进行可选链式调用，而不是 `buildingIdentifier()` 方法本身。