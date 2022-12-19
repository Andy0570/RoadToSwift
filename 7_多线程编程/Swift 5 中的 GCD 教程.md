> 原文：[Grand Central Dispatch Tutorial Swift 5](https://www.swiftdevcenter.com/grand-central-dispatch-tutorial-swift-5/)



Grand Central Dispatch (GCD) 是 Apple 提供的底层级别（low-level）的 API。 GCD 用于管理并发操作。 GCD 有很多好处，比如：

– 它提高了应用程序的性能和响应能力。
- 应用程序将变得更加流畅。
– 根据你的要求一次或一项执行多项任务。

GCD 在系统级别运行，它以平衡的方式管理所有正在运行的应用程序的资源。

## 队列（Queue）

队列是遵循先进先出 (FIFO) 顺序的线性结构。这里我们将使用两种类型的队列：**串行队列**（Serial queue）和**并发队列**（Concurrent queue）。

### 串行队列（Serial queue）

在串行队列中，一次只运行一个任务。一旦第一个任务结束，那么只有第二个任务将开始。所有任务都遵循相同的顺序，他们必须等到运行任务完成。

### 并发队列（Concurrent queue）

在并发队列中，可以同时运行多个任务。任务的开始时间将是它们添加的顺序，意味着任务 0 先启动，然后任务 1 将在此之后启动，依此类推。任务可以按任何顺序完成。

![](https://www.swiftdevcenter.com/wp-content/uploads/2019/12/Serial-Concurrent-Queue.jpg)

## 同步与异步（Synchronous vs. Asynchronous）

使用 GCD 调度任何任务有两种方式，一种是同步的，另一种是异步的。在同步函数中，当任务完成时返回控制，调用者应该等待控制，直到任务完成。

在异步函数中立即返回控制，它不会阻塞当前线程，这意味着主线程不应该等待完成异步运行的任务。

## 主队列（Main Queue）

```swift
DispatchQueue.main.async {
    // write your code here
}  
```



## 全局队列（Global Queue）

全局队列也称为后台队列，它是一个并发队列，在所有应用程序之间共享。

```swift
// Synchronous
DispatchQueue.global().sync {
   // write your code here
}

// Asynchronous
DispatchQueue.global().async {
   // write your code here
}
```



### 服务质量（Quality of Service）

在并发队列中，我们可以使用服务质量（Quality of Service）类设置任务的优先级。基本上，我们根据任务的重要性使用服务质量等级。以下是服务质量。

**User-interactive**：用户交互任务具有很高的优先级，必须立即完成。示例 UI 更新任务、事件处理任务、动画等。与其他用户交互相比，用户交互需要高能量和资源。

**User-initiated**：将用户启动的任务分配给为用户正在执行的操作或用户正在等待结果提供即时结果的任务，它会阻止用户主动使用应用程序。它在用户交互示例之后具有第二优先级 - 用户正在等待结果、加载电子邮件内容等。 默认值：默认任务的优先级低于用户交互和用户启动的任务。将此类分配给您的应用程序代表用户启动或执行活动工作的任务。

**Utility**：实用程序任务的优先级低于默认任务。如果用户不需要主动跟踪，则将实用程序分配给这些任务。实用任务通常是节能的并且消耗更少的能量。

**Background**：后台任务，这些任务的优先级最低。当您的应用程序在后台运行时，将后台分配给您想要执行的任何任务。这些类型的任务通常不需要任何用户交互。

**Unspecified**：当服务质量等级不存在时，它将被视为未指定。

```swift
// User-interactive
DispatchQueue.global(qos: .userInteractive).async {
 // 事件处理任务
 // 动画任务
 // 任务完成后跳转到主线程更新UI
}

// User-initiated:
DispatchQueue.global(qos: .userInitiated).async {
  // 加载电子邮件等
}

// Defaul
DispatchQueue.global(qos: .default).async {
  // 应用启动的任务
  // 代表用户主动执行的工作
}

// Utility
DispatchQueue.global(qos: .utility).async {
  // 低优先级任务
}

// Background
DispatchQueue.global(qos: .background).async {
  //  应用在后台运行时需要执行的任务
}
```

### 使用 GCD 创建串行队列

编写以下代码来创建您自己的串行队列。

```swift
let serialQueue = DispatchQueue(label: "mySerialQueue")
serialQueue.async {
  // Add your serial task
}
```

让我们从串行队列中的图像 URL 数组下载图像。

```swift
let myArray = [img1, img2, img3, img4, img5, img6]

for i in 0 ..< myArray.count {
  serialQueue.async {
    do {
      let data = try Data(contentsOf: URL(string: myArray[i])!)
      if let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.imageSerial[i].image = image
        }
      }
    } catch {
      print("error is \(error.localizedDescription)")
    }
  }
}
```

![](https://www.swiftdevcenter.com/wp-content/uploads/2019/12/Serial-Queue.gif)

### 使用 GCD 创建并发队列

编写以下代码来创建您自己的并发队列。

```swift
let concurrentQueue = DispatchQueue(label: "myConcurrentQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)

concurrentQueue.async {
 // Add your concurrent task
}
```

让我们从并发队列中的图像 URL 数组中下载图像

```swift
let myArray = [img1, img2, img3, img4, img5, img6]

for i in 0 ..< myArray.count {
  concurrentQueue.async {
    do {
      let data = try Data(contentsOf: URL(string: myArray[i])!)
      if let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.imageConcurrent[i].image = image
        }
      }
    } catch {
      print("error is \(error.localizedDescription)")
    }
  }
}
```

![](https://www.swiftdevcenter.com/wp-content/uploads/2019/12/Concurrent-Queue.gif)

### 延迟任务

如果您想在一段时间后执行任何任务，则可以在使用以下代码后进行调度。

```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
		// Code run after 2 seconds
}
```
