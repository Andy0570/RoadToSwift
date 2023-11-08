> 原文：[Write better static UITableView with Swift 5 programmatically](https://medium.com/@kevin.laminto/write-better-static-uitableview-with-swift-5-programmatically-4737bbd85e5a)

面对现实吧，列表视图在未来几年内不会消失。它是显示一组类似数据的经典方法。

因此，在本文中，我将确保简明扼要地介绍如何**以编程方式**创建静态 `UITableView`，以方便那些不想通过 storyboard 实现它的人（出于一致性原因或其他任何原因）。

我们将在本项目中采用 MVVM 架构，以便保持清晰并进一步促进封装。我们还将尝试制作一个设置视图，因为它是静态 `UITableView` 的完美示例之一。

### Step 1

创建 `UITableViewController` 类

```swift
// Kevin Laminto
// SettingsTableViewController.swift
class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
}
```

你还需要创建一个名为 `SettingsViewModel` 的新文件。该类将负责列表视图的委托和数据源。此外，还要向主 VC（本例中为 `UITableViewController` 类）传递协议。

```swift
// Kevin Laminto
// SettingsViewModel.swift
protocol SettingsViewModelDelegate: class {
    // When the user tapped on the twitter cell, this function will be called
    // and passed to the delegate
    func twitterCellTapped()
}

class SettingsViewModel: NSObject {
    
    static let ReuseIdentifier = "SettingsCell"
    private weak var delegate: SettingsViewModelDelegate?
    
    init(delegate: SettingsViewModelDelegate) {
        super.init()
        self.delegate = delegate
        configureDatasource()
    }
    
    // This is where we will configure our datasource. e.g: the cells.
    private func configureDatasource() {
        
    }
}
```

请注意，`SettingsViewModelDelegate` 是可选的（并非代码可选，只是取决于你）。如果你希望整个处理过程都位于 ViewModel 内部，这是完全可行的。因此，你可以调用一个本地函数来代替委托。

### Step 2

现在让我们填充 ViewModel 类。我们需要创建两个模型对象。一个是 "Section" 对象，另一个是 "Section" 中的 Item。

我们将分别称它们为 `SettingsSection` 和 `SettingsItem`。你可以将其添加到 ViewModel 类中，也可以创建一个新文件。这取决于你。

```swift

// Kevin Laminto
// SettingsModel.swift
// SettingsSection will be the model for each of our
// sections. i.e: get in touch, accessibility, etc.
struct SettingsSection {
    var title: String // The title of the section
    var cells: [SettingsItem] // The cells that this section contains
}

// SettingsItem will be the model for each of our cells.
// i.e: twitter cell, log out cell, etc.
struct SettingsItem {
    var createdCell: () -> UITableViewCell // The cell that this item creates
    var action: ((SettingsItem) -> Swift.Void)? // The action that this item might have when tapped
}
```

在本文中，我们将保持简单。一个带有标题的简单部分（无 footer）。

### Step 3

现在我们的设置已经完成，让我们来填写数据源！在 ViewModel 类中，继续填写 `configureDatasource()` 方法，如下所示：

```swift
// Kevin Laminto
// SettingsViewModel.swift
class SettingsViewModel: NSObject {
    
    private var tableViewSections = [SettingsSection]()
    // ...
    
    private func configureDatasource() {
        // We are creating a getInTouchSection
        let getInTouchSection = SettingsSection(
            title: "Get in touch", // The title of the section
            cells: [ // The cells for the section
                SettingsItem(
                    createdCell: {
                        // Create a normal UITableViewCell
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.ReuseIdentifier)
                        cell.textLabel?.text = "Twitter"
                        cell.accessoryType = .disclosureIndicator
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.twitterCellTapped() } // Set what happen when user tapped on the cell
                )
            ] // Cells
        ) // Section
        
        // We put it into the global tableViewSections variable
        tableViewSections = [getInTouchSection]
    }
}
```

以及我们的列表视图委托和数据源：

```swift

// Kevin Laminto
// SettingsViewModel.swift
// MARK: - TableView delegate and datasource
extension SettingsViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSections[indexPath.section].cells[indexPath.row]
        return cell.createdCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableViewSections[indexPath.section].cells[indexPath.row]
        cell.action?(cell)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSections[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.text = tableViewSections[section].title
            headerView.textLabel?.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .bold)
        }
    }
}
```

没什么特别的，只是普通的列表视图委托和数据源方法。看看它有多简单明了！而不是使用 switch case 方法。

### Step 4

现在，我们已经完成了 ViewModel 的制作，让我们前往主类并填充其余部分。这样就完成了！

```swift
// Kevin Laminto
// SettingsTableViewController.swift
class SettingsTableViewController: UITableViewController {
    
    // Link between the viewModel and the View
    private var viewModel: SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SettingsViewModel(delegate: self) // We set the delegate of the protocol we defined earlier to this class
        
        // IMPORTANT. This transfer the responsibility of datasource and delegates to our ViewModel
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}

// MARK: - Delegation methods
extension SettingsTableViewController: SettingsViewModelDelegate {
    // This is the delegation method
    func twitterCellTapped() {
        // This case, open twitter!
        if let url = URL(string: "https://twitter.com/kevinlx_") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
```

下面是我为开源项目创建的设置的用户界面结果：

<img src="https://miro.medium.com/v2/resize:fit:1400/format:webp/1*iWClVNnDpqCKZQC5MhYGPg.png" style="zoom:50%;" />

### 总结

这并不是唯一的最佳创建方法，但在我的使用案例中，这已经足够好了，我想我也可以分享一下。如果你有兴趣查看使用这种方法的完整工作代码，我在 [github](https://github.com/kxvn-lx/Ghibliii) 上有一个开源项目。

如果您有任何问题或改进意见，请随时发送电子邮件至 kevin.laminto@gmail.com 或在 twitter 上与我联系！