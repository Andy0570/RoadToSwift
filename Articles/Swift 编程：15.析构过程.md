在类实例被释放的时候，反初始化器就会立即被调用。你可以使用 `deinit` 关键字来写反初始化器，就如同写初始化器要用 `init` 关键字一样。反初始化器只在 `Class` 类型中有效。

> 💡 类似 Objective-C 语言中的 `dealloc` 语法。

## 反初始化器原理

当实例不再被需要的时候 Swift 会自动将其释放掉，以节省资源。如同自动引用计数中描述的那样，Swift 通过自动引用计数（ARC）来处理实例的内存管理。基本上，当你的实例被释放时，你不需要手动清除它们。总之，当你在操作自己的资源时，你可能还是需要在释放实例时执行一些额外的清理工作。比如说，如果你创建了一个自定义类来打开某文件写点数据进去，你就得在实例释放之前关闭这个文件。

每个类当中只能有一个反初始化器。反初始化器不接收任何形式参数，并且不需要写圆括号：

```swift
deinit {
    // perform the deinitialization
}
```

反初始化器会在实例被释放之前自动被调用。你不能自行调用反初始化器。父类的反初始化器可以被子类继承，并且子类的反初始化器实现结束之后父类的反初始化器会被调用。父类的反初始化器总会被调用，就算子类没有反初始化器。

由于实例在反初始化器被调用之前都不会被释放，反初始化器可以访问实例中的所有属性并且可以基于这些属性修改自身行为（比如说查找需要被关闭的那个文件的文件名）。


## 应用反初始化器

示例。

```swift
import UIKit

/**
 Bank 类用来管理虚拟货币，数量总额永远不会超过 10000 枚金币。
 */
class Bank {
    // 类属性
    static var coinsInBank = 10_000
    
    // 类方法，分发金币方法
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        // 可提取的金币
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsRequested
        return numberOfCoinsToVend
    }
    
    // 类方法，收集金币方法
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}

/**
 Player 类描述游戏中的玩家
 */
class Player {
    // 钱包中的金币
    var coinsInPurse: Int
    
    // 指定初始化方法，以一定的金币数量初始化实例对象
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    
    // 从银行获取金币，添加到自己的钱包中
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    
    // MARK: 当该玩家的实例反初始化时，返还金币到银行
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}

var playerOne: Player? = Player(coins: 100)
print("当前新加入的玩家拥有 \(playerOne!.coinsInPurse) 枚金币")
// 当前新加入的玩家拥有 100 枚金币

print("现在，银行仅剩 \(Bank.coinsInBank) 枚金币")
// 现在，银行仅剩 9900 枚金币

playerOne!.win(coins: 2_000)
print("当前玩家赢得了 2000 枚金币，现在总计拥有  \(playerOne!.coinsInPurse) 枚金币")
// 当前玩家赢得了 2000 枚金币，现在总计拥有  2100 枚金币

print("现在，银行仅剩 \(Bank.coinsInBank) 枚金币")
// 现在，银行仅剩 7900 枚金币

playerOne = nil
// 玩家推出了游戏，当 playerOne 实例被释放的瞬间，反初始化方法被调用

print("现在，银行有 \(Bank.coinsInBank) 枚金币")
// 现在，银行有 10000 枚金币

```



