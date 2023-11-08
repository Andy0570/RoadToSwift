import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx

class TasksViewController: UIViewController, BindableType {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var statisticsLabel: UILabel!
    @IBOutlet var newTaskButton: UIBarButtonItem!

    var viewModel: TasksViewModel!
    var dataSource: RxTableViewSectionedAnimatedDataSource<TaskSection>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        configureDataSource()

        // Challenge 1: 将控制器始终置于编辑模式，以支持cell向左滑动
        setEditing(true, animated: false)
    }

    func bindViewModel() {
        viewModel.sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)

        // 将创建 task item 的 Action 与按钮绑定
        newTaskButton.rx.action = viewModel.onCreateTask()

        // 当前 cell 被选中时，触发编辑操作
        tableView.rx.itemSelected
            .do(onNext: { [unowned self] indexPath in
                // 在点击某行编辑一个项目后，如果此时点击取消按钮，该行将保持选中。用 do(onNext:) 操作符很容易解决这个问题
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .map { [unowned self] indexPath in
                // 通过 dataSource 获取与 IndexPath 索引匹配的模型对象，输入到动作的 inputs 中
                try! self.dataSource.model(at: indexPath) as! TaskItem
            }
            .bind(to: viewModel.editAction.inputs)
            .disposed(by: self.rx.disposeBag)

        // Challenge 1，支持 item 删除
        tableView.rx.itemDeleted
            .map { [unowned self] indexPath in
                try! self.tableView.rx.model(at: indexPath)
            }
            .subscribe(viewModel.deleteAction.inputs)
            .disposed(by: self.rx.disposeBag)

        // Challenge 2
        viewModel.statistics
            .subscribe { [weak self] stats in
                let total = stats.todo + stats.done
                self?.statisticsLabel.text = "\(total) tasks, \(stats.todo) due."
            }
            .disposed(by: self.rx.disposeBag)
    }

    private func configureDataSource() {
        // 在 RxDataSources 的 dataSource 对象中配置每个 cell
        dataSource = RxTableViewSectionedAnimatedDataSource<TaskSection>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemCell", for: indexPath) as! TaskItemTableViewCell
            if let self = self {
                // Action 是由 ViewModel 提供的，VC 的作用是连接 cell 和 Action
                cell.configure(with: item, action: self.viewModel.onToggle(task: item))
            }
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            // 此处的 titleForHeaderInSection 闭包为 Section Header 返回一个 String 类型的标题。
            // 如果你想要更复杂的东西，你可以通过设置 dataSource.supplementaryViewFactory 来配置它，
            // 以便为UICollectionElementKindSectionHeader 种类返回一个适当的 UICollectionReusableView。
            dataSource.sectionModels[index].model
        }, canEditRowAtIndexPath: { _, _ in true })
    }
}
