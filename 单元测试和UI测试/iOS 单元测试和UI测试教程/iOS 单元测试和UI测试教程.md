> [iOS Unit Testing and UI Testing Tutorial](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial)
>
> 了解如何向 iOS 应用程序添加单元测试和 UI 测试，以及如何检查代码覆盖率。



iOS 单元测试并不迷人，但由于测试可以防止您闪闪发光的应用程序变成充满错误的垃圾，因此它是必要的。如果您正在阅读本教程，您已经知道应该为您的代码和 UI 编写测试，但您可能不知道该怎么做。

您可能有一个工作应用程序，但您想测试您为扩展应用程序所做的更改。也许您已经编写了测试，但不确定它们是否是正确的测试。或者，您已经开始开发一个新的应用程序，并希望随时进行测试。

本教程将向您展示如何：

* 使用 Xcode 的 Test navigator 测试应用程序的模型和异步方法
* 使用 stubs 和 mocks 与库或系统对象进行虚假交互
* 测试用户界面和性能
* 使用代码覆盖率工具（code coverage tool）



在此过程中，您将学习一些测试忍者时使用的词汇。



## 开始

首先使用本教程顶部或底部的“下载材料”按钮下载项目材料。它包括基于 UIKit Apprentice 中的示例应用程序的 `BullsEye` 项目。这是一个简单的机会和运气游戏。游戏逻辑位于 `BullsEyeGame` 类中，您将在本教程中对其进行测试。

## 弄清楚要测试什么

在编写任何测试之前，了解基础知识很重要。你需要测试什么？

如果您的目标是扩展现有应用程序，您应该首先为您计划更改的任何组件编写测试。

通常，测试应涵盖：

* 核心功能：模型类和方法及其与控制器的交互
* 最常见的 UI 工作流程
* 边界条件
* Bug修复

### 了解测试的最佳实践

首字母缩略词 **FIRST** 描述了一组简洁的有效单元测试标准。这些标准是：

* **Fast**：测试应该快速运行。
* **Independent/Isolated**：测试不应该彼此共享状态。
* **Repeatable**：每次运行测试时都应该获得相同的结果。外部数据提供者或并发问题可能会导致间歇性故障。
* **Self-validating**：测试应该是完全自动化的。输出应该是“pass”或“fail”，而不是依赖于程序员对日志文件的解释。
* **Timely**：理想情况下，您应该在编写（用于测试的）生产代码之前编写测试代码。这被称为测试驱动开发（test-driven development）。

遵循 FIRST 原则将使您的测试保持清晰和有用，而不是成为应用程序的障碍。

![img](https://koenig-media.raywenderlich.com/uploads/2021/03/devices_iphone-throwing-tests-300x300.png)

## Xcode 中的单元测试

**Test navigator** 提供了使用测试的最简单方法。您将使用它来创建测试 targets 并针对您的应用运行测试。

### 创建 Unit Test Target

打开 BullsEye 项目并按 Command-6 打开测试导航器。

单击左下角的 +，然后从菜单中选择 New Unit Test Target...：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_1_Introduction_NewUnitTestTarget_annotated-1.png" style="zoom:50%;" />

接受默认名称 **BullsEyeTests**，并输入 **com.raywenderlich** 作为 **Organization Identifier**。当 **test bundle** 出现在测试导航器中时，通过单击显示三角形将其展开，然后单击 **BullsEyeTests** 以在编辑器中打开它。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_2_Introduction_TestFile_annotated.png" style="zoom: 67%;" />

默认模板导入测试框架 **XCTest**，并定义 `XCTestCase` 的子类 `BullsEyeTests`，带有 `setUpWithError()`、`tearDownWithError()` 和示例测试方法。

您可以通过三种方式运行测试：
* **Product** ▸ **Test** 或 **Command-U**。这两个都运行*所有*测试类。
* 单击测试导航器中的箭头按钮。
* 单击 gutter 中的菱形按钮。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_3_Introduction_RunningTest_annotated.png" style="zoom: 67%;" />



您还可以通过单击测试导航器或 gutter 中的菱形来运行单个测试方法。

尝试不同的方法来运行测试，以了解它需要多长时间以及它的外观。样本测试还没有做任何事情，所以它们运行得非常快！

当所有测试都成功后，菱形将变为绿色并显示复选标记。单击 `testPerformanceExample()` 末尾的灰色菱形以打开性能结果：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_4_Intorduction_PerformanceTest.png" style="zoom:67%;" />

本教程不需要 `testPerformanceExample()` 或 `testExample()`，因此请删除它们。



### 使用 XCTAssert 测试模型

首先，您将使用 `XCTAssert` 函数来测试 BullsEye 模型的核心功能： `BullsEyeGame` 是否正确计算了一轮得分？
在 BullsEyeTests.swift 中，在 `import XCTest` 下面添加这一行：

```swift
@testable import BullsEye
```

这使单元测试可以访问 BullsEye 中的内部类型和函数。

在 `BullsEyeTests` 的顶部，添加以下属性：

```swift
var sut: BullsEyeGame!
```

这会为 `BullsEyeGame` 创建一个占位符，它是被测系统 (SUT)，或者此测试用例类与测试相关的对象。
接下来，将 `setUpWithError()` 的内容替换为：

```swift
try super.setUpWithError()
sut = BullsEyeGame()
```

这会在 class 级别创建 `BullsEyeGame`，因此该测试类中的所有测试都可以访问 SUT 对象的属性和方法。

在您忘记之前，请在 `tearDownWithError()` 中释放您的 SUT 对象。将其内容替换为：

```
sut = nil
try super.tearDownWithError()
```

> 注意：最好在 `setUpWithError()` 中创建 SUT 并在 `tearDownWithError()` 中释放它，以确保每个测试都以干净的状态开始。如需更多讨论，请查看 Jon Reid 关于该主题的[帖子](https://qualitycoding.org/xctestcase-teardown/)。



## 编写你的第一个测试

现在您已准备好编写您的第一个测试！

将以下代码添加到 `BullsEyeTests` 的末尾，以测试您是否计算了猜测的预期分数：

```swift
func testScoreIsComputedWhenGuessIsHigherThanTarget() {
  // given
  let guess = sut.targetValue + 5

  // when
  sut.check(guess: guess)

  // then
  XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
}
```

测试方法的名称总是以 **test** 开头，然后是对其测试内容的描述。

将测试格式化为 **given**、**when** 和 **then** 部分是一种很好的做法：

1. **given**：在这里，您可以设置所需的任何值。在此示例中，您创建了一个 `guess` 值，以便您可以指定它与 `targetValue` 的差异程度。
2. **when**：在本节中，您将执行被测试的代码：调用 `check(guess:)`。
3. **then**：这是您将通过在测试失败时打印的消息来断言您期望的结果的部分。在这种情况下，`sut.scoreRound` 应该等于 95，因为它是 100 - 5。

通过单击装订线或测试导航器中的菱形图标运行测试。这将构建并运行应用程序，菱形图标将变为绿色复选标记！您还会在 Xcode 上看到一个短暂的弹出窗口，它也表示成功，如下所示：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/02/tests_5_FirstTest_Success.png" style="zoom:50%;" />

> 注意：要查看 **XCTestAssertions** 的完整列表，请转到 Apple 的[按类别列出的断言](https://developer.apple.com/documentation/xctest#2870839)。



### 调试测试

`BullsEyeGame` 中故意内置了一个错误，您现在将练习查找它。要查看实际中的错误，您将创建一个测试，从给定部分的 `targetValue` 中减去 5，其他所有内容保持不变。

添加以下测试：

```swift
func testScoreIsComputedWhenGuessIsLowerThanTarget() {
  // given
  let guess = sut.targetValue - 5

  // when
  sut.check(guess: guess)

  // then
  XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
}
```

`guess` 和 `targetValue` 之间的差值仍然是 5，所以分数应该仍然是 95。

在断点导航器中，添加一个测试失败断点。当测试方法发布失败断言时，这会停止测试运行。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_6_Debugging_Breakpoint_annotated.png" style="zoom:50%;" />



运行您的测试，它应该会在 `XCTAssertEqual` 行停止并出现测试失败。

在调试控制台中检查 `sut` 和 `guess`：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_7_Debugging_Console_annotated.png" style="zoom: 50%;" />

`guess` 是 `targetValue - 5` 但 `scoreRound` 是 105，而不是 95！

要进一步调查，请使用正常的调试过程：在 `when` 语句和 BullsEyeGame.swift 中的 `check(guess:)` 中设置一个断点，在那里它会产生差异。然后，再次运行测试，并跳过 `let Difference` 语句以检查应用程序中的差异值：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_8_Debugging_Console2_annotated.png" style="zoom: 67%;" />

问题是 `difference` 是负数，所以分数是 `100 - (-5)`。要解决此问题，您应该使用差异的绝对值。在 `check(guess:)` 中，取消注释正确的行并删除不正确的行。

删除两个断点并再次运行测试以确认它现在成功。



### 使用 XCTestExpectation 测试异步操作

现在您已经了解了如何测试模型和调试测试失败，是时候继续测试异步代码了。

BullsEyeGame 使用 `URLSession` 获取一个随机数作为下一场比赛的目标。 `URLSession` 方法是异步的：它们立即返回，但直到稍后才完成运行。要测试异步方法，请使用 `XCTestExpectation` 让您的测试等待异步操作完成。

异步测试通常很慢，因此您应该将它们与更快的单元测试分开。

创建一个名为 BullsEyeSlowTests 的新单元测试目标。打开全新的测试类 BullsEyeSlowTests 并在现有 `import` 语句下方导入 BullsEye 应用程序模块：

```swift
@testable import BullsEye
```

这个类中的所有测试都使用默认的 `URLSession` 来发送请求，所以声明 `sut`，在 `setUpWithError()` 中创建，在`tearDownWithError(`)中释放。为此，请将 BullsEyeSlowTests 的内容替换为：

```swift
var sut: URLSession!

override func setUpWithError() throws {
  try super.setUpWithError()
  sut = URLSession(configuration: .default)
}

override func tearDownWithError() throws {
  sut = nil
  try super.tearDownWithError()
}
```

接下来，添加这个异步测试：

```swift
// Asynchronous test: success fast, failure slow
func testValidApiCallGetsHTTPStatusCode200() throws {
    // given
    let urlString = "http://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1"
    let url = URL(string: urlString)!
    // 1⃣️ expectation(description:) 描述期望发生的事
    let promise = expectation(description: "Status code: 200")

    // when
    let dataTask = sut.dataTask(with: url) { _, response, error in
        // then
        if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
                // 2⃣️ promise.fulfill() 在异步方法的完成处理程序的成功条件中调用它，标记已满足期望
                promise.fulfill()
            } else {
                XCTFail("Status code: \(statusCode)")
            }
        }
    }
    dataTask.resume()
    // 3⃣️ wait(for:timeout:) 保持测试运行，知道满足所有期望，或者运行超时
    wait(for: [promise], timeout: 5)
}
```

此测试检查发送有效请求是否返回 200 状态代码。大部分代码与您在应用程序中编写的代码相同，只是添加了以下几行：

* **expectation(description:)**：返回 `XCTestExpectation`，存储在 `promise` 中。描述了您期望发生的事情。
* **promise.fulfill()**：在异步方法的完成处理程序的成功条件闭包中调用它以标记已满足期望。
* **wait(for:timeout:)**：保持测试运行，直到满足所有期望或超时间隔结束，以先发生者为准。

运行测试。如果您已连接到 Internet，则在模拟器中加载应用程序后，测试应该需要大约一秒钟才能成功。



### 快速失败

失败是痛苦的，但它不必永远持续下去。

要体验失败，只需将 `testValidApiCallGetsHTTPStatusCode200()` 中的 `URL` 更改为无效的 `URL`：

```swift
let url = URL(string: "http://www.randomnumberapi.com/test")!
```

运行测试。它失败了，但它需要完整的超时间隔！这是因为你假设请求总是成功的，这就是你调用 `promise.fulfill(`) 的地方。由于请求失败，它仅在超时到期时才完成。

您可以通过更改假设来改进这一点并让测试更快地失败。与其等待请求成功，不如等待异步方法的完成处理程序被调用。一旦应用程序收到来自服务器的响应（OK 或错误），就会发生这种情况，这满足了预期。然后您的测试可以检查请求是否成功。

要查看其工作原理，请创建一个新测试。

但首先，通过撤消对 url 所做的更改来修复之前的测试。

然后，将以下测试添加到您的类中：

```swift
func testApiCallCompletes() throws {
  // given
  let urlString = "http://www.randomnumberapi.com/test"
  let url = URL(string: urlString)!
  let promise = expectation(description: "Completion handler invoked")
  var statusCode: Int?
  var responseError: Error?

  // when
  let dataTask = sut.dataTask(with: url) { _, response, error in
    statusCode = (response as? HTTPURLResponse)?.statusCode
    responseError = error
    promise.fulfill()
  }
  dataTask.resume()
  wait(for: [promise], timeout: 5)

  // then
  XCTAssertNil(responseError)
  XCTAssertEqual(statusCode, 200)
}
```

关键区别在于，只需输入完成处理程序即可满足预期，而这只需要大约一秒钟的时间。如果请求失败，则 `then` 断言失败。

运行测试。现在应该大约需要一秒钟才能失败。它失败是因为请求失败，而不是因为测试运行超过超时。

修复 `url`，然后再次运行测试以确认它现在成功。



### 有条件地失败

在某些情况下，执行测试没有多大意义。例如，当 `testValidApiCallGetsHTTPStatusCode200()` 在没有网络连接的情况下运行时会发生什么？当然，它不应该通过，因为它不会收到 200 状态码。但它也不应该失败，因为它没有测试任何东西。

幸运的是，Apple 引入了 `XCTSkip` 在先决条件失败时跳过测试。在 `sut` 的声明下方添加以下行：

```swift
let networkMonitor = NetworkMonitor.shared
```

`NetworkMonitor` 包装了 `NWPathMonitor`，提供了一种方便的方法来检查网络连接。

在 `testValidApiCallGetsHTTPStatusCode200()` 中，在测试开头添加 `XCTSkipUnless`：

```swift
try XCTSkipUnless(
  networkMonitor.isReachable, 
  "Network connectivity needed for this test.")
```

`XCTSkipUnless(_:_:)` 在没有网络可达时跳过测试。通过禁用网络连接并运行测试来检查这一点。您会在测试旁边的装订线中看到一个新图标，表示测试既没有通过也没有失败。

![](https://koenig-media.raywenderlich.com/uploads/2021/02/tests_9_Skipping.png)

再次启用您的网络连接并重新运行测试以确保它在正常情况下仍然成功。将相同的代码添加到 `testApiCallCompletes()` 的开头。



## 伪造对象和交互

异步测试让您确信您的代码会为异步 API 生成正确的输入。您可能还想测试您的代码在接收来自 `URLSession` 的输入时是否正常工作，或者它是否正确更新了 `UserDefaults` 数据库或 iCloud 容器。

大多数应用程序与系统或库对象交互 - 您无法控制的对象。与这些对象交互的测试可能很慢且不可重复，违反了 **FIRST** 原则中的两个。相反，您可以通过从存根获取输入或更新模拟对象来伪造交互。

当您的代码依赖于系统或库对象时，请使用伪造（fakery）。通过创建一个假对象来扮演该角色并将这个假对象注入到您的代码中来做到这一点。 Jon Reid 的 [Dependency Injection](https://www.objc.io/issues/15-testing/dependency-injection/) 描述了几种方法来做到这一点。



### 从存根伪造输入

现在，检查应用程序的 `getRandomNumber(completion:)` 是否正确解析了会话下载的数据。您将使用存根数据伪造 `BullsEyeGame` 的会话。

转到 Test navigator，单击 + 并选择 **New Unit Test Class...**。将其命名为 **BullsEyeFakeTests**，将其保存在 **BullsEyeTests** 目录中并将目标设置为 **BullsEyeTests**。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_10_Stub_NewTestClass_annotated.png" style="zoom:67%;" />



在 `import` 语句下方导入 BullsEye 应用程序模块：

```swift
@testable import BullsEye
```

现在，将 `BullsEyeFakeTests` 的内容替换为：

```swift
var sut: BullsEyeGame!

override func setUpWithError() throws {
  try super.setUpWithError()
  sut = BullsEyeGame()
}

override func tearDownWithError() throws {
  sut = nil
  try super.tearDownWithError()
}
```

这声明了 SUT，即 `BullsEyeGame`，在 `setUpWithError()` 中创建它并在 `tearDownWithError()` 中释放它。
BullsEye 项目包含支持文件 URLSessionStub.swift。这定义了一个名为 `URLSessionProtocol` 的简单协议，其中包含一个使用 `URL` 创建数据任务的方法。它还定义了符合该协议的 `URLSessionStub`。它的初始化程序允许您定义数据任务应返回的数据、响应和错误。

要设置伪造，请转到 BullsEyeFakeTests.swift 并添加一个新测试：

```swift
func testStartNewRoundUsesRandomValueFromApiRequest() {
  // given
  // 1
  let stubbedData = "[1]".data(using: .utf8)
  let urlString = 
    "http://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1"
  let url = URL(string: urlString)!
  let stubbedResponse = HTTPURLResponse(
    url: url, 
    statusCode: 200, 
    httpVersion: nil, 
    headerFields: nil)
  let urlSessionStub = URLSessionStub(
    data: stubbedData,
    response: stubbedResponse, 
    error: nil)
  sut.urlSession = urlSessionStub
  let promise = expectation(description: "Value Received")

  // when
  sut.startNewRound {
    // then
    // 2
    XCTAssertEqual(self.sut.targetValue, 1)
    promise.fulfill()
  }
  wait(for: [promise], timeout: 5)
}
```

这个测试做了两件事：

1. 您设置假数据和响应并创建假会话对象。最后，将假会话作为 `sut` 的属性注入应用程序。
2. 您仍然必须将其编写为异步测试，因为存根伪装成异步方法。检查调用 `startNewRound(completion:)` 是否通过将 `targetValue` 与存根的假数字进行比较来解析假数据。

运行测试。它应该很快就会成功，因为没有任何真正的网络连接！



### 伪造模拟对象的更新

之前的测试使用存根来提供来自假对象的输入。接下来，您将使用一个模拟对象来测试您的代码是否正确更新了 `UserDefaults`。

这个应用程序有两种游戏风格。用户可以：

* 移动滑块以匹配目标值。
* 从滑块位置猜测目标值。

右下角的分段控件切换游戏风格并将其保存在 `UserDefaults` 中。

您的下一个测试检查应用程序是否正确保存了 `gameStyle` 属性。

向目标 **BullsEyeTests** 添加一个新的测试类并将其命名为 **BullsEyeMockTests**。在 import 语句下面添加以下内容：

```swift
@testable import BullsEye

class MockUserDefaults: UserDefaults {
  var gameStyleChanged = 0
  override func set(_ value: Int, forKey defaultName: String) {
    if defaultName == "gameStyle" {
      gameStyleChanged += 1
    }
  }
}
```

`MockUserDefaults` 重写了 `set(_:forKey:)` 方法以增加 `gameStyleChanged`。类似的测试通常会设置一个 Bool 变量，但递增 Int 会给您更大的灵活性。例如，您的测试可以检查应用程序是否只调用该方法一次。

接下来，在 **BullsEyeMockTests** 中声明 SUT 和模拟对象：

```swift
var sut: ViewController!
var mockUserDefaults: MockUserDefaults!
```

将 `setUpWithError()` 和 `tearDownWithError()` 替换为：

```swift
override func setUpWithError() throws {
  try super.setUpWithError()
  sut = UIStoryboard(name: "Main", bundle: nil)
    .instantiateInitialViewController() as? ViewController
  mockUserDefaults = MockUserDefaults(suiteName: "testing")
  sut.defaults = mockUserDefaults
}

override func tearDownWithError() throws {
  sut = nil
  mockUserDefaults = nil
  try super.tearDownWithError()
}
```

这将创建 SUT 和模拟对象，并将模拟对象作为 SUT 的属性注入。

现在，将模板中的两个默认测试方法替换为：

```swift
func testGameStyleCanBeChanged() {
  // given
  let segmentedControl = UISegmentedControl()

  // when
  XCTAssertEqual(
    mockUserDefaults.gameStyleChanged, 
    0, 
    "gameStyleChanged should be 0 before sendActions")
  segmentedControl.addTarget(
    sut,
    action: #selector(ViewController.chooseGameStyle(_:)),
    for: .valueChanged)
  segmentedControl.sendActions(for: .valueChanged)

  // then
  XCTAssertEqual(
    mockUserDefaults.gameStyleChanged, 
    1, 
    "gameStyle user default wasn't changed")
}
```

when 断言是在测试方法更改分段控件之前，`gameStyleChanged` 标志为 0。因此，如果 then 断言也为真，则意味着 `set(_:forKey:)` 只被调用了一次。

运行测试。它应该成功。



## Xcode 中的 UI 测试

UI 测试允许您测试与用户界面的交互。 UI 测试的工作原理是通过查询找到应用程序的 UI 对象，合成事件，然后将事件发送到这些对象。该 API 使您能够检查 UI 对象的属性和状态，以将它们与预期状态进行比较。

在测试导航器中，添加一个新的 **UI Test Target**。检查要测试的目标是 **BullsEye**，然后接受默认名称 **BullsEyeUITests**。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_11_UITests_NewUITestTarget_annotated.png" style="zoom:67%;" />



打开 BullsEyeUITests.swift 并在 BullsEyeUITests 类的顶部添加此属性：

```swift
var app: XCUIApplication!
```

删除 `tearDownWithError()` 并将 `setUpWithError()` 的内容替换为以下内容：

```swift
try super.setUpWithError()
continueAfterFailure = false
app = XCUIApplication()
app.launch()
```

删除两个现有测试并添加一个名为 `testGameStyleSwitch()` 的新测试。

```swift
func testGameStyleSwitch() {    
}
```

在 `testGameStyleSwitch()` 中添加新行，然后单击编辑器窗口底部的红色记录按钮：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_12_UITests_Record_annotated.png" style="zoom:67%;" />

这会通过将您的交互记录为测试命令的模式在模拟器中打开应用程序。应用加载后，点击用于切换游戏风格的 **Slide** 开关和页面顶部的静态文本框。再次单击 Xcode Record 按钮以停止录制。

您现在在 `testGameStyleSwitch()` 中有以下三行：

```swift
let app = XCUIApplication()
app.buttons["Slide"].tap()
app.staticTexts["Get as close as you can to: "].tap()
```

记录器已创建代码来测试您在应用程序中测试的相同操作。轻按一下游戏风格的 segmented 控件和顶部标签。您将使用这些作为基础来创建您自己的 UI 测试。如果您看到任何其他陈述，只需将其删除。

第一行复制了您在 `setUpWithError()` 中创建的属性，因此请删除该行。你还不需要点击任何东西，所以还要删除第 2 行和第 3 行末尾的 `.tap()`。现在，打开 `["Slide"]` 旁边的小菜单并选择 `segmentedControls.buttons["Slide"]`。

![](https://koenig-media.raywenderlich.com/uploads/2021/02/tests_13_UITests_ChangeRecording-650x145.png)

你应该剩下：

```swift
app.segmentedControls.buttons["Slide"]
app.staticTexts["Get as close as you can to: "]
```

点击任何其他对象，让记录器帮助你找到可以在测试中访问的代码。现在，用此代码替换这些行以创建 **given** 部分：

```swift
// given
let slideButton = app.segmentedControls.buttons["Slide"]
let typeButton = app.segmentedControls.buttons["Type"]
let slideLabel = app.staticTexts["Get as close as you can to: "]
let typeLabel = app.staticTexts["Guess where the slider is: "]
```

现在您已经有了 segmented 控件中两个按钮的名称和两个可能的顶部标签，请在下面添加以下代码：

```swift
// then
if slideButton.isSelected {
  XCTAssertTrue(slideLabel.exists)
  XCTAssertFalse(typeLabel.exists)

  typeButton.tap()
  XCTAssertTrue(typeLabel.exists)
  XCTAssertFalse(slideLabel.exists)
} else if typeButton.isSelected {
  XCTAssertTrue(typeLabel.exists)
  XCTAssertFalse(slideLabel.exists)

  slideButton.tap()
  XCTAssertTrue(slideLabel.exists)
  XCTAssertFalse(typeLabel.exists)
}
```

当你在 segmented 控件中的每个按钮上 `tap()` 时，这将检查是否存在正确的标签。运行测试——所有断言都应该成功。

## 测试性能

来自 [Apple Documents](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/04-writing_tests.html#//apple_ref/doc/uid/TP40014132-CH4-SW8)

> 性能测试获取您想要评估的代码块并运行十次，收集平均执行时间和运行的标准偏差。这些单独测量的平均值形成了测试运行的值，然后可以将其与基线（*baseline*）进行比较以评估成功或失败。

编写性能测试很简单：只需将要测量的代码放入 `measure()` 的闭包中即可。此外，您可以指定要衡量的多个指标。

将以下测试添加到 BullsEyeTests：

```swift
func testScoreIsComputedPerformance() {
  measure(
    metrics: [
      XCTClockMetric(), 
      XCTCPUMetric(),
      XCTStorageMetric(), 
      XCTMemoryMetric()
    ]
  ) {
    sut.check(guess: 100)
  }
}
```

该测试测量多个指标：

* `XCTClockMetric` 测量经过的时间。
* `XCTCPUMetric` 跟踪 CPU 活动，包括 CPU 时间、周期和指令数。
* `XCTStorageMetric` 告诉您测试代码写入存储的数据量。
* `XCTMemoryMetric` 跟踪使用的物理内存量。

运行测试，然后单击 `measure()` 尾随闭包开头旁边显示的图标以查看统计信息。您可以更改度量旁边的选定度量。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_14_2_PerformanceTests_Result_annotated.png" style="zoom: 50%;" />

单击 **Set Baseline** 以设置参考时间。再次运行性能测试并查看结果——它可能比基线更好或更差。编辑按钮允许您将基线重置为这个新结果。

基线是按设备配置存储的，因此您可以在多个不同的设备上执行相同的测试。每个都可以根据特定配置的处理器速度、内存等保持不同的基线。

每当您对可能影响被测试方法性能的应用程序进行更改时，请再次运行性能测试以查看它与基线的比较情况。

## 启用代码覆盖率

代码覆盖率工具会告诉你测试实际运行的应用程序代码，因此您知道应用程序的哪些部分没有经过测试——至少目前还没有。

要启用代码覆盖率，请编辑 scheme 的 **Test** 操作并选中选项选项卡下的收集覆盖率（*Gather coverage for*）复选框：

Product -> Scheme -> Edit Scheme ...

<img src="https://koenig-media.raywenderlich.com/uploads/2021/03/tests_15_Coverage_GatherCoverage_annotated.png" style="zoom: 67%;" />



使用 **Command-U** 运行所有测试，然后使用 **Command-9** 打开报告导航器。在该列表的顶部项目下选择 **Coverage**：

![](https://koenig-media.raywenderlich.com/uploads/2021/03/tests_16_Coverage_Log_annotated.png)

单击显示三角形以查看 **BullsEyeGame.swift** 中的函数和闭包列表：

![](https://koenig-media.raywenderlich.com/uploads/2021/02/tests_17_Coverage_Details.png)

滚动到 `getRandomNumber(completion:)` 以查看覆盖率为 95.0%。

单击此函数的箭头按钮以打开该函数的源文件。当您将鼠标悬停在右侧边栏中的覆盖注释上时，代码部分会突出显示绿色或红色：

![](https://koenig-media.raywenderlich.com/uploads/2021/02/tests_18_Coverage_Code.png)

覆盖注释显示测试命中每个代码部分的次数。未调用的部分以红色突出显示。

### 实现 100% 的覆盖率？

你应该尽量努力争取实现 100% 的代码覆盖率吗？只需要谷歌搜索“100% unit test coverage”，您就会发现一系列支持和反对这一点的论据，以及关于“100% 覆盖率”定义的争论。反对它的论点说最后 10%–15% 不值得努力。支持者说最后 10%–15% 是最重要的，因为它很难测试。谷歌“难以对糟糕的设计进行单元测试”以找到有说服力的论点，即[不可测试的代码是更深层次设计问题的标志](https://www.toptal.com/qa/how-to-write-testable-code-and-why-it-matters)。



## 何去何从？

您可以使用本教程顶部或底部的“下载材料”按钮下载项目的完整版本。通过添加您自己的额外测试来继续发展您的技能。

您现在可以使用一些很棒的工具来为您的项目编写测试。我希望这个 iOS 单元测试和 UI 测试教程能给你测试所有东西的信心！

以下是一些进一步研究的资源：

* WWDC 有几个关于测试主题的视频。 WWDC17 中的两个不错的项目是：[Engineering for Testability](https://developer.apple.com/videos/play/wwdc2017/414/) 和 [Testing Tips & Tricks](https://developer.apple.com/videos/play/wwdc2018/417/)。

* 下一步是自动化：**持续集成**和**持续交付**。从我们的教程[与 GitHub、Fastlane & Jenkins 持续集成](https://www.raywenderlich.com/1774995-continuous-integration-with-github-fastlane-jenkins) 和 [Xcode Server for iOS 开始：入门](https://www.raywenderlich.com/12258400-xcode-server-for-ios-getting-started)。
  然后，看看 Apple 的 [Automating the Test Process](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/08-automation.html#//apple_ref/doc/uid/TP40014132-CH7-SW1) with Xcode Server and xcodebuild，以及 [Wikipedia 的持续交付文章](https://en.wikipedia.org/wiki/Continuous_delivery)，它借鉴了 [ThoughtWorks](https://www.thoughtworks.com/continuous-delivery) 的专业知识。
* 如果您已经有一个应用程序但尚未为其编写测试，您可能需要参考 [Michael Feathers 的有效使用遗留代码](https://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052/ref=sr_1_1?s=books&ie=UTF8&qid=1481511568&sr=1-1)，因为没有经过测试的代码就是遗留代码！
* Jon Reid 的 Quality Coding 示例应用程序档案非常适合了解有关[测试驱动开发](http://qualitycoding.org/tdd-sample-archives/)的更多信息。



我们希望您喜欢本教程，如果您有任何问题或意见，请加入下面的论坛讨论！













