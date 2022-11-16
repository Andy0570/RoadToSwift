> 原文：[MVVM with Coordinators and RxSwift](https://academy.realm.io/posts/mobilization-lukasz-mroz-mvvm-coordinators-rxswift/)

每个应用程序都需要良好的架构。在他来自 Mobilization 2016 的演讲中， Łukasz 将向你展示他在 iOS 项目中使用的架构。MVVM 与协调器和 RxSwift。他不仅会谈论基础知识，还会包括一个现场代码演示，描述什么属于哪里，使用协调器控制流程，使用 Quick/Nimble 测试一切，以及使用 Moya 进行网络请求。

------

### 介绍 (0:00)

我叫Łukasz，是 Droids on Roids 的一名 iOS 开发者。我喜欢思考，所以今天我们要讨论的是需要大量思考的架构。MVVM + coordinators + RxSwift。

这是基于一种 MVVM 模式，虽然是 Swift 中的新模式，但现在非常流行。它是由 Soroush Khanlou 一年前在 NSSpain 介绍给我的。我强烈推荐你看那个演讲。

### MVC (1:03)

MVC 是一种基本模式；我们有一个视图、一个模型和一个将视图连接到控制器的控制器。这个连接从模型中获取数据并将其传递给视图，而视图只是显示数据。视图还传递关于用户操作的通知。

我们也有网络层。它应该在哪里？也许它应该放在控制器里。还有 Core Data，也可以放在控制器里。我们也可能有委托和更多的导航，我们可能最终会有一个新的架构，这只是一个普通的控制器。

### MVVM (2:15)

MVVM 与 MVC 非常相似，但没有视图控制器。相反，有另一个新的类。ViewModel。在 iOS 中，我们必须使用控制器，所以你可以把视图看成是视图控制器加上视图，就像一个实体被分成两个文件一样。

上面，我们可以看到视图像 MVC 中一样显示数据。还有一个模型，以及一个处理数据并将其传递给视图的视图模型。你可能注意到这里没有网络和其他代码的位置。

### Coordinators（协调器） (3:11)

协调器是由 Soroush Khanlou 介绍给我的另一个很酷的模式。协调器基本上是一个控制你的应用程序流程的对象。它控制每一个推送视图控制器，每一个弹出控制器，等等。这是协调器除了注入之外应该有的两个职责之一。

在一个应用程序中，控制器是什么样子的？我们应该至少有一个应用程序协调器，它从一个应用程序委托中开始，协调第一个屏幕的流程。举个例子，假设我们的第一个屏幕是按钮。例如，如果用户点击了 "注册" 按钮，我们就会有另一个控制器。我倾向于以这样的方式来考虑协调者，即我们的每一个故事，都应该有另一个协调者。

在这个 "注册" 的例子中，所涉及的故事是，这个按钮可能需要一些自己的空间，因为可能有一个使用 Facebook 或 Gmail 的注册，等等。在我看来，它应该是另一个 coordinate。

继续我们的例子，还可以有一个 "登录" 按钮和一个 "忘记密码" 按钮，所以我们将有三个 coordinators，如上图所示，只是在我们的应用程序的开头。这个逻辑可能会变得非常难以解释，因为有很多视图模型，很多协调人，他们之间的连接方式会变得很复杂。



### RxSwift (5:06)

虽然你可以使用任何函数式库，但我个人更喜欢 RxSwift，因为我对它有最多的经验。然而，现在有很多反应式库，如 RxCocoa、RxSwift、Bond、Interstellar 等等。在这里，我们将使用 RxSwift 进行绑定。

如果你完全不遵循函数式、反应式或观察者模式，你可以这样来思考 Rx：想象你有一些东西，你传递给模型或视图控制器。现在想象一下，你有一个你发送给对象的那些东西的序列。然而，一个序列可以有一个项目，许多项目，或者根本没有项目。我将使用 BinHex 来观察视图模型包含的值并将其绑定到视图上。我们并没有真正使用 "k key" 值来观察委托，还有很多我们在应用中不需要的代码。



### Demo (7:03)

在本讲座的演示部分，我们将看到一个名为 Kittygram 的应用程序。请查看 [GitHub 的仓库](https://github.com/sunshinejr/Kittygram/)。

```swift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    	window = UIWindow()

    	var rootViewController: UIViewController!
    	if arc4random_uniform(5) % 4 == 0 { // super secret algorithm, dont change
        	rootViewController = PayMoneyPleaseViewController()
    	} else {
        	rootViewController = DashboardViewController()
    	}
    	window?.rootViewController = UINavigationController(rootViewController: rootViewController)
    	window?.makeKeyAndVisible()

    	return true
	}
}
```

在这里，我们有急速投资回报率的储存库。基本上，当一个项目被点击时，会有一个切入另一个屏幕。我不打算在这里讨论太多细节。你在上面看到的是 MVC 与一个小的应用委托。在这种情况下，我们有一个 "超级秘密算法"，在开始时推送控制器。还有某种商业计划。在声明通过的情况下，就会有钱；否则就会运行可能有一些资源库的仪表板视图控制器。

### Dashboard View Controller(8:50)

现在看一下 DashboardViewController，它是应用程序中最大的控制器。它包括资源库、注册，或数据源和委托的名称。我们也有 downloadRepositories 和注册名称。还有一个函数用于显示警报和其他 UI 的东西。

```swift
class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!

	var repos = [Repository]()
	var provider = MoyaProvider<GitHub>()

	override func viewDidLoad() {
    	super.viewDidLoad()

    	let nib = UINib(nibName: "KittyTableViewCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "kittyCell")
    	tableView.dataSource = self
    	tableView.delegate = self

    	downloadRepositories("ashfurrow")
	}

	fileprivate func showAlert(_ title: String, message: String) {
    	let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    	let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    	alertController.addAction(ok)
    	present(alertController, animated: true, completion: nil)
	}

	// MARK: - API Stuff
	
	func downloadRepositories(_ username: String) {
        provider.request(.userRepositories(username)) { result in
            switch result {
            case let .success(response):
                do {
                    let repos = try response.mapArray() as [Repository]
                    self.repos = repos
                } catch {

                }
                self.tableView.reloadData()
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                self.showAlert("GitHub Fetch", message: error.description)
        }
    }
}
```

它从 GitHub 获取存储库，如果它出错，你可以直接推送一个警报。它还包括标准的 `tableView.dataSource`。



### Pay Money Please Controller(9:27)

这是另一个用于 "请付账" 的控制器。

```swift
import UIKit

class PayMoneyPleaseViewController: UIViewController {

	@IBOutlet private weak var descriptionLabel: UILabel!

	override func viewDidLoad() {
	    super.viewDidLoad()

	    title = "Hey mate"
	    descriptionLabel.text = "💰💸🤑Please pay me money if you want to use this app, thanks! 💰💸🤑"
	}
}
```

这是很标准的；只是一个描述和一个标签。

### Kitty Controller (9:41)

```swift
import UIKit

class KittyDetailsViewController: UIViewController {

	@IBOutlet private weak var descriptionLabel: UILabel!

	var kitty: Repository!

	convenience init(kitty: Repository) {
    	self.init()

    	self.kitty = kitty
	}

	override func viewDidLoad() {
    	super.viewDidLoad()

    	descriptionLabel.text = "🐱" + kitty.name + "🐱"
	}
}
```

这就是 KittyDetailsViewController。我们传递了存储库，这是一个模型，从 GitHub 下载，然后显示 kitty.name 以及两张图片。



### Models

#### User Model

```swift
import Mapper

struct User: Mappable {

	let login: String

	init(map: Mapper) throws {
   		try login = map.from("login")
	}
}
```

我们有一些用于 GitHub API 的模型。这是用户模型，它真的很简单。

#### Repository Model

```swift
import Mapper

struct Repository: Mappable {

	let identifier: Int?
	let language: String?
	let name: String
	let url: String?

	init(map: Mapper) throws {
    	identifier = map.optionalFrom("id")
    	name = map.optionalFrom("name") ?? "no name 😿"
    	language = map.optionalFrom("language")
    	url = map.optionalFrom("url")
	}
}
```

这就是 Repository 模型。我使用了 [mapper @Lyft](https://github.com/lyft/mapper)，我认为它非常酷。该模型映射了标识符，但所有的东西都是可选的。在没有名字的情况下，我需要在细节中显示一些东西。

#### Endpoint

看看这里的端点代码。

这个端点是基于 Moya 的。我非常喜欢 Moya，因为它使你足够灵活，不需要在网络请求上使用外部抽象。我可以在 Moya 中使用插件、闭包等做无限多的事情。

如果我们想停止我们的请求，我们必须传递样本数据，无论是相邻的样本数据还是只是为了使用网络而不联网的数据。

对于更大的应用程序，可能有不止一个提供者，在这种情况下，他们也应该作为依赖性注入提供。

#### Coordinator

```swift
import Foundation
import UIKit

class Coordinator {

	var childCoordinators: [Coordinator] = []
	weak var navigationController: UINavigationController?

	init(navigationController: UINavigationController?) {
    	self.navigationController = navigationController
	}
}
```

这是协调器类，这是最重要的。它包含 `childCoordinators`，所以我们可以生成另一个和更多子协调器实例。这里有趣的事情是导航控制器。你可能已经看到，这个系统很 weak。在我们的案例中，一个导航控制器必须是弱引用的。如果你考虑到只有一个导航控制器的应用程序，并且把子代和父代放在同一个控制器上，你会创造一个循环，每个控制器都被调用。这真的很重要，因为如果你不使用一个导航控制器，我们就有一个弱引用的导航控制器。

**谁负责导航控制器的引用计数器？**

我们将以 MVVM 风格启动我们的 MVC。我们在委托中启动了一个流程，它不应该出现在这里，所以我们将使用协调器来处理它。

我们将创建一个新的应用程序协调器，作为我们在应用程序开始时使用的基本协调器。

```swift
import UIKit

final class AppCoordinator: Coordinator {

	func start() {
		var viewController: UIViewController!
    	if arc4random_uniform(5) % 4 == 0 { // super secret algorithm, dont change
        	viewController = PayMoneyPleaseViewController()
    	} else {
        	viewController = DashboardViewController()
    	}

		navigationController?.pushViewController(viewController, animated: true)
	}
}
```

所以这就是我们应用协调器中的流程逻辑；它并不真正属于 `AppDelegate`，所以我们可以尝试修复被我们破坏的 App delegate。我们不能用根控制器传递 UI 导航，因为我们没有真正的根控制器，所以我们将创建另一个没有任何根控制器的导航控制器。我们将在这里添加一个纯导航控制器，只是为了满足 Xcode。我们可以使用我们刚刚创建的导航控件。

我们的应用程序委托现在应该是这样的：

```swift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions 	launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    	window = UIWindow()

    	let navigationController = UINavigationController()
    	window?.rootViewController = navigationController
		let coordinator = AppCoordinator(navigationController: navigationController)
		coordinator.start()
    	window?.makeKeyAndVisible()

    	return true
	}
}
```

有了这个，我们有两个故事：用户不付钱，另一个是控制仪表盘的。当用户不交钱时，我们只显示控制器，什么都不做。控制仪表盘的故事被分割成两个新的协调器。我们将创建一个仪表盘协调器。

所以我们的应用程序又有了两个故事。让我们从最简单的一个开始，也就是 "请交钱"。

```swift
final class PayMoneyPleaseCoordinator: Coordinator {

	func start() {
		let viewController = PayMoneyPleaseViewController()
		let viewController = DashboardViewController(viewModel: viewModel)
		navigationController?.pushViewController(viewController, animated = true)
	}
}
```

这将创建一个新的控制器并推送到导航栈。完成这些后，我们进入仪表板：

```swift
final class DashboardCoordinator: Coordinator {

	func start() {
		let viewController = DashboardViewController()
		navigationController?.pushViewController(viewController, animated = true)
	}
}
```

这也会推送到导航栈。完成这两项工作后，我们就有了两个故事。现在我们把这些故事放在应用程序协调器中，所以它应该负责知道执行哪个故事。

下面是应用程序协调器的样子：

```swift
import UIKit

final class AppCoordinator: Coordinator {

	func start() {
		if arc4random_uniform(5) % 4 == 0 { // super secret algorithm, don't change
			let coordinator = PayMOneyPleaseCoordinator(navigationController: navigationController)
			coordinator.start()
			childCoordinators.append(coordinator)
		} else {
			let coordinator = DashboardCoordinator(navigationController: navigationController)
			coordinator.start()
			childCoordinators.append(coordinator)
		}
	}
}
```

这种情况下，应用程序中只有一个协调人，所以会有一个循环。最重要的部分是添加子协调器以保持对协调器的引用，这样它就可以工作了。

#### Dashboard Controller 重构

现在我们将转向我们要重构的仪表盘控制器，并为这个类创建一个仪表盘视图模型。我们将创建一个新的组和新的模型。

最有可能的准则是为每个协调器创建一个视图模型，但在某些情况下，你可能需要更多。如果你的视图控制器中有更多的视图，你想用不同的逻辑进行绑定，你可能需要更多。

我注意到关于视图模型的一件事是，你几乎总是想创建一个协议。每当你把一个视图模型绑定到一个视图控制器时，你可能想改变逻辑，但如果你不使用将由视图模型实现的协议，你可能最终会创建大量的 inits。这使你的架构变得复杂。作为一个经验法则，为你创建的每个视图模型使用一个协议。

现在要创建一个协议仪表板视图模型类型。现在它将是空的，但随着我们的重构，它将被填满。

在视图控制器中，我们有一些我们不需要的网络，所以我们把 API 的东西从视图控制器中移出，在仪表盘视图模型中创建一个 `init`，然后移动请求。为了测试的目的，我们将注释掉视图控制器中的 UI 逻辑。我们还将把下载库移到视图模型中，因为它在开始时很慢。

网络请求从互联网上获取你的资源库，并将其传递给表视图。我们将用一个对象的序列来做这件事。如果你想尝试 RxSwift，最简单的方法是创建一个变量，它是一个至少有一个对象的序列。现在它将是一个资源库变量，从一个空的开始。这是在命令式编程和声明式编程之间的一个简单桥梁。

这可能不是最好的 Rx 代码，因为最好的 Rx 代码不会被很多人理解。

我们使用 `value` 属性在序列中创建一个新的项目。另一个经验法则是不要真正暴露变量：所以我们将使其私有化，使用 Xcode 黑客来使用懒惰的变量类型。这些将是 `reposeObservable`。你永远不希望暴露变量，万一有人从视图控制器做出另一个序列，你将没有准备。我们将把这个 `reposVariable` 添加到我们的协议中。

这里是 Dashboard 视图模型：

```swift
import RxSwift

protocol DashboardViewModelType {
	var reposeObservable: Observable<[Repository]> {get}
}

final class DashboardViewModel {

	private let reposVariable = Variable<[Repository]>([])

	lazy var reposObservable: Observable<[Repository]> = self.reposVariable.asObservable()

	intit() {
		downloadRepositories("ashfurrow")
	}

	func downloadRepositories(_ username: String) {
		provider.request(.userRepositories(username)) { result in
		switch result {
		case let .success(response):
			do {
				let repos = try response.mapArray() as [Repository]
				self.reposVariable.value = repos
			} catch {

			}
		case let .faliure(error):
			gaurd let error = error as? CustomStringConvertible else {
				break
			}
//				self.showAlert("GitHub Fetch", message: error.description)
		}
	}
}
```

我已经注释并删除了一些行。在 RxSwift 中，有一个绑定视图控制器的函数，我们可以只使用关闭，它填补了所有的数据服务委托。

我们没有我们的视图模型，所以我们将在独立注入中把它传递给我们的协调器。在 Dashboard 协调器中，我们必须要传递视图模型。

在仪表板视图控制器中：

```swift
private var viewModel: DashboardViewModelType!
convenience init(viewModel: DashboardViewModelType) {
	self.init()

	self.viewModel = viewModel
}
```

就在这里使用类型，因为它在测试控制器时非常有帮助，当渲染正确时。私有的 var 不需要是可选的：我只是强制解除它，因为每当我们在没有视图模型的情况下创建这个控制器时，我希望它崩溃以显示有问题，而且代码不会运到公众面前。

现在我们可以使用 RxSwift 的魔法了。我们需要导入 RxSwift 和 RxCocoa。那么我们该怎么绑定呢？

在 `bind` 函数中，第一个参数是 `tableView`，第二个是 `index`，第三个是 `item`。现在，我们必须创建一个单元格，以便在闭包中返回；我们可以删除委托，因为我们现在不需要它们。我们在这里也没有得到存储库，因为我们从可观察存储库的一个项目中得到了它。

然而，首先，我们需要做一个索引路径，因为这个方法实际上是为了简单的使用。行将是索引，段将暂时为零，我们没有一个我们的仓库，我们有一个项目。我们还需要一个处置包，为了节省时间，你只能相信我，这里需要它。虽然我们没有时间来做这个，但我的建议是不返回项目的可观察性，而是返回视图模型的可观察性，因为视图控制器不应该真正访问模型，这是创建视图模型的另一个步骤，但这仅仅是为了创建视图模型的类型。

下面是重构后的 Dashboard 视图控制器：

```swift
import Foundation
import Moya
import Moya_modelMapper
import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	var repos = [Repository]()
	private var viewModel: DashboardViewModelType!
	private let disposeBag = DisposeBag()

	convenience init(viewModel: DashboardViewModelType) {
		self.init()

		self.viewModel = viewModel
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let nib = UINib(nibName: "KittyTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "kittyCell")
//		tableView.dataSource = self
//		tableView.delegate = self

		viewModel.reposObservable.bindTo(tableView.rx.items) { tableView, index, item in
		let indexPath = IndexPath(row: index section: 0)
		let cell = tableView.dequeueReusableCell(withIdentifier: "kittyCell", for: indexPath) as UITableViewCell
		cell.textLabel?.text = item.name

		return cell
	}
	.addDisposableTo(disposeBag)
}
```

你必须记住不要传递模型。如果你想让导航从持有小猫的控制器到细节，我建议建立另一个变量，现在它是一个视图模型。把它从视图控制器点击的时刻绑定到视图模型上，然后视图模型必须对它做一些事情。

在 Dashboard 视图控制器中，协调器必须将下一个控制器推上去，所以我们创建一个新的协议，这是控制器的委托，必须继承一个类。(也许这在 Swift 3 中会被修复？) 然而，我们唯一的动作是点击有猫的单元格，所以我们会做一个函数，说 "已经点击了有索引路径的单元格，现在在我们的视图模型中创建一个自定义 init"。没有参数，做一个视图委托，这是一个视图控制器的委托，从视图模型的信号中调用这个委托。当然，你把它传给协调器，现在协调器知道如何对它做出反应。

我们还需要考虑如何删除协调器。应该有一个方法来检查协调者是否完成了它的动作，而应用程序协调者只是从堆栈中删除。

### 问答 (37:43)

**问：在你的演示中，你使用了 xibs。你有没有尝试过让它与故事板和 segues 一起工作？**

Łukasz：是的，它确实可以与故事板一起工作。我发现 GitHub 存储库可以与控制器一起使用。我现在没有链接，但如果你搜索 "带故事板的协调器"，你可以找到它。

**问：你对 Rx 中的 Subject 有什么看法？**

Łukasz: 你不应该真的需要在你的项目中使用主题。如果你正处于使用 Rx 的早期阶段，那也没关系。一般来说，不要使用它，但如果你必须使用它，请按照我的方法来做：创建一个私有的，只暴露给可观察的，这样视图控制器就不能访问来自视图模型的数据。它应该只在那里做绑定。





