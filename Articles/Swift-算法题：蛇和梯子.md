### 游戏规则

![](https://upload-images.jianshu.io/upload_images/2648731-789075e2bf6be006.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

游戏的规则如下：

* 游戏盘面包括 25 个方格，游戏目标是达到或者超过第 25 个方格；
* 每一轮，你通过掷一个六面体骰子来确定你移动方块的步数，移动的路线由上图中横向的虚线所示；
* 如果在某轮结束，你移动到了梯子的底部，可以顺着梯子爬上去；
* 如果在某轮结束，你移动到了蛇的头部，你会顺着蛇的身体滑下去。

### 实现

游戏盘面可以使用一个 `Int` 数组来描述。数组的长度由一个 `finalSquare` 常量储存，用来初始化数组和检测最终胜利条件。游戏盘面由 26 个 `Int` 0 值初始化，而不是 25 个（由 `0` 到 `25`，一共 26 个）：

```swift
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
```

一些方格被设置成特定的值来表示有蛇或者梯子。梯子底部的方格是一个正值，使你可以向上移动，蛇头处的方格是一个负值，会让你向下移动：

```swift
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
```

3 号方格是梯子的底部，会让你向上移动到 11 号方格，我们使用 `board[03]` 等于 `+08`（来表示 11 和 3 之间的差值）。为了对齐语句，这里使用了一元正运算符（`+i`）和一元负运算符（`-i`），并且小于 10 的数字都使用 0 补齐（这些语法的技巧不是必要的，只是为了让代码看起来更加整洁）。

玩家由左下角空白处编号为 0 的方格开始游戏。玩家第一次掷骰子后才会进入游戏盘面：

使用 `while` 循环实现：
```swift
var square = 0 // 玩家当前的位置
var diceRoll = 0 // 骰子的值
while square < finalSquare {
    // 掷骰子
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    // 根据点数移动
    square += diceRoll
    // ！数组越界检查
    if square < board.count {
        // 如果玩家还在棋盘上，顺着梯子爬上去或者顺着蛇滑下去，或者原地不动+0
        square += board[square]
    }
}
print("Game over!")
```

本例中使用了最简单的方法来模拟掷骰子。`diceRoll` 的值并不是一个随机数，而是以 `0` 为初始值，之后每一次 `while` 循环，`diceRoll` 的值增加 `1` ，然后检测是否超出了最大值。当 `diceRoll` 的值等于 `7` 时，就超过了骰子的最大值，会被重置为 `1`。所以 `diceRoll` 的取值顺序会一直是 `1`，`2`，`3`，`4`，`5`，`6`，`1`，`2` 等。

掷完骰子后，玩家向前移动 `diceRoll` 个方格，如果玩家移动超过了第 25 个方格，这个时候游戏将会结束，为了应对这种情况，代码会首先判断 `square` 的值是否小于 `board` 的 `count` 属性，只有小于才会在 `board[square]` 上增加 `square`，来向前或向后移动（遇到了梯子或者蛇）。

当本轮 `while` 循环运行完毕，会再检测循环条件是否需要再运行一次循环。如果玩家移动到或者超过第 25 个方格，循环条件结果为 `false`，此时游戏结束。


使用 `repeat-while` 循环实现：

```swift
repeat {
    // 顺着梯子爬上去或者顺着蛇滑下去
    square += board[square]
    // 掷骰子
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    // 根据点数移动
    square += diceRoll
} while square < finalSquare
print("Game over!")
```

可以省去数组越界检查。
