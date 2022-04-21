> 原文：[Design Patterns by Tutorials: MVVM](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm)
>
> 在我们的新书《设计模式教程》的这一免费章节中，了解如何以及何时使用 MVVM 的架构设计模式。

## MVVM 设计模式

Model-View-ViewModel（简称 MVVM）是一种架构设计模式（structural design pattern），将对象分为三个不同的部分：

1. Models：持有应用数据。通常为 struct 或 class。
2. Views：在屏幕上显示视觉元素和控件。通常为`UIView`的子类。
3. View models：将模型信息转换为可在视图中直接显示的值。通常为 class 类，因此可以作为引用传递。

<img src="https://raw.githubusercontent.com/wiki/pro648/tips/images/MVVMUML.png" alt="MVVMUML" style="zoom: 50%;" />

MVVM 和 Model-View-Controller（简称 MVC）很像。上面 MVVM 类图中包含视图控制器。也就是说，MVVM 模式包含 view controller，只是其作用被弱化了。

## 何时使用 MVVM 模式

当模型需要转换后才可以在视图显示时，使用 MVVM。例如，使用视图模型（view model）将 `Date` 转换为日期格式的 `String`，将十进制转换为货币格式的 `String` 等。

MVVM 模式与 MVC 模式并无冲突。如果没有 view model 部分，你可以将 model-to-view 转换代码放到控制器中。但视图控制器已经实现了像视图生命周期管理、通过 `IBAction` 处理视图回调等各种任务，低耦合变得难以实现。MVC 也就成为了 Massive View Controller。

<img src="https://koenig-media.raywenderlich.com/uploads/2018/04/MVC_Suitcase.png" style="zoom:50%;" />

如何避免你的视图控制器过于臃肿？这很简单——使用 MVC 以外的其他设计模式。 MVVM 是瘦身的好方法，它可以让需要执行多次模型到视图转换的庞大的视图控制器变得更加精简。



## Playground 示例

在 **starter** 目录中打开 **IntermediateDesignPatterns.xcworkspace**，然后打开 MVVM 页面。

举个例子，你将制作一个 "Pet View"，作为收养宠物的应用程序的一部分。在 **Code Example** 后添加以下内容：

```swift
import PlaygroundSupport
import UIKit

// MARK: - Model
public class Pet {
    public enum Rarity {
        case common
        case uncommon
        case rare
        case veryRare
    }

    public let name: String
    public let birthday: Date
    public let rarity: Rarity
    public let image: UIImage

    public init(name: String, birthday: Date, rarity: Rarity, image: UIImage) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
}
```

在这里，你定义了一个名为 `Pet` 的模型。每个宠物都有一个名字、生日、稀有度和图像。你需要在视图中显示这些属性，但生日和稀有度不能直接显示。它们需要先由一个视图模型进行转换。

接下来，在你的 playground 末尾添加以下代码：

```swift
// MARK: - View Model
public class PetViewModel {

    private let pet: Pet
    private let calendar: Calendar

    init(pet: Pet) {
        self.pet = pet
        self.calendar = Calendar(identifier: .gregorian)
    }

    public var name: String {
        return pet.name
    }

    public var image: UIImage {
        return pet.image
    }

    public var ageText: String {
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents([.year], from: birthday, to: today)
        let age = components.year!
        return "\(age) years old"
    }

    public var adoptionFeeText: String {
        switch pet.rarity {
        case .common:
            return "$50.00"
        case .uncommon:
            return "$75.00"
        case .rare:
            return "$150.00"
        case .veryRare:
            return "$500.00"
        }
    }
}
```

以下是你在上面做的事情：
1. 首先，你创建了两个名为 `pet` 和 `calendar` 的私有属性，在 `init(pet:)` 中设置了这两个属性。
2. 接下来，你声明了 `name` 和 `image` 的两个计算属性，分别返回宠物的名字和图像。这是你可以进行的最简单的转换：返回一个没有修改的值。如果你想改变设计，给每个宠物的名字添加一个前缀，你可以通过在这里修改 `name` 来轻松实现。
3. 接下来，你将 `ageText` 声明为另一个计算属性，在这里你用 `calendar` 来计算从今天开始到宠物的生日之间的年数差，并将其作为一个字符串，后面加上 "years old"。你将能够直接在视图上显示这个值，而不需要执行任何其他的字符串格式化。
4. 最后，你创建了 `adoptionFeeText` 作为最后的计算属性，在这里你根据宠物的稀有性来确定它的收养费用。同样，你将其作为一个字符串返回，所以你可以直接显示它。

现在你需要一个 `UIView` 来显示宠物的信息。将下面的代码添加到 playground 的末尾：

```swift
// MARK: - View
public class PetView: UIView {
    public let imageView: UIImageView
    public let nameLabel: UILabel
    public let ageLabel: UILabel
    public let adoptionFeeLabel: UILabel

    public override init(frame: CGRect) {
        var childFrame = CGRect(x: 0, y: 16, width: frame.width, height: frame.height / 2)
        imageView = UIImageView(frame: childFrame)
        imageView.contentMode = .scaleAspectFit

        childFrame.origin.y += childFrame.height + 16
        childFrame.size.height = 30
        nameLabel = UILabel(frame: childFrame)
        nameLabel.textAlignment = .center

        childFrame.origin.y += childFrame.height
        ageLabel = UILabel(frame: childFrame)
        ageLabel.textAlignment = .center

        childFrame.origin.y += childFrame.height
        adoptionFeeLabel = UILabel(frame: childFrame)
        adoptionFeeLabel.textAlignment = .center

        super.init(frame: frame)

        backgroundColor = .white
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(adoptionFeeLabel)
    }

    // unavailable 表示当前项在指定的平台上不可用，编译器报错
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
```

在这里，你创建了一个带有四个子视图的 `PetView`：一个 `imageView` 用来显示宠物的图像，另外三个标签用来显示宠物的名字、年龄和收养费。你在 `init(frame:)` 中创建并定位每个视图。最后，你在 `init?(coder:)` 中抛出一个 `fatalError`，表示它不被支持。

你已经准备好将这些类付诸行动了 在 playground 的末尾添加以下代码：

```swift
// MARK: - Example
let birthday = Date(timeIntervalSinceNow: -2*86400*366)
let image = UIImage(named: "stuart")!
let stuart = Pet(name: "stuart", birthday: birthday, rarity: .veryRare, image: image)

let viewModel = PetViewModel(pet: stuart)

let frame = CGRect(x: 0, y: 0, width: 300, height: 420)
let view = PetView(frame: frame)

view.nameLabel.text = viewModel.name
view.imageView.image = viewModel.image
view.ageLabel.text = viewModel.ageText
view.adoptionFeeLabel.text = viewModel.adoptionFeeText

PlaygroundPage.current.liveView = view
```

以下是你所做的：
1. 首先，你创建了一个名为 `stuart` 的新宠物。
2. 接下来，你用 `stuart` 创建了一个 `viewModel`。
3. 接下来，你通过传递一个 iOS 上常见的 `frame` 来创建一个 `view`。
4. 接下来，你用 `viewModel` 配置了 `view` 的子视图。
5. 最后，你将视图设置为 `PlaygroundPage.current.liveView`，这告诉 playground 在标准的辅助编辑器中渲染它。

要看到这个动作，选择View ▸ Assistant Editor ▸ Show Assistant Editor来查看渲染后的视图。

![](https://koenig-media.raywenderlich.com/uploads/2018/04/PetView_Stuart-229x320.png)

Stuart 究竟是什么类型的宠物？当然，他是一只饼干怪兽。它们非常罕见。

你可以对这个例子做最后一个改进。在 `PetViewModel` 的类关闭的大括号后添加以下扩展：

```swift
extension PetViewModel {
    public func configure(_ view: PetView) {
        view.nameLabel.text = name
        view.imageView.image = image
        view.ageLabel.text = ageText
        view.adoptionFeeLabel.text = adoptionFeeText
    }
}
```

你将使用这个方法来使用视图模型配置视图，而不是在内联中进行配置。

到你之前输入的以下代码：

```swift
view.nameLabel.text = viewModel.name
view.imageView.image = viewModel.image
view.ageLabel.text = viewModel.ageText
view.adoptionFeeLabel.text = viewModel.adoptionFeeText
```

并将该代码替换为以下内容：

```swift
viewModel.configure(view)
```

这是一种将所有的视图配置逻辑放入视图模型的巧妙方法。在实践中，你可能想也可能不想这样做。如果你只在一个视图中使用视图模型，那么把配置方法放在视图模型中可能是好的。然而，如果你将视图模型与多个视图一起使用，那么你可能会发现将所有的逻辑放在视图模型中会使它变得混乱。在这种情况下，为每个视图单独编写配置代码可能更简单。

你的输出应该和以前一样。

嘿，Stuart，你要分享那个cookie吗？不分享吗？哦，来吧...!

## 你应该注意什么？

如果你的应用程序需要许多模型到视图的转换，那么 MVVM 效果很好。然而，并不是每个对象都能整齐地归入模型、视图或视图模型的范畴。相反，你应该将 MVVM 与其他设计模式结合起来使用。

此外，当你第一次创建你的应用程序时，MVVM 可能不是非常有用。MVC 可能是一个更好的起点。当你的应用程序的需求发生变化时，你很可能需要根据你不断变化的需求来选择不同的设计模式。当你真正需要它时，在应用程序的生命周期的后期引入 MVVM 也是可以的。

不要害怕变化--相反，要提前计划好它。

## 教程项目

在本节中，你将向一个名为 **Coffee Quest** 的应用程序添加功能。

在 **starter** 目录中，在 Xcode 中打开 **CoffeeQuest/CoffeeQuest.xcworkspace**（不是.xcodeproj）。

这个应用程序显示由 Yelp 提供的附近的咖啡店。它使用 CocoaPods 来引入 YelpAPI，这是一个用于搜索 Yelp 的辅助库。如果你以前没有使用过 CocoaPods，那也没关系！你所需要的一切都已经包含在其中了。你唯一需要记住的是打开 **CoffeeQuest.xcworkspace**，而不是**CoffeeQuest.xcodeproj** 文件。

> 注意：如果你想了解更多关于CocoaPods的信息，请在这里阅读我们关于它的免费教程：<http://bit.ly/cocoapods-tutorial>

在你运行该应用程序之前，你首先需要注册一个 Yelp API 密钥。

在你的网络浏览器中导航到这个 URL：

* <https://www.yelp.com/developers/v3/manage_app>

如果你没有账户，请创建一个账户，或者登录。接下来，在创建应用程序表格中输入以下内容（如果你以前创建过一个应用程序，则使用你现有的API密钥）。

* 应用程序名称。"Coffee Quest"
* 应用程序网站。(留空)
* 行业。选择 "商业"
* 公司。(留此空白)
* 联系电子邮件。(您的电子邮件地址)
* 描述。"Coffee search app"
* 我已阅读并接受Yelp API条款：请勾选此项

你的表格应该如下所示：
![](https://koenig-media.raywenderlich.com/uploads/2018/04/Yelp_Create_New_App-354x320.png)



点击 **Create New App** 继续，你应该看到一个成功的消息：

![](https://koenig-media.raywenderlich.com/uploads/2018/04/Yelp_Create_App_Success-480x52.png)

复制你的API密钥并返回到 Xcode 中的 CoffeeQuest.xcworkspace。

从文件层次结构中打开 **APIKeys.Swift**，并将你的API密钥粘贴在指定位置。

编译并运行以查看应用程序的运行情况。

![](https://koenig-media.raywenderlich.com/uploads/2018/04/Default_Map_Pins-180x320.png)



模拟器的默认位置被设置为旧金山。哇，那座城市有很多咖啡馆啊!

> 注意：你可以通过点击 Feature ▸ Location，然后选择一个不同的选项来改变模拟器的位置。

这些地图针有点无聊。如果它们能显示哪些咖啡店确实不错，那不是很好吗？

从文件层次结构中打开 **MapPin.Swift**。MapPin 需要一个坐标、标题和评分，然后将这些转换为地图视图可以显示的东西......这听起来很熟悉吗？是的，它实际上是一个视图模型

首先，你需要给这个类起一个更好的名字。在文件顶部的 MapPin 上点击右键，选择Refactor ▸ Rename...。

![](https://koenig-media.raywenderlich.com/uploads/2018/04/Rename_MapPin-480x153.png)



在新名称中输入 **BusinessMapViewModel**，然后点击重命名。这将重命名文件层次结构中的类名和文件名。

接下来，选择文件层次结构中的 **Models** 分组，按 Enter 键编辑其名称。把它重命名为**ViewModels**。

最后，点击黄色的 CoffeeQuest 组，选择按名称排序。最终，你的文件层次结构应该看起来像这样：

![](https://koenig-media.raywenderlich.com/uploads/2018/04/New_File_Hierarchy-480x286.png)

**BusinessMapViewModel** 需要更多的属性，以便显示令人兴奋的地图注释，而不是 MapKit 提供的普通图钉。

还是在 **BusinessMapViewModel** 内部，在现有的属性之后添加以下属性；暂时忽略由此产生的编译器错误：

```swift
public let image: UIImage
public let ratingDescription: String
```

你将使用 `image` 代替默认的针状图像，并且每当用户点击注释时，你将显示评级描述作为副标题。

接下来，把 `init(coordinate:name:rating:)` 替换成以下内容：

```swift
public init(coordinate: CLLocationCoordinate2D,
            name: String,
            rating: Double,
            image: UIImage) {
  self.coordinate = coordinate
  self.name = name
  self.rating = rating
  self.image = image
  self.ratingDescription = "\(rating) stars"
}
```

你通过这个初始化器接受 `image`，并从评级中设置 `ratingDescription`。

在 `MKAnnotation` 扩展的末尾添加以下计算属性：

```swift
public var subtitle: String? {
  return ratingDescription
}
```

这告诉地图在选择注解呼出的时候使用 `ratingDescription` 作为副标题。

现在你可以修复编译器的错误了。从文件层次结构中打开 `ViewController.swift`，向下滚动到文件的末尾：

将 `addAnnotations()` 改为以下内容：

```swift
private func addAnnotations() {
  for business in businesses {
    guard let yelpCoordinate = business.location.coordinate else {
      continue
    }

    let coordinate = CLLocationCoordinate2D(latitude: yelpCoordinate.latitude,
                                            longitude: yelpCoordinate.longitude)
    let name = business.name
    let rating = business.rating

    let image: UIImage
    switch rating {
    case 0.0..<3.5:
      image = UIImage(named: "bad")!
    case 3.5..<4.0:
      image = UIImage(named: "meh")!
    case 4.0..<4.75:
      image = UIImage(named: "good")!
    case 4.75..<5.0:
      image = UIImage(named: "great")!
    default:
      image = UIImage(named: "bad")!
    }

    let annotation = BusinessMapViewModel(coordinate: coordinate,
                                          name: name,
                                          rating: rating,
                                          image: image)
    mapView.addAnnotation(annotation)
  }
}
```

这个方法与之前类似，只是现在你要切换到通过 `rating` 来决定使用哪个图片。高质量的咖啡因对开发者来说就像猫薄荷，所以你把任何低于3.5星的东西都标记为 "坏"。你得有高标准，对吗？ ;]

编译并运行你的应用程序。它现在应该看起来......一样？怎么会这样？

地图并不了解 `image`。相反，你应该覆盖一个委托方法来提供自定义的针脚注释图像。这就是为什么它看起来和以前一样了。

在 `addAnnotations()` 后面添加以下方法：

```swift
public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
  guard let viewModel = annotation as? BusinessMapViewModel else {
    return nil
  }

  let identifier = "business"
  let annotationView: MKAnnotationView
  if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
    annotationView = existingView
  } else {
    annotationView = MKAnnotationView(annotation: viewModel, reuseIdentifier: identifier)
  }

  annotationView.image = viewModel.image
  annotationView.canShowCallout = true
  return annotationView
}
```

这只是创建了一个 `MKAnnotationView`，它为给定的注释显示正确的图像，这是我们的`BusinessMapViewModel` 对象之一。

编译并运行，你应该看到自定义的图像 点击一个，你会看到咖啡店的名字和评价。

![](https://koenig-media.raywenderlich.com/uploads/2018/04/Custom_Map_Pins-180x320.png)

看起来大多数旧金山的咖啡店实际上都是四星级或以上的，你可以一目了然地找到非常好的商店。



## 何去何从？

你在本章中了解了MVVM模式。这是一个很好的模式，可以帮助对抗大规模的视图控制器综合症，组织你的模型到视图的转换代码。

然而，它并没有完全解决大规模视图控制器的问题。视图控制器切换评级来创建视图模型不是很奇怪吗？如果你想引入一个新的案例，甚至是一个完全不同的视图模型，会发生什么？你将不得不使用另一种模式来处理这个问题：工厂模式。

如果你喜欢在本教程中所学到的东西，为什么不看看完整的《设计模式教程》这本书呢，它可以在我们的商店中提前获得。

设计模式是非常有用的，无论你用什么语言或平台开发。为正确的工作使用正确的模式可以节省你的时间，为你的团队创造更少的维护工作，并最终让你以更少的努力创造更多伟大的东西。每个开发人员都应该了解设计模式，以及如何和何时应用它们。这就是你将在本书中学习到的内容!

从MVC、Delegate和Strategy等模式的基本构件，到Factory、Prototype和Multicast Delegate模式等更高级的模式，最后是一些不太常见但仍然非常有用的模式，包括Flyweight、Command和Chain of Responsibility。

教程中的设计模式不仅涵盖了每一种模式的理论，而且你还会努力将每一种模式纳入每一章所包含的真实世界的应用程序中。在实践中学习，就像你在我们的《教程》系列中的其他书籍中所期待的那样，一步一步地学习。

为了庆祝这本书的发行，它目前正作为Advanced Swift Spring Bundle的一部分以40%的折扣出售。但不要等得太久，因为这个交易只持续到4月27日星期五。

如果你对本教程有任何问题或意见，欢迎在我们的论坛（https://forums.raywenderlich.com/c/books/design-patterns）上参与讨论。







