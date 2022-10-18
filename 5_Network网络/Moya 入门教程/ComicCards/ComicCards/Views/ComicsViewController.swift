/**
 ## Reference
 [Moya Tutorial for iOS: Getting Started](https://www.raywenderlich.com/5121-moya-tutorial-for-ios-getting-started)

 ## History
 - 20220811
 - 20221018

 */

import Foundation
import UIKit
import Moya

class ComicsViewController: UIViewController {
    let provider = MoyaProvider<Marvel>()

    // MARK: - View State
    private var state: State = .loading {
        didSet {
            switch state {
            case .ready:
                viewMessage.isHidden = true
                tblComics.isHidden = false
                tblComics.reloadData()
            case .loading:
                tblComics.isHidden = true
                viewMessage.isHidden = false
                lblMessage.text = "Getting comics ..."
                imgMeessage.image = #imageLiteral(resourceName: "Loading")
            case .error:
                tblComics.isHidden = true
                viewMessage.isHidden = false
                lblMessage.text = """
                            Something went wrong!
                            Try again later.
                          """
                imgMeessage.image = #imageLiteral(resourceName: "Error")
            }
        }
    }

    // MARK: - Outlets
    @IBOutlet weak private var tblComics: UITableView!
    @IBOutlet weak private var viewMessage: UIView!
    @IBOutlet weak private var lblMessage: UILabel!
    @IBOutlet weak private var imgMeessage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        state = .loading

        // 使用 Moya Provider 在 .comic 端点执行网络请求
        provider.request(.comics) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                do {
                    // print(try response.mapJSON())
                    self.state = .ready(try response.map(MarvelResponse<Comic>.self).data.results)
                } catch {
                    self.state = .error
                }
            case .failure:
                self.state = .error
            }
        }
    }
}

extension ComicsViewController {
    enum State {
        case loading
        case ready([Comic])
        case error
    }
}

// MARK: - UITableView Delegate & Data Source
extension ComicsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ComicCell.reuseIdentifier, for: indexPath) as? ComicCell ?? ComicCell()

        guard case .ready(let items) = state else { return cell }

        cell.configureWith(items[indexPath.item])

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let items) = state else { return 0 }

        return items.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard case .ready(let items) = state else { return }

        let comicVC = CardViewController.instantiate(comic: items[indexPath.item])
        navigationController?.pushViewController(comicVC, animated: true)
    }
}

