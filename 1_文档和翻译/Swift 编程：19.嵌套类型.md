## 嵌套类型

枚举常被用于为特定类或结构体实现某些功能。类似地，枚举可以方便的定义工具类或结构体，从而为某个复杂的类型所使用。为了实现这种功能，Swift 允许你定义**嵌套类型**，可以**在支持的类型中定义嵌套的枚举、类和结构体**。

要在一个类型中嵌套另一个类型，将嵌套类型的定义写在其外部类型的 `{}` 内，而且可以根据需要定义多级嵌套。



## 嵌套类型实践

```swift
// 结构体 BlackjackCard 表示“二十一点”扑克牌游戏，
// 表示某一个花色的某一张牌
struct BlackjackCard {
    
    // 嵌套的 Suit 枚举，表示扑克牌的四种花色
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }
    
    // 嵌套的 Rank 枚举
    // Rank 枚举用来描述扑克牌从 Ace~10，以及 J、Q、K，这 13 种牌，并用一个 Int 类型的原始值表示牌的面值。
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        
        // Rank 枚举在内部定义了一个嵌套结构体 Values
        struct Values {
            let first: Int, second: Int?
        }
        
        // 计算属性 values
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    // BlackjackCard 的属性和方法
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

// 通过默认构造器初始化 BlackjackCard 实例
let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print("theAceOfSpades: \(theAceOfSpades.description)")
// 打印：theAceOfSpades: suit is ♠, value is 1 or 11
```



## 引用嵌套类型

在外部引用嵌套类型时，在嵌套类型的类型名前加上其外部类型的类型名作为前缀：

```swift
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
// 红心符号为“♡”
```