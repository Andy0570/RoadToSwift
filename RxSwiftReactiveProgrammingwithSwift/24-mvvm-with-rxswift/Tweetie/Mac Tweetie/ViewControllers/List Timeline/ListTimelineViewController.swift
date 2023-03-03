import Foundation
import Cocoa
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import Then
import RxRealmDataSources

class ListTimelineViewController: NSViewController {
    private let bag = DisposeBag()
    fileprivate var viewModel: ListTimelineViewModel!
    fileprivate var navigator: Navigator!

    @IBOutlet var tableView: NSTableView!

    static func createWith(navigator: Navigator, storyboard: NSStoryboard, viewModel: ListTimelineViewModel) -> ListTimelineViewController {
        return storyboard.instantiateViewController(ofType: ListTimelineViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSApp.windows.first?.title = "@\(viewModel.list.username)/\(viewModel.list.slug)"

        bindUI()
    }

    func bindUI() {
        // Show tweets in table view
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "TweetCellView", cellType: TweetCellView.self) { cell, row, tweet in
            cell.update(with: tweet)
        }

        viewModel.tweets
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
    }
}
