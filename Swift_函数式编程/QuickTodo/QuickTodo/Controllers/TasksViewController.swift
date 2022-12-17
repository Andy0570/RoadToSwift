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
    var dataSources: RxTableViewSectionedAnimatedDataSource<TaskSection>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        configureDataSource()
    }

    func bindViewModel() {
        viewModel.sectionedItems.bind(to: tableView.rx.items(dataSource: dataSources)).disposed(by: self.rx.disposeBag)
    }

    private func configureDataSource() {
        dataSources = RxTableViewSectionedAnimatedDataSource<TaskSection>(configureCell: { [weak self] dataSources, tableView, IndexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemCell", for: IndexPath) as! TaskItemTableViewCell
            if let self = self {
                cell.configure(with: item, action: self.viewModel.onToggle(task: item))
            }
            return cell
        }, titleForHeaderInSection: { dataSources, index in
            dataSources.sectionModels[index].model
        })
    }
}
