import UIKit
import RxSwift
import Then

class ListPeopleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!

    private let bag = DisposeBag()
    fileprivate var viewModel: ListPeopleViewModel!
    fileprivate var navigator: Navigator!

    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: ListPeopleViewModel) -> ListPeopleViewController {
        return storyboard.instantiateViewController(ofType: ListPeopleViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List Members"
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        bindUI()
    }

    func bindUI() {
        //show tweets in table view
        viewModel.people.asDriver()
            .drive(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: bag)

        // show message when no account available
        // 订阅 viewModel.people，将其转换为 Driver 并将元素映射为 true 和 false。
        // 当 viewModel.people 为 nil 时发出 false。用产生的 Driver<Bool> 驱动 messageView.rx.isHidden
        viewModel.people.asDriver()
            .map { $0 != nil }
            .drive(messageView.rx.isHidden)
            .disposed(by: bag)
    }
}

extension ListPeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.people.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(ofType: UserCellView.self).then { cell in
            cell.update(with: viewModel.people.value![indexPath.row])
        }
    }
}

extension ListPeopleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tweet = viewModel.people.value?[indexPath.row] else { return }
        navigator.show(segue: .personTimeline(viewModel.account, username: tweet.username), sender: self)
    }
}

