# 在 Swift 中对 UIView 动作和手势进行单元测试

> 原文：[Unit testing UIView action and gesture in Swift @20210820](https://benoitpasquier.com/unit-testing-uiview-action-gesture-swift/)



开发人员的大部分旅程都是在确保我们的代码按预期运行。最好的做法是设置测试，使我们能够快速且频繁测试以确保没有任何问题。如果单元测试是检查业务逻辑的常见做法，我们还可以扩展它以涵盖一些特定的 UI 行为。让我们来看看如何在 UIKit 中对视图和手势进行单元测试。

对于本文，我构建了一个非常简单的应用程序，其中包含可以添加或删除到我的购物车中的水果。

<img src="https://benoitpasquier.com/images/2021/08/unit-test-view-sample.png" style="zoom: 67%;" />

在深入研究代码之前，让我们复习一些测试概念。在计算机科学中，我们可以进行不同层次的测试，每一层都代表团队的安全网，以确保一切按预期工作：

**Unit testing（单元测试）**：一套测试，涵盖特定的自包含代码、一个 unit 单元，如文件或类。如果失败，则需要修复您的设备。

**Integration testing（集成测试）**：一套涵盖两个单元之间交互的测试。失败时，交互无法按预期工作。

**Regression testing（回归测试）**：这是整个项目的完整测试套件。通过运行它，我们确保最后一个贡献没有破坏其他任何东西。失败时，应用程序不会像以前那样运行。

**Acceptance testing（验收测试）**：这是更高级别的测试，很可能由质量保证团队执行，以检查新功能是否符合要求。它通常基于业务 / 客户 / 堆栈持有者的需求。它回答了 “我们是否构建了正确的东西？” 这个问题。

**Functional testing / end-to-end testing（功能测试 / 端到端测试）**：它描述了功能本身并回答了 “我们是否构建了一个可正常工作的产品？” 的问题。它涵盖的不仅仅是验收标准，确保错误处理和 “它不应该发生” 场景实际上并没有发生。

---

就我而言，我想确保某些手势和点击按钮正在执行正确的 Block 块。因此它位于单元测试 / 集成测试之间，具体取决于每个视图集成。

我使用了 [MVVM 架构设计模式](https://benoitpasquier.com/ios-swift-mvvm-pattern/) 来简化每一层的测试。话虽如此，我将继续专注于 View 层，这就是我今天感兴趣的地方。

让我们从测试按钮开始。



## 单元测试 UIButton action

每个 cell 都包含一个 `UILabel` 和两个用于添加或删除购物车的 `UIButton`。当点击一个按钮时，它会执行一个与该动作匹配的闭包。

```swift
class CustomCell: UITableViewCell {
    
    // 添加按钮
    private(set) lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 删除按钮
    private(set) lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(tapRemoveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Actions

    var didTapAdd: (() -> Void)?
    @objc private func tapAddButton() {
        didTapAdd?()
    }
    
    var didTapRemove: (() -> Void)?
    @objc private func tapRemoveButton() {
        didTapRemove?()
    }

    // ... more code ...
```

在这里，我想添加一个测试，当按钮接收到 `touchUpInside` 时，将执行匹配的闭包。

好在 `UIButton` 有一个可以直接发送 Action 的功能。所以让我们用它来测试执行的闭包。

```swift
import XCTest
@testable import ViewSample

class CustomCellTests: XCTestCase {

    func test_did_tap_add_succeed_when_touch_up_inside() {
        // Given:
        let tapAddExpectation = expectation(description: #function)
        let cell = CustomCell(style: .default, reuseIdentifier: "id")
        cell.didTapAdd = {
            tapAddExpectation.fulfill()
        }
    
        // When:
        cell.addButton.sendActions(for: .touchUpInside)
        
        // Then:
        wait(for: [tapAddExpectation], timeout: 0.1)
    }
}
```

对于这个测试，我使用了一个 `XCTestExpectation`，我在闭包中传递了它来知道它什么时候被执行。这也意味着测试将不得不等待它完成。

异步测试并不理想，但视图实际上从不渲染，因此它应该几乎立即执行。在更糟糕的情况下，当失败时，延迟会低于 0.1 秒，这可能是失败的合理时间。

到现在为止还挺好。

我们还可以围绕这个功能测试什么？我们可以确保另一种类型的操作不会执行闭包。

```swift
func test_did_tap_add_fail_when_touch_down() {
    // Given:
    let cell = CustomCell(style: .default, reuseIdentifier: "id")
    cell.didTapAdd = {
        XCTFail("unexpected trigger")
    }

    // When:
    cell.addButton.sendActions(for: .touchUpInside)
}
```

当我执行这个测试时，它首先由于 `XCTFail` 而失败。这是意料之中的，因为发送的操作仍然是 `touchUpInside`，我只想检查我们是否不需要使用 `wait (for: ...)` 来失败。

现在我知道另一个操作会按预期失败，然后我们可以编辑该操作。

```swift
func test_did_tap_add_fail_when_touch_down() {
    // Given:
    let cell = CustomCell(style: .default, reuseIdentifier: "id")
    cell.didTapAdd = {
        XCTFail("unexpected trigger")
    }

    // When:
    cell.addButton.sendActions(for: .touchDown)
}
```

好的，到目前为止，我们已经成功地在自定义单元格中对 `UIButton` 操作进行了单元测试，没有太多麻烦。让我们看看我们可以涵盖哪些其他手势。



## **单元测试 UIView 点击手势**

在我的 `ViewController` 中，我有一个 `UIView`，用户必须点击它才能继续结帐。我可以使用 `UIButton`，但由于我们想检查其他测试（并学习新事物），所以这次我们使用 `UIView` 和 `UITapGestureRecognizer`。所以让我们专注于这个领域。

```swift
class ViewController: UIViewController {

    var viewModel: ViewModelProtocol!
    
    init(viewModel: ViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    lazy var checkoutView: UIView = {
        let label = UILabel()
        label.text = "Checkout"
        label.textColor = .white
        label.textAlignment = .center
        
        let view = UIView()
        view.backgroundColor = .blue
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addGestureRecognizer(checkoutTapGesture)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }()
    
    private lazy var checkoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCheckout))

    @objc private func tapCheckout() {
        viewModel.checkout()
    }

    // ... more code
}
```

如前所述，我使用 MVVM 设计模式和面向协议的编程，因此我们可以稍后注入我们自己的 `ViewModelProtocol`。当用户点击 `checkoutView` 时，它将执行 `viewModel.checkout`。

让我们开始测试。

```swift
import XCTest
@testable import ViewSample

class ViewControllerTests: XCTestCase {
    // ...
}

fileprivate class MockViewModel: ViewModelProtocol {
    var addFruitCalled = 0
    var didCallAddFruit: ((Int) -> Void)?
    func addFruit(_ text: String) {
        addFruitCalled += 1
        didCallAddFruit?(addFruitCalled)
    }
    
    var removeFruitCalled = 0
    var didCallRemoveFruit: ((Int) -> Void)?
    func removeFruit(_ text: String) {
        removeFruitCalled += 1
        didCallRemoveFruit?(removeFruitCalled)
    }
    
    var checkoutCalled = 0
    var didCallCheckout: ((Int) -> Void)?
    func checkout() {
        checkoutCalled += 1
        didCallCheckout?(checkoutCalled)
    }
}
```

第一部分是创建模拟的 ViewModel，以便我们可以检测更改。在这种情况下，我使用了两个属性，一个用于计算调用次数，一个用于在执行时获取回调。

第二部分是使用我们测试类的 `setUp` 和 `tearDown` 函数来准备测试环境。

最后，我们可以设置我们的测试。

```swift
class ViewControllerTests: XCTestCase {
    
    private var sut: ViewController!
    fileprivate var viewModel: MockViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = MockViewModel()
        sut = ViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_tap_checkout() {
        // Given:
        let tapCheckoutExpectation = expectation(description: #function)
        XCTAssertEqual(viewModel.checkoutCalled, 0)
        viewModel.didCallCheckout = { counter in
            XCTAssertEqual(counter, 1)
            tapCheckoutExpectation.fulfill()
        }
        
        let tapGestureRecognizer = sut.checkoutView.gestureRecognizers?.first as? UITapGestureRecognizer
        XCTAssertNotNil(tapGestureRecognizer, "Missing tap gesture")
        
        // When:
        tapGestureRecognizer?.state = .ended
        
        // Then:
        wait(for: [tapCheckoutExpectation], timeout: 0.1)
    }
}
```

与 `UIButton` 单元测试类似，我访问视图的手势并手动更改状态。

在闭包中传递调用次数也可以帮助检测是否有多个相同事件的执行。

> *等等，为什么不只是测试 `checkoutCalled` 而不是等待期望。*

不幸的是，这不起作用。手势仍然被异步识别并在下一个运行循环中执行。所以以下方法不起作用：

```swift
// Then:
XCTAssertEqual(viewModel.checkoutCalled, 1) // 🚫 fail
wait(for: [tapCheckoutExpectation], timeout: 0.1)
```

> *还有其他方法可以保持同步吗？*

嗯，是的，也不是。

一种方法是尝试通过 `UIGestureRecognizerTarget` 访问下方手势的 private target。它看起来像这样：

```swift
extension UIGestureRecognizer {
    
    func forceTrigger() throws {
        let gestureRecognizerTarget: AnyClass? = NSClassFromString("UIGestureRecognizerTarget")
        
        let targetIvar = class_getInstanceVariable(gestureRecognizerTarget, "_target")
        let actionIvar = class_getInstanceVariable(gestureRecognizerTarget, "_action")
        
        guard let targets = self.value(forKey: "targets") as? [Any] else {
            throw NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey: "Cannot access targets"])
        }
        
        for gestureTarget in targets {
            guard let targetIvar = targetIvar,
               let actionIvar = actionIvar else {
                continue
            }
                
            if let target = object_getIvar(gestureTarget, targetIvar) as? NSObject,
               let action = object_getIvar(gestureTarget, actionIvar) as? Selector { // 🚫 fail
                target.perform(action)
                return
            }
        }

        throw NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey: "Couldn't find target or action to execute"])
    }
}
```

此代码在运行时访问私有属性 `_action` 和 `_target` 并手动执行它。不幸的是，如果我能到达目标，下一行 `object_getIvar (gestureTarget, actionIvar)` 总是崩溃。没运气。

与 `ViewModel` 类似，我们可以创建一个 `MockTapGestureRecognizer` 来跟踪操作并强制执行，类似于以下内容。

```swift
class MockTapGestureRecognizer: UITapGestureRecognizer {
    
    var target: Any?
    var action: Selector?
    override func addTarget(_ target: Any, action: Selector) {
        self.target = target
        self.action = action
    }
    
    override var state: UIGestureRecognizer.State {
        didSet {
            forceTriggerAction()
        }
    }
    
    func forceTriggerAction() {
        guard let target = target as? NSObject,
              let action = action else { 
            return
        }
        
        target.perform(action)
    }
}
```

如果这听起来更安全，这需要在 `ViewController` 之外公开更多属性和功能。它还需要更多的努力，并且感觉不再对手势执行进行单元测试，而是 `ViewController` 构造。那感觉不对。

另一种解决方案可能是做一些方法调配，但这也偏离了我们的目标。理想情况下，我想测试我的代码行为，而不是改变整个系统来检查它是如何执行的。和以前一样，这似乎不是正确的方法。

如果我们能找到一个同步的解决方案，那将不利于我们过多地修改代码。基于权衡，感觉 0.1 秒的异步测试确实看起来比提到的任何其他解决方案都更平衡。您可以根据自己的需要做出不同的决定。



## 单元测试 UIView 滑动手势

好吧，一旦你有了这个概念，它实际上是任何其他手势的相同方面。那是因为我们正在测试动作，而不是实际的手势。

所以对于滑动，我们不希望改变 `CGPoint` 的位置，我们希望手势能够成功识别它，然后我们检查结果。

```swift
// ViewController
lazy var checkoutView: UIView = {
    let label = UILabel()
    label.text = "Checkout"
    label.textColor = .white
    label.textAlignment = .center
    
    let view = UIView()
    view.backgroundColor = .blue
    view.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addGestureRecognizer(checkoutSwipeGesture)
    
    NSLayoutConstraint.activate([
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    return view
}()

private lazy var checkoutSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeCheckout))


// ViewControllerTests
func test_swipe_checkout() {
    // Given:
    let swipeCheckoutExpectation = expectation(description: #function)
    XCTAssertEqual(viewModel.checkoutCalled, 0)
    viewModel.didCallCheckout = { counter in
        XCTAssertEqual(counter, 1)
        tapCheckoutExpectation.fulfill()
    }
    
    
    let swipeGestureRecognizer = sut.checkoutView.gestureRecognizers?.first as? UISwipeGestureRecognizer
    XCTAssertNotNil(swipeGestureRecognizer, "Missing tap gesture")
    
    // When:
    swipeGestureRecognizer?.state = .ended
    
    // Then:
    wait(for: [swipeCheckoutExpectation], timeout: 0.1)
}
```

今天就到这里了！我们已经成功地为不同的 UI 组件创建了单元测试，确保用户操作和手势在正确的条件下执行正确的Block 块。如果我们必须重新访问这一点，这些测试使我们的项目更安全，更可靠。

此代码在 Github 上作为 [ViewSample](https://github.com/popei69/samples) 提供。

*祝测试愉快🛠*
