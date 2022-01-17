> 原文：[Guard statements in Swift explained with code examples](https://www.avanderlee.com/swift/guard-statements/)



Swift 中的 Guard 语句允许我们在代码中实现检查，防止当前作用域继续执行。在编写代码时，我们经常需要在继续运行一个方法之前执行一些必要条件。一个例子是在提交表单前解包一个可选类型的输入字段。

必要条件可以是一个需要为真的布尔值，或者解包一个不能为 `nil` 的可选类型。我们可以使用 `guard` 语句来实现这一点，但也可以选择使用 `if let` 语句。问题是：什么时候使用哪个？让我们深入了解一下。



## 什么是 guard 语句

你可以把 `guard` 语句看作是一个安全卫士，它执行条件检查以确保你的代码被允许继续。一个 `guard` 语句看起来如下：

```swift
guard <condition> else {
    return
}
```

`guard` 语句的条件必须是布尔类型的。条件也可以是一个可选类型的解包语句。一个表单提交方法的例子可以如下：

```swift
struct FormSubmitter {
    var optionalInputName: String?
    var isFormRequestRunning: Bool

    func submit() {
        guard let inputName = optionalInputName, isFormRequestRunning == false else {
            return
        }
        // Continue form submission
    }
}
```

你可以看到，只有当输入名称存在并且没有运行的表单请求时，提交才会继续。`guard` 语句的闭包内的 `return` 关键字是编译器要求并强制执行的，确保我们要求的条件。一旦有未满足的条件，你可以使用下面的关键字来退出作用域：

* `return`：退出作用域，不继续进行或抛出一个错误
* `break`：用于退出一个枚举的 switch-case 条件。
* `continue`：用于继续一个 `for-loop`。
* `throw`：用于抛出一个错误以表示失败。



## 分割 guard 状态

上面的 `guard` 语句效果很好，但你可以说，把语句分成两部分更好。这样做可以让我们在每个条件下抛出一个特定的错误，并使我们能够更好地调试任何问题。这样的实现可以如下：

```swift
struct FormSubmitter {
    enum FormSubmissionError: Error {
        case missingInputName
        case formRequestRunning
    }
    var optionalInputName: String?
    var isFormRequestRunning: Bool

    func submit() throws {
        guard let inputName = optionalInputName else {
            throw FormSubmissionError.missingInputName
        }
        guard isFormRequestRunning == false else {
            throw FormSubmissionError.formRequestRunning
        }
        // Continue form submission
    }
}
```

上面的实现效果更好，因为它为每个未满足的条件抛出一个特定的错误。表格提交方法的实现者可以明确地处理每个错误。

抛出一个错误也被看作是一个早期的退出，并取消了使用 `return` 关键字的要求。



## 什么时候在 `if let` 语句上使用 `guard`

Guard vs. if let：什么时候用哪个？根据我的经验，这是 Swift 中最有意见的部分之一。我曾在拉动请求审查期间与我在 WeTransfer 的团队进行过几次讨论，争论是否要使用 Guard 语句。

你可以把提交方法的例子写成如下：

```swift
func submit() throws {
    if let inputName = optionalInputName, isFormRequestRunning == false {
        // Continue form submission
    }
}
```

这样做很好，在继续提交之前确保条件得到满足。然而，一旦条件为假，编译器将不会强制我们返回作用域。由于没有强制返回，我们有可能会遇到无法预料的错误。一个简单的例子是一个打印语句，它使我们认为提交成功了：

```swift
func submit() throws {
    if let inputName = optionalInputName, isFormRequestRunning == false {
        // Continue form submission
    }
    print("Submission succeeded")
}
```

在上面的例子中，打印语句总是被执行。我们可以通过使用 `if else` 实现来解决这个问题：

```swift
func submit() throws {
    if let inputName = optionalInputName, isFormRequestRunning == false {
        // Continue form submission
    } else {
        return
    }
    print("Submission succeeded")
}
```

或者把打印语句移到条件检查的正文中：

```swift
func submit() throws {
    if let inputName = optionalInputName, isFormRequestRunning == false {
        // Continue form submission
        print("Submission succeeded")
    }
}
```

然而，在我看来，使用 `guard` 语句来代替它要好得多：

```swift
func submit() throws {
    guard let inputName = optionalInputName else {
        throw FormSubmissionError.missingInputName
    }
    guard isFormRequestRunning == false else {
        throw FormSubmissionError.formRequestRunning
    }
    // Continue form submission

    print("Submission succeeded")
}
```

### 那么，我是否应该永远不使用 `if let` 语句呢？

我听到了你的想法：

> *“Should I always use a guard statement over an if let?”*

当然不是的，在一些例子中，你希望你的代码能够继续下去，即使有一个未满足的条件。在这种情况下，我们不能使用 `guard` 语句，因为这将迫使我们退出当前的范围。

例如，我们可能想取消正在运行的请求，然后马上继续新的提交。

```swift
func submitForm() throws {
    guard let inputName = optionalInputName else {
        throw FormSubmissionError.missingInputName
    }

    if isFormRequestRunning {
        cancelRunningRequest()
    }

    // Continue form submission

    print("Submission succeeded")
}
```

我把 `guard` 作为一种描述方法要求的方式。`guard` 语句使我能够防止错误，并确保在执行函数的实际体之前设置条件。



## 使用 `guard` 的好处

综上所述，`guard` 语句有几个好处，可以帮助我们编写更好的代码。简单介绍一下：

* 由编译器强制退出：我们必须抛出一个错误或使用 `return` 关键字。这个要求可以防止我们写出在条件不满足的情况下执行代码的错误。
* 对方法要求的清晰描述。`guard` 明确指出，在函数主体被执行之前，这些条件应该被满足。
* 提高了可读性，因为 `guard` 会立即向你解释必要的条件。



### 总结

使用 `guard` 语句是一种很好的方式，可以确保在执行方法的内部主体之前所有的条件都是真的。利用 `guard`，我们表明了对一个特定函数的要求。在有些情况下，将语句分割开来更有意义，可以给实现者以详细的反馈。如果方法在有未满足的条件时被允许继续，你可以使用 `if let` 语句。

如果你喜欢学习更多关于 Swift 的技巧，请查看 [Swift 分类](https://www.avanderlee.com/category/swift/)页面。如果你有任何其他建议或反馈，请随时联系我或在 Twitter 上推送我。

谢谢!











































