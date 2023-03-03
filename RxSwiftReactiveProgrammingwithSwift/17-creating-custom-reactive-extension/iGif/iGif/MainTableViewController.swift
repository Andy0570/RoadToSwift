import UIKit
import RxSwift

class MainTableViewController: UITableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let bag = DisposeBag()
    private var gifs = [GiphyGif]()
    private let search = BehaviorSubject(value: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "iGif"

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        search.filter { $0.count >= 3 }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[GiphyGif]> in
                return ApiController.shared.search(text: query)
                    .catchAndReturn([])
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.gifs = result
                self.tableView.reloadData()
            })
            .disposed(by: bag)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GifCell", for: indexPath) as! GifTableViewCell

        let gif = gifs[indexPath.item]
        cell.downloadAndDisplay(gif: gif.image.url)

        return cell
    }
}

extension MainTableViewController: UISearchResultsUpdating {

    public func updateSearchResults(for searchController: UISearchController) {
        search.onNext(searchController.searchBar.text ?? "")
    }

}
