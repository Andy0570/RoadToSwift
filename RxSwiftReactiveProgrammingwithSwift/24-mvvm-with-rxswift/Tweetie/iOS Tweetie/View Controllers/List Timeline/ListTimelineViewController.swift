import UIKit
import RxSwift
import Then
import Alamofire
import RxRealmDataSources

class ListTimelineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!

    private let bag = DisposeBag()
    // ⬇️ 这两个类都是通过 createWith(navigator:storyboard:viewModel) 静态工厂方法注入的
    fileprivate var viewModel: ListTimelineViewModel!
    fileprivate var navigator: Navigator!

    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: ListTimelineViewModel) -> ListTimelineViewController {
        return storyboard.instantiateViewController(ofType: ListTimelineViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension

        title = "@\(viewModel.list.username)/\(viewModel.list.slug)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil)

        bindUI()
    }

    func bindUI() {
        // Bind button to the people view controller
        navigationItem.rightBarButtonItem!.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }

                self.navigator.show(segue: .listPeople(self.viewModel.account, self.viewModel.list), sender: self)
            })
            .disposed(by: bag)

        // Show tweets in table view
        // 创建另一个绑定来在列表中显示最新的推文
        // dataSource 是一个列表数据源，特别适合于从一个发出 Realm 集合变化的可观察序列中驱动列表视图。
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "TweetCellView", cellType: TweetCellView.self) { cell, _, tweet in
            cell.update(with: tweet)
        }

        // 将数据源绑定到视图控制器的列表视图上
        // 将 viewModel.tweets 与 realmChanges 绑定，并提供预设的数据源
        viewModel.tweets
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)

        // Show message when no account available
        // 根据用户是否登录了Twitter来显示或隐藏上面的信息
        viewModel.loggedIn.drive(messageView.rx.isHidden).disposed(by: bag)
    }
}
