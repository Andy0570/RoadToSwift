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
    }

    func bindViewModel() {
        viewModel.sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)
    }

    private func configureDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<TaskSection>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemCell", for: indexPath) as! TaskItemTableViewCell
            if let self = self {
                cell.configure(with: item, action: self.viewModel.onToggle(task: item))
            }
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            dataSource.sectionModels[index].model
        })
    }
}
