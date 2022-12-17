import UIKit
import RxSwift
import Then
import Alamofire
import RxRealmDataSources

class ListTimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    
    private let bag = DisposeBag()
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
            .subscribe { [weak self] _ in
                guard let self = self else {
                    return
                }

                self.navigator.show(segue: .listPeople(self.viewModel.account, self.viewModel.list), sender: self)
            }
            .disposed(by: bag)
        
        // Show tweets in table view
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "TweetCellView", cellType: TweetCellView.self) { cell, _, tweet in
            cell.update(with: tweet)
        }
        viewModel.tweets.bind(to: tableView.rx.realmChanges(dataSource)).disposed(by: bag)
        
        // Show message when no account available
        viewModel.loggedIn.drive(messageView.rx.isHidden).disposed(by: bag)
    }
}
