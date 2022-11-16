> 原文：[MVVM with RxSwift @Max Alexander](https://academy.realm.io/posts/slug-max-alexander-mvvm-rxswift/)
>
> 20170102



MVVM 是前端工程师的关键设计模式。在 iOS App 中，对象之间有很多方式可以相互交流：委托、回调、通知。在这次 Swift 语言用户组的讲座中，Max Alexander 向你展示了如何用 RxSwift 的 3 种简单模式来简化你的开发过程。他将介绍 MVVM 基础知识，创建自定义观察者，处理不同的 API，以及使用并发和调度队列来操纵调用。你的代码将是如此整洁，以至于你可以辞去你的工作，把它留给下一个人，使其处于无可挑剔的状态。



### 介绍 (00:00)

我是 Max，我将和你谈谈基于 RxSwift 的 MVVM。我谈话的第一部分将是关于 MVVM 的，我们将进入一些代码。

### 重量级视图控制器 (00:51)

MVVM 解决了 MVC 模式（每个人都在开玩笑说 "重量级视图控制器"）。似乎很多工程师都是从视图控制器开始的（感觉很好：当你开始一个新项目时，它已经为你启动了）。你把所有的东西都塞到那里。然后你就不停下来。你多年来都没有停止，然后你就以遗留的应用程序而告终。

很难引进新的工程师，因为每个人都很困惑，不知道什么函数在调用什么，数据应该在哪里，服务类应该在哪里，甚至 UI 应该在哪里。

与其把所有东西都塞进你的视图控制器，我们将做一个模型、视图和 ViewModel。



### 视图 (01:37)

* UIButton
* UITextField
* UITableView
* UICollectionView
* NSLayoutConstraints

这是一种在你的视图控制器中分割东西的方法，然后是两个不同的类。视图是一切正常的，可能是 Interface Builder 给你的。你可能会把 `UITextFields`、`UITableViews` 塞进去，你在它们周围做约束。每个接触过 iOS 或 Mac 开发的人都会经常这样做。如果你有一个 `UIViewController`，它看起来像这样。这就是你开始的方式。

```swift
class LoginViewController : UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton

}
```

然后你就有了模型。



### 模型 (02:10)

"模型" 是一个抽象的术语。它就像来自不同的类的数据。

* CLLocationManager
* Alamofire
* Facebook SDK
* Database like Realm
* Service Classes



它们可以是 Facebook API 与 Twitter API，不同的形状，不同的格式；像 Realm 一样的数据库；以及通用的服务类。很多人说这是一个 POJO（"Plain Old Java Object"）或 POCO（"Plain Old Class Object"）。但这并不重要：这意味着有数据来自某处。如果你有模型类，你可能不会发现导入 `UIKit`。



### ViewModel (02:55)

视图模型：

1. 准备数据
2. 操纵数据

它就在两件事之间。如果你有一个登录视图控制器，你有一个用户名和一个密码字段。然后你有一些你可能会调用的函数，如 Alamofire 或 Facebook API 客户端。你可以看到，它正在准备一些数据，然后你可以调用它。

我没有展示完整的实现，但你可以理解这是在干什么。现在你有一个 LoginViewController，你设置了你的数据成员，然后你有一个 LoginViewModel。

```swift
struct LoginViewModel {

    var username: String = ""
    var password: String = ""

    func attemptToLogin() {
      let params = [
          "username": username,
          "password": password
      ]

      ApiClient.shared.login(email: email, password: password) { (response, error) in
      }
    }
}
```

我们有 `UIViewController` 和 `UIViews`（不管你有什么与视觉表现有关的东西）。它将会有子视图的成员变量。你要创建结构（通常它是一个结构，因为它是某个时间点的数据；不要把它当作一个类来使用）。

```swift
class LoginViewController : UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton

    //viewModel is just a member variable here.
    var viewModel = LoginViewModel()

    override func viewDidLoad(){
        super.viewDidLoad()
    }

}
```

viewModel 是一个有成员变量的结构，它有你要与你的服务类对话的方式。该模型是你的 API，你可以有一个围绕 `CLLocationManager` 的包装器，联系人商店。这些 UI 交互可以调用 ViewModel 中的函数来获取数据。在最后一点代码中，我大概向你展示了 ViewModel 是如何存在的，以及你是如何调用这些其他函数的。

连接用户界面和 ViewModel 并不简单，因为每个人的做法都不同。

```swift
class LoginViewController : UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton

    //viewModel is just a member variable here.
    var viewModel = LoginViewModel()

    override func viewDidLoad(){
        super.viewDidLoad()
      
        usernameTextField.addTarget(self, action:
            #selector(LoginViewController.usernameTextFieldDidChange:_),
            forControlEvents: UIControlEvents.EditingChanged)
      
        passwordTextField.addTarget(self,
            action: #selector(LoginViewController.passworldTextFieldDidChange:_),
            forControlEvents: UIControlEvents.EditingChanged)

    }

    func usernameTextFieldDidChange(textField: UITextField){
      viewModel.username = textField.text ?? ""
    }

    func passworldTextFieldDidChange(textField: UITextField){
      viewModel.password = textField.text ?? ""
    }

    func confirmButtonTapped(sender: UIButton){
      viewModel.attemptLogin()
    }
}
```

你有你的 `IBOutlets`，有 `UIKit` 的类，有 `ViewModel`。在 `viewDidLoad` 中，你可以使用 Interface Builder 在这里偷换事件处理程序。但是，当用户名文本字段改变时，我们要用文本来突变 `viewModel.username`。然后是密码，同样的事情。当一个确认按钮被点击时，你可以把它连接起来，在 `ViewModel` 上调用尝试登录。

这就不那么有趣了，因为我错过了其中的一个重要部分。对变化的事件做出反应的用户界面。我向你展示了视图如何去找 ViewModel。但视图本身必须得到更新：加载指标，确保确认按钮被禁用或启用。

例如，表单验证要到数据中去，然后再回来。这一部分是很难的。在 ViewModel 与 UI 对话的这一部分，每个人都会有不同的做法。这里有一个方法。

```swift
struct LoginViewModel {

    var username: String = "" {
        didSet {
            evaluateValidity()
        }
    }
    var password: String = "" {
        didSet {
            evaluateValidity()
        }
    }
    var isValid : Bool = ""

    func attemptToLogin() {
        let params = [
            "username": username,
            "password": password
        ]
        ApiClient.shared.login(email: email, password: password)
        { (response, error) in

        }
    }
    private func evaluateValidity(){
      isValid = username.characters.count > 0
      && password.characters.count > 0
    }
}
```

人们使用 `didSet` 作为一个反应式处理程序。每当你使用用户界面更新用户名或密码时，你都要调用并评估表单的有效性，以确保用户名中有一些值，或密码；你可以得到你想要的健壮性。

你可以突变 `isValid` 表单。但你如何把它带回表单的 `isDisabled` 或 `isEnabled` 状态？

请确保你正在编辑的 `ViewModel` 文件没有导入过 `UIKit`。它不应该有对 `UIViewController` 的引用。因为它所要做的只是准备数据；它根本就不应该改变数据。`ViewController` 拥有 `ViewModel`。从长远来看，如果你有足够的时间和资源，也要让这些 `ViewModel` 可测试。

千万不要说（代码见幻灯片），"`isValid`，只要是 `didSet`，我就要把确认按钮的那个状态突变为 `isDisabled`。我们创建了一个弱的 `LoginViewController`，我们要在 `viewDidLoad` 中偷工减料，设置它；以后当这两件事启动时，评估有效性，我们要突变这个。"

这不是一个好情况。这意味着你没有得到 MVVM 的任何好处，因为你在说："我将来回推送引用"。另外，你可能会陷入奇怪的情况，你会有一个引用循环，因为一个对象会拥有另一个对象。

我必须做一个附带说明，因为我们有 UI 更新用户名和密码文本字段，这两个字段都在调用同一个东西。你可以看到很多表单，特别是像信用卡表单这样的非常大的表单，通过调用同一个评估周期，可以达到数百行。

我们有两个带 `didSets` 的数据流，调用 valuation validity。这将会调用一个 `isValid`，这将会调用另一个突变。我们把两个不同的事件放在一起，然后对这些数据做一些处理。这在未来可以被大大简化。这都是同步代码 -- 如果我们将来也把它作为异步代码呢？

### 视图模型最坏的做法

* 不要引用视图控制器；
* 不要导入 `UIKit`。让它成为一个不同的文件。
* 不要引用 `UIKit` 的任何东西。(你可能会想，"我需要一个按钮的引用，我把它塞到那里"。不要这样做）。
* 它只应该是数据，即字符串、结构、JSON；没有多少功能的类。

这是我见过的一种模式。`isValid` 现在需要更新 UI 按钮的状态。

```swift
struct LoginViewModel {

    var username: String = "" {
        didSet {
            evaluateValidity()
        }
    }
    var password: String = "" {
        didSet { evaluateValidity()
        }
    }
    var isValid : Bool = "" {
        didSet {
            isValidCallback?(isValid: isValid)
        }
    }
    var isValidCallback : ((isValid: Bool) -> Void)?

    func attemptToLogin() {
          //truncated for space
    }

    private func evaluateValidity(){
      isValid = username.characters.count > 0
            && password.characters.count > 0
    }
}
```

你通过这个回调闭包，这个你创建的小回调：

```swift
class LoginViewController {

    @IBOutlet var confirmButton: UIButton!
    var loginViewModel = LoginViewModel()

    override func viewDidLoad(){
        super.viewDidLoad()
        loginViewModel.isValidCallback = { [weak self] (isValid) in
            self?.confirmButton.isEnabled = isValid
        }
    }
}
```

`ViewModel` 可以监听它。这将调用这个回调并将其值返回给某个监听器，这个监听器将是视图控制器。`LoginViewModel` 将有一个 `isValid` 回调，你将设置这个值。这很好，可测试，因为你可以把它放到运行时，测试布尔值，而不是视图控制器的整个状态。

单向数据流的问题，即 UI 与 `ViewModel` 对话，`ViewModel` 与模型对话，是一个难题。你看到了这是多么容易，从 `UIKit` 到 `ViewModel` 到 `Model`，再回到 `ViewModel`。

这一部分，从 `ViewModel` 回到 `UIKit`，每个人都会有不同的做法。这就是 RxSwift 将为你解决的问题。

### RxSwift (11:38)

RxSwift 在这方面有什么帮助？RxSwift 是事件的 Lodash，或者说是事件的 Underscore，如果你是来自 JavaScript 世界的话。它允许你操作事件，事件化的数据，就像你能够操作数组或集合一样。随着时间的推移，事物的变化类似于数组中的事物变化。

我有一个 playground，RxSwift（见视频）。可以说，一个可观察对象是一个集合类型。它要发射事件，一些发射事件的源头，你可以创建几乎代表所有东西的可观察变量。一个简单的例子是：你正在创建一个类似于股票行情助手的东西，告诉你是否应该从一个网络套接字中买东西。我们要伪造它并创建一些东西。

你从一个数组中做可观察的浮动，这些是出现的股票价格。1、2、35、90 是浮点数。在这个操场上，它已经运行了。你可以订阅事件源，事件源会不断地发出来，然后你就会得到数值的回报。这其中最酷的部分是一个简单的例子。记住，这可以进来，假装这不是字面意思，例如，股票价格不是每分钟都在更新；它可以在不同的时间内更新。

我们想告诉 UI，把 UI 代码放在订阅事件中。我们想在价格高于 30 的时候买入。我们会在价格出现的时候打印出来。但我们想从中创建另一个字符串。

在这个新的可观察到的数据中的第二个字符串，我们要进行过滤。然后只有在这个过滤器有效的情况下，它才会运行这个订阅块。RxSwift 允许你过滤，对它们进行映射。比如说，我们可以做这样的事情，映射。我们可以做一个兑换率。例如，你想在一个不同的国家购买，你有一个汇率。然后你会打印出这些新的汇率。我们去掉了过滤器，所以它要为每一个不同的事件做。

有一个简单的子类，几乎就像一个子结构，是一个可观察的。一个可观察的东西是用来发射事件的，幸运的是有了泛型，我们总是有它们的类型。有一种东西叫做变量；你总是可以静态地创建它们；它们是你可以使用的非常原始的类型的代表。而用户名和密码是可观察的，因为你总是可以通过 username.value 获得它们的值，而不需要订阅它

这将从 UI 中被突变，但我们也想监听 isValid 状态。我们已经创建了两个流，`self.username` 和 `self.password`，我们想在其中任何一个变化时进行评估。这就是我们所说的 `combinedLatest：`它是一个操作符，类似于 GroupBy 这样的 Lodash 操作符。

如果其中有任何变化，我们将运行这个还原器块，它将返回给我们一个布尔值。如果用户名的字符数大于 0，密码数大于 0，现在这就摆脱了所有的 `didSets`，摆脱了任何私有方法，并创建了这个数据流。你从用户界面去，`isValid` 将返回到用户界面。

我通常在我的代码中写上 `fromUI` 或 `toUI`。或者你可以说 `fromViewModel` 或 `ToViewModel`。你仍然可以理解为你有两段代码，即一段是朝这个方向走，另一段是朝另一个方向走。

视图控制器将有你的常规 ViewModels，但你在 RxCocoa 库中有一些扩展方法。它们是在 UIKit 之上的扩展方法，允许你在不创建委托的情况下获得数值的变化。

我讨厌委托，我认为它们是整个世界上最糟糕的东西，因为它们让你滚动。特别是对于 `UITableView` 和 `UICollectionView`。还有一些简单的事情，比如有两个不同的文本视图，你必须检查每一个的引用 -- 这相当烦人。在这里，你可以直接获得引用，在 `ViewDidLoad` 上，`usernameTextField.rx.text`，然后你要 `bindTo` ViewModel。

你可能使用过一些 API，在这些 API 中，你会得到不确定的事件，但随后你必须停止令牌处理程序。一个 "dispose bag" 是这些的集合。每当 dispose bag 解除初始化时，它就会处理掉这些流中的任何一个。这对清理事情很有帮助。你也可以通过调用 `disposeBag.dispose` 来手动处理它们。这将进入 ViewModel，然后 ViewModel 现在有 `rx.isValid`。我们将映射出 `isEnabled` 的值。

我有一个小例子可以做到这一点。我为你截断了这个；你可能注意到 UITextField 的 rx.text 给你一个可选的字符串。我将给它一个默认值，即一个空字符串，以使事情更容易。

```swift
mport RxSwift

struct LoginViewModel {

    var username = Variable<String>("")
    var password = Variable<String>("")

    var isValid : Observable<Bool>{
        return Observable.combineLatest( self.username, self.password)
        { (username, password) in
            return username.characters.count > 0
                        && password.characters.count > 0
        }
    }
}
```

我们将得到一个简单的登录表单：

```swift
import RxSwift
import RxCocoa

class LoginViewController {
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var confirmButton: UIBUtton!

    var viewModel = LoginViewModel()

    var disposeBag = DisposeBag()

    override func viewDidLoad(){
        super.viewDidLoad()
        usernameTextField.rx.text.bindTo(viewModel.username).addTo(disposeBag)
        passwordTextField.rx.text.bindTo(viewModel.password).addTo(disposeBag)

        //from the viewModel
        viewModel.rx.isValid.map{ $0 }
            .bindTo(confirmButton.rx.isEnabled)
    }
}
```

你可以看到，有一个登录按钮，但它是禁用的。然后你要说出密码。突然间，登录就有效了。那是一吨的代码消失了。如果我把它删除，它就会恢复。

如果我们在 LoginViewModel 中设置一个断点，如果其中任何一个发生变化，这个就会运行；这就是 `combineLatest` 允许你做的事情。每次你拿回数值时，它都会得到状态。如果你看一下用户名，你会得到它的值，然后是密码，你会得到它的值。然后，它将返回一个布尔值。这允许你总是突变数值，以及结合它们来获得新的数值。

确保 UIBindings 不互相交谈。我知道许多人对 RxCocoa 感到兴奋，因为它摆脱了许多委托人的对话。但请确保你的 UI 流不会相互交谈。它很容易变得混乱。

例如，你可能决定，"我不打算做这个 ViewModel 的事情。" 你通过绑定你的用户名文本字段和密码文本字段来创建 `combineLatest`。然后你的结果选择器返回给你这个。然后你创建这个 `isValid.bindTo`。

```swift
override func viewDidLoad(){
    super.viewDidLoad()

    let isValid Observable.combineLatest(
            username.rx.text,
            password.rx.text,
            resultSelector: { (username, password) -> Bool in
                return username.characters.count > 0
                        && password.characters.count > 0
            })

    isValid.bindTo(confirmButton.rx.isEnabled)
        .addTo(disposeBag)
    }
}
```

这是完全无法测试的，因为 `isValid` 是一个停留在视图控制器中的环境事物；你没有得到它的引用，它就在那里。而且你也没有得到 MVVM 的任何好处；它仍然是一个大规模的视图控制器。

RxCocoa 并没有涵盖 UI 绑定的整个世界。它有很多有用的东西，比如 `UITextField`、`UIButtonTaps`、`MapKit` 和 `UITableView`（你可以从 `UITableView` 中创建整个职业生涯）。

```swift
class MyCustomView : UIView {

    var sink : AnyObserver<SomeComplexStructure> {
        return AnyObserver { [weak self] event in
            switch event {
                case .next(let data):
                    self?.something.text = data.property.text
                    break
                case .error(let error):
                    self?.backgroundColor = .red
                case .completed:
                    self.alpha = 0
            }
        }
    }

}    
```

`UITableView` 和 `UICollectionView` 很贵，因为有这么多你想做的方法，而摆脱一行是 Stack Overflow 的查询。很有可能你已经为自己创建了 UIViews 的子类。你可能有像 Mapbox 这样的视图，或者你正在使用你喜欢的 CocoaPods 上的东西。它不一定是你自己的子类，但你可以创建一个扩展方法。

我们的想法是，你将能够拥有这种 "Rx-able" 自定义视图。

```swift
class ViewController {

    let myCustomView : MyCustomView

    override func viewDidLoad(){
        super.viewDidLoad()

        viewModel.dataStream
            .bindTo(myCustomView.sink)
            .addTo(disposeBag)
    }
}
```

你创建一个观察者。观察者是一个接收事件的代码块。这个事件是一个枚举，它向你返回它的类型，然后是一个错误，然后是一个完成。你可能会把一大堆这样的 "水槽" 塞进去，然后通过说明它的属性文本来做一些事情，然后在出现错误的情况下，也许会把它变成红色。如果它完成了，也许让它消失。

如果你有一些自定义的股票标签或股票价格，你可以创建 Rxable 元素。这很好，因为它不知道任何数据，也不知道 async；它只是接受这种格式的数据。而且它也有很好的泛型。请确保它在该块中始终是弱的，因为你在引用它自己。

所以你有一些自定义视图。在你的 ViewModel 中，有一些数据流进来了。然后你要绑定到汇中。因此你有能力让一个 UIView 接受 Reactive 流。

而得到它的方法是，使用 CocoaPods 或 Carthage、RxSwift 和 RxCocoa。RxCocoa 是 UIKit 的扩展方法，而且也有用于 Mac 开发。这是大的，因为我告诉你 UITableView 和 UICollectionView 有多大。

这里有一个例子应用（见视频），向你展示了 RxDataSources 的威力，它是一个独立的开源库，建立在 RxSwift 之上。这里是一个使用 UITableView 的定制，有不同的部分。



我给你看看这段代码有多小。你甚至不打算实现 UITableView 数据源。你将会有章节。节段很有意思。这只是一个协议。一个接受协议的数据源。而且它将会有一个 ID。你可以告诉 Rx 数据源的 ID 是什么，什么是变异的，什么时候变异，它就会调用相应的 UITableView.animate row 或 delete row，而你不必总是手动变异数据源。你创建两个不同的部分，第一部分和第二部分。然后你有一个数据源。

数据源要用我这一节的通用型来打。这是你的自定义表视图实现。你要调用你的可重复使用的标识符，告诉它你想要什么表视图单元。对于数据源的 ViewModel，你可以有数据源，但要告诉它什么部分。对于我们做的静态部分，我们 bindTo (tableView.rx.items (...))，并且用它想要的数据源。现在你把委托人设置为自己，你就有了多个部分。

你没有用不同的值来创建成员变量，你没有管理索引、索引部分和路径。你把它交给了 RxSwift 和 RxDataSources。而且这可以是你想要的同步的。

随机的例子是相当强大的。在 UICollectionView 中有所有这些部分。而且有一个假的异步流在不断运行。它比你用手写的要小得多。它所做的就是创建不同的数字，以不同的方式删除值。而且你永远不必调用 insertRow、indexPath 和 jerry-rig 所有这些乱七八糟的东西。现在你有了一些相当令人印象深刻的东西。这对于一个股票行情的应用来说是非常好的。

*我没有谈很多关于操作符的内容；我不想让很多人不知所措。下一次谈话将是使用复杂的东西排序的操作符，groupBys，组合，合并，Zipping，它们都意味着什么，这将是一个更像算法和数据结构的 RxSwift 谈话。但这就是你如何让数据结构以一种非常好的符合要求的方式与你的用户界面对话。*



### 问与答 (27:55)

**问：对于一个商店或一个公司来说，这样做有困难吗？而在大公司或小公司更难吗？你是如何说服人们的？**

Max: 这是 RxSwift 的一个伟大的部分，它不是很有主见，不像突然引入 Lodash 那样。如果你愿意，你可以使用你自己的原生事件，你可以以一种孤立的方式使用它。例如，如果你有很多票据开始说，"创建新的视图控制器"，你可以使用它。而旧的代码甚至不需要知道。你要把这两件事串联起来维护，但这是一个实用的库，它不像一个框架。



**问：当你加入断点时 -- 我想问 RxSwift 在性能上有什么缺陷？当应用程序变得越来越大，并且你有网络代码时，速度是非常重要的。**

Max：是的，这是个大话题，一般来说。就在主线程上做事情而言，没有任何问题。我没有看到这个问题，RxSwift 的 repo 页面上有基准，你可以去看看。

iOS 开发的真正诀窍在于你是否能够处理异步和并发，而这正是 RxSwift 的闪光之处。这可能是另一个讲座的内容，但我可以快速地介绍一下其实际的好处。

例如（见视频），你可以创建一个像并发的调度器。我们想要哪一个呢？你可以创建一个后台调度器。股票价格。然后在调度器上观察。然后再做下一步。也许是地图。这将是在那个背景 QoS 上。这将是在后台 QoS 上。假设你想把它返回到主线程。这将在后台运行，这就是你可能会看到你的性能优势的地方。

还有其他一些事情，例如，你可能想做一些节流的事情。如果你正在做类似于搜索的事情，你说你是来自 Yelp？许多人不想点击应用程序中的搜索按钮；他们想打字，然后你想把这些东西发送到后台。你可能不会发送每一个流进来的字符。

比方说，这是一个流入的文本流。你可以做一个节流。然后再做 0.25 秒。主调度器。实例。订阅。然后在这里运行你的异步代码。或者如果我们要用 MVVM 的方式来做，你要用 bindTo。如果有人是一个快速打字员，你不想搜索，例如你想搜索披萨或什么，你不想搜索 P，那是不相关的。你可能想节流，但不仅是节流，而且如果他只输入了三个比特的数据，就实际运行这个块。这有助于你在维护你的主线程方面尽可能快。

但你不应该在 iPhone 7s 的主线程上做，那么你就有严重的问题。这是一个快速的机器。在其他线程上做所有事情，在正确的线程上交付它们。你可以顺便测试一下，你可以在测试中的 repo 上查看，人们如何在一个线程上扔东西，然后在另一个线程上做，然后把它交还给主线程。但在你的 ViewModel 中，你通常希望几乎总是把它交还给主线程。



