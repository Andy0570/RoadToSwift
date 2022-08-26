> 原文：[Async / Await in Swift](https://www.advancedswift.com/async-await/)

通过示例了解如何在 Swift 中使用 async 和 await。 Async 和 await 是新的 Swift 5.5 关键字，用于帮助实现异步编程。

丰富的 iOS 和 macOS 体验通常会执行异步任务，例如从远程服务器获取数据。在 Swift 5.5 中新增的 async 和 await 关键字使开发人员能够简化异步代码并更容易实现异步任务。这篇文章通过一个示例概述了 async 和 await：


# Async

在以前的 Swift 版本中，异步编程通常是通过使用 completion blocks 来实现的：

```swift
// The completion block will be called when
// saveChanges completes its asynchronous logic
func saveChanges(completion: (() -> Void)?) { ... }

// In other code, the saveChanges function would
// be called like this:
saveChanges {
    // Handle completion
}
```

使用新的 async 关键字，Swift 可以将函数标记为具有异步逻辑：

```swift
// Swift 自动处理 saveChanges 的异步完成
func saveChanges() async { ... }

// 在其他代码中，异步 saveChanges 函数会这样调用：
await saveChanges()
```

## Async Throws

在以前的 Swift 版本中，一些 completion blocks 返回错误，表明函数中的异步逻辑可能会导致错误：

```swift
func attachImageToData(
    imageResponse: URLResponse, 
    dataResponse: URLResponse, 
    completion: ((Error?) -> Void)?
)
```

使用 async 允许 attachImageToData 函数利用 throws，与其他非异步函数用于错误的语法相匹配：

```swift
func attachImageToData(
    imageResponse: URLResponse, 
    dataResponse: URLResponse) async throws
```

## Async Return Value

在以前的 Swift 版本中，一些 completion blocks 除了潜在的错误之外还包含其他类型。这些其他类型在逻辑上通常是异步逻辑的返回类型：

```swift
func uploadImage(
    image: UIImage, 
    completion: ((URLResponse?, Error?) -> Void)?
)

func uploadData(
    data: Data, 
    completion: ((URLResponse?, Error?) -> Void)?
)
```

使用 async 允许 uploadImage 和 uploadData 函数利用预期的返回类型定义 -> URLResponse，匹配其他非异步函数的语法：

```swift
func uploadImage(image: UIImage) async throws -> URLResponse
    
func uploadData(data: Data) async throws -> URLResponse
```

# Await


await 关键字用于告诉 Swift 等待异步函数的完成：

```swift
// Await completion of saveChanges
await saveChanges()
```

如果使用 await 调用多个异步函数，Swift 将等待每个函数完成，然后再移动到下一个函数：

```swift
// Await completion of uploadData before moving to saveChanges
await uploadData(data: Data())

// Await completion of saveChanges before moving forward
await saveChanges()
```

## Await Throws

与可以抛出的非异步函数一样，try 可以用于异步函数，结合 await 调用异步函数并在发生错误时抛出：


```swift
try await attachImageToData(
    imageResponse: imageResponse, 
    dataResponse: dataResponse
)
```

## Async Let

在某些情况下，异步逻辑需要异步函数的返回值。 async let 语法可用于将 let 变量标记为异步，这意味着 let 变量将在一些异步逻辑完成后可用：


```swift
async let imageResponse = try uploadImage(
    image: image
)
```

## Async Await Let


组合多个 async let 语句将使 Swift 能够并行执行异步逻辑：

```swift
// ImageResponse 和 dataResponse 将并行获取
async let imageResponse = try uploadImage(
    image: image
)

async let dataResponse = try uploadData(
    data: data
)
```

要等待之前的 async let 变量完成，请在需要初始化 let 变量时使用 await：

```swift
try await attachImageToData(
    imageResponse: await imageResponse, 
    dataResponse: await dataResponse
)
```

或者，使用 await 来控制并发并一次只获取一个值：

```swift
// By using await, uploadImage 
// will be called first
let imageResponse = try await uploadImage(
    image: image
)

// By using await on uploadImage, 
// uploadData will be called after 
// imageResponse is initialized
let dataResponse = try await uploadData(
    data: data
)
```

## Async Await Example

这篇文章中的异步等待示例将引用以下异步函数：

```swift
func uploadImage(image: UIImage) 
    async -> URLResponse

func uploadData(data: Data) 
     async throws -> URLResponse

func attachImageToData(
    imageResponse: URLResponse, 
    dataResponse: URLResponse) async throws

func saveChanges() async throws
```

结合多个异步调用和返回值的异步等待示例：

```swift
// Define an asynchronous function uploadTask that 
// will contain multiple async function calls
func uploadTask(
    image: UIImage, 
    data: Data) async throws {

    // Perform the following async functions 
    // at the same time
    async let imageResponse = try uploadImage(
        image: image
    )

    async let dataResponse = try uploadData(
        data: data
    )
    
    // Wait for completion of attachImageToData 
    // before moving forward
    try await attachImageToData(
        imageResponse: await imageResponse, 
        dataResponse: await dataResponse
    )

    // Wait for completion of saveChanges 
    // before moving forward
    try await saveChanges()
}
```

## Call Async Function From Non Async Code

初始化一个任务以从非异步代码调用异步函数：

```swift
func userTappedUpload() {
    Task(priority: .default) {
        do {
            try await self.upload(
                image: UIImage(), 
                data: Data()
            )
        }
        catch {
            // Handle error
        }
    }
}
```

## Async Await vs Closures

使用 async 和 await 的一个好处是更容易阅读 Swift 代码。如果本文中介绍的异步函数 uploadTask 被重写为仅使用完成闭包，则该函数具有难以阅读的深层嵌套回调结构：

```swift
func uploadTask(
    image: UIImage, 
    data: Data, 
    completion: ((Error?) -> Void)?) {

    uploadImage(image: image) { imageResponse in
        // Verify imageResponse is successful
        
        self.uploadData(data: data) { 
            dataResponse, dataError in

            // Handle dataError if dataError != nil
            
            self.attachImageToData(
                imageResponse: imageResponse!, 
                dataResponse: dataResponse!) { 
                attachError in

                // Handle attachError if 
                // attachError != nil
                
                self.saveChanges() {
                    completion?(nil)
                }
            }
        }
    }
}

// Example calling upload
upload(image: UIImage(), data: Data()) { error in
    if let error = error {
        // Handle error
    }
}
```

## Asynchronous Programming In Swift

仅此而已！通过使用 async 和 await，您可以在 Swift 中实现带有回调和异步逻辑的异步任务。
