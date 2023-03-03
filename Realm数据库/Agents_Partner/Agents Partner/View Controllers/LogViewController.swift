import MapKit
import UIKit
import RealmSwift

//
// MARK: - Log View Controller
//
class LogViewController: UITableViewController {
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    //
    // MARK: - Variables And Properties
    //
    var searchResults = try! Realm().objects(Specimen.self)
    var searchController: UISearchController!
    // 获取 Realm 数据库中的所有标本，并按照名称排序
    var specimens = try! Realm().objects(Specimen.self).sorted(byKeyPath: "name", ascending: true)

    //
    // MARK: - IBActions
    //
    @IBAction func scopeChanged(sender: Any) {
        let scopeBar = sender as! UISegmentedControl
        let realm = try! Realm()

        switch scopeBar.selectedSegmentIndex {
        case 1:
            specimens = realm.objects(Specimen.self).sorted(byKeyPath: "created", ascending: true)
        default:
            specimens = realm.objects(Specimen.self).sorted(byKeyPath: "name", ascending: true)
        }

        tableView.reloadData()
    }

    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.rowHeight = 63
        searchResultsController.tableView.register(LogCell.self, forCellReuseIdentifier: "LogCell")

        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)

        tableView.tableHeaderView?.addSubview(searchController.searchBar)

        definesPresentationContext = true
    }

    func filterResultsWithSearchString(searchString: String) {
        // 创建一个谓词，搜索以 searchString 开头的名字。BEGINSWITH 后面的 [c] 表示一个不区分大小写的搜索
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString)
        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        let realm = try! Realm()

        switch scopeIndex {
        case 0:
            searchResults = realm.objects(Specimen.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        case 1:
            searchResults = realm.objects(Specimen.self).filter(predicate).sorted(byKeyPath: "created", ascending: true)
        default:
            searchResults = realm.objects(Specimen.self).filter(predicate)
        }
    }

    // 把选定的标本传递给 AddNewEntryController 实例
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Edit") {
            let controller = segue.destination as! AddNewEntryViewController
            var selectedSpecimen: Specimen!
            let indexPath = tableView.indexPathForSelectedRow

            // 根据用户是否在搜索，获取所选标本
            if searchController.isActive {
                let searchResultsController = searchController.searchResultsController as! UITableViewController
                let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow

                selectedSpecimen = searchResults[indexPathSearch!.row]
            } else {
                selectedSpecimen = specimens[indexPath!.row]
            }

            controller.specimen = selectedSpecimen
        }
    }
}

//
// MARK: - Search Bar Delegate
//
extension LogViewController:  UISearchBarDelegate {

}

//
// MARK: - Search Results Updatings
//
extension LogViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString: searchString)
        let searchResultsController = searchController.searchResultsController as! UITableViewController
        searchResultsController.tableView.reloadData()
    }
}

//
// MARK: - Table View Data Source
extension LogViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LogCell") as! LogCell

        let specimen = searchController.isActive ? searchResults[indexPath.row] : specimens[indexPath.row]

        cell.titleLabel.text = specimen.name
        cell.subtitleLabel.text = specimen.category.name

        switch specimen.category.name {
        case "Uncategorized":
            cell.iconImageView.image = UIImage(named: "IconUncategorized")
        case "Reptiles":
          cell.iconImageView.image = UIImage(named: "IconReptile")
        case "Flora":
          cell.iconImageView.image = UIImage(named: "IconFlora")
        case "Birds":
          cell.iconImageView.image = UIImage(named: "IconBird")
        case "Arachnid":
          cell.iconImageView.image = UIImage(named: "IconArachnid")
        case "Mammals":
          cell.iconImageView.image = UIImage(named: "IconMammal")
        default:
          cell.iconImageView.image = UIImage(named: "IconUncategorized")
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : specimens.count
    }
}
