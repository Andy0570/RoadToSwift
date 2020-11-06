## 数组 Array

Swift 中数组的完整写法为 `Array<Element>`，其中 Element 是这个数组中唯一允许存在的数据类型。也可以使用像 `[Element]` 这样的简单语法。

### 数组的创建

```swift
// 创建一个空数组
// 使用构造语法来创建一个由特定数据类型构成的空数组
var someInts = [Int]()


// 创建一个带有默认值的数组
// threeDoubles 是一种 [Double] 数组，等价于 [0.0, 0.0, 0.0]
var threeDoubles = Array(repeating: 0.0, count: 3)


// 通过两个数组相加（+）创建一个数组
var threeDoubles = Array(repeating: 0.0, count: 3)        // [0.0, 0.0, 0.0]
var anotherThreeDoubles = Array(repeating: 2.5, count: 3) // [2.5, 2.5, 2.5]
// sixDoubles 被推断为 [Double]，等价于 [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
var sixDoubles = threeDoubles + anotherThreeDoubles


// 数组字面量
var arrays = [value1, value2, value3]
var shoppingList = ["Eggs", "Milk"]
```

### 数组的访问和修改

```swift
// 使用数组的只读属性 count 来获取数组中的数据项数量
Array.count


// 使用布尔属性 isEmpty 作为一个缩写形式去检查 count 属性是否为 0：
if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list is not empty.")
}


// 使用 append(_:) 方法在数组后面添加新的数据项
Array.append(_:)


// 使用加法赋值运算符（+=）直接将另一个相同类型数组中的数据添加到该数组后面
shoppingList += ["Baking Powder"]


// 使用下标语法获取/改变数组中的数据项
Array[index]


// 利用下标来一次改变一系列数据值
shoppingList[4...6] = ["Bananas", "Apples"]


// 使用 insert(_:at:) 方法在某个指定索引值之前添加数据项
// 现在是这个列表中的第一项是“Maple Syrup”
shoppingList.insert("Maple Syrup", at: 0)


// 使用 remove(at:) 方法移除数组中的某一项
let mapleSyrup = shoppingList.remove(at: 0)


// 使用 removeLast() 方法移除数组中的最后一项
let apples = shoppingList.removeLast()
```

### 数组的遍历

```swift
// for-in
for item in shoppingList {
    print(item)
}


// enumerated() 方法
for (index, value) in shoppingList.enumerated() {
    print("Item \(String(index + 1)): \(value)")
}
```

## 集合 Set

集合用来存储相同类型并且没有确定顺序的值。当集合元素顺序不重要时或者希望确保每个元素只出现一次时可以使用集合而不是数组。

Swift 中的集合类型被写为 `Set<Element>`，这里的 Element 表示集合中允许存储的类型。和数组不同的是，集合没有等价的简化形式。

### 集合的创建

```swift
// 创建和构造一个空的集合
var letters = Set<Character>()


// 数组字面量，Set 类型必须显式声明
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
// 简化方式
var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
```


### 集合的访问和修改

```swift
// 获取集合中元素的数量
Set.count


// 使用布尔属性 isEmpty 作为一个缩写形式去检查 count 属性是否为 0
if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}


// 添加元素 insert(_:)
favoriteGenres.insert("Jazz")


// 删除元素 remove(_:)
if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.") // “Rock? I'm over it.”
} else {
    print("I never much cared for that.")
}


// 删除所有元素 removeAll()


// 检查是否包含一个特定元素 contains(_:)
if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}
```

### 集合的遍历

```swift
// for-in
for genre in favoriteGenres {
    print("\(genre)")
}


// 按照特定顺序遍历 sorted() 
for genre in favoriteGenres.sorted() {
    print("\(genre)")
}
```

### 集合操作

#### 集合基本操作

* 使用 `intersection(_:)` 方法根据两个集合的交集创建一个新的集合。
* 使用 `symmetricDifference(_:)` 方法根据两个集合不相交的值创建一个新的集合。
* 使用 `union(_:)` 方法根据两个集合的所有值创建一个新的集合。
* 使用 `subtracting(_:)` 方法根据不在另一个集合中的值创建一个新的集合。


#### 集合成员关系和相等

* 使用“是否相等”运算符（`==`）来判断两个集合包含的值是否全部相同。
* 使用 `isSubset(of:)` 方法来判断一个集合中的所有值是否也被包含在另外一个集合中。
* 使用 `isSuperset(of:)` 方法来判断一个集合是否包含另一个集合中所有的值。
* 使用 `isStrictSubset(of:)` 或者 `isStrictSuperset(of:)` 方法来判断一个集合是否是另外一个集合的子集合或者父集合并且两个集合并不相等。
* 使用 `isDisjoint(with:)` 方法来判断两个集合是否不含有相同的值（是否没有交集）。


## 字典 Dictionary


字典是一种无序的集合，它存储的是键值对之间的关系，其所有键的值需要是相同的类型，所有值的类型也需要相同。每个值（value）都关联唯一的键（key），键作为字典中这个值数据的标识符。和数组中的数据项不同，字典中的数据项并没有具体顺序。你在需要通过标识符（键）访问数据的时候使用字典，这种方法很大程度上和在现实世界中使用字典查字义的方法一样。


### 字典的创建

```swift
// 创建一个空字典
// namesOfIntegers 是一个空的 [Int: String] 字典
var namesOfIntegers = [Int: String]()


// 字典字面量
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
// 简化形式
var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
```


### 字典的访问和修改

```swift
// 获取字典的数据项数量
Dictionary.count


// 使用布尔属性 isEmpty 作为一个缩写形式去检查 count 属性是否为 0
if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary is not empty.")
}


// 使用 updateValue(_:forKey:) 方法添加/修改数据项
// 使用下标语法添加/修改数据项
airports["key"] = "value"

// 检索
if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airports dictionary.")
}

// 使用 removeValue(forKey:) 方法移除字典中的键值对
// 移除
airports["key"] = nil
```


### 字典的遍历

```swift
// for-in
for (key, value) in dictionary {
    print("\(key): \(value)")
}

// 仅遍历 key
for key in dictionary.keys {
    print(key)
}

// 仅遍历 value
for value in dictionary.values {
    print(value)
}


// 直接使用 keys 或者 values 属性构造一个新数组
let airportCodes = [String](airports.keys)
// airportCodes 是 ["YYZ", "LHR"]

let airportNames = [String](airports.values)
// airportNames 是 ["Toronto Pearson", "London Heathrow"]


// 使用 sorted() 方法以特定的顺序遍历字典的键或值
```
