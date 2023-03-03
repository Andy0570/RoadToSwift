import UIKit
import RealmSwift

//
// MARK: - Categories Table View Controller
//
class CategoriesTableViewController: UITableViewController {
    //
    // MARK: - Variables And Properties
    //
    let realm = try! Realm() // 注意：在生产环境中，你应当使用 do-catch 捕获并处理错误
    lazy var categories: Results<Category> = {
        self.realm.objects(Category.self)
    }()
    var selectedCategory: Category!

    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // 生成一些默认的类别填充列表
        populateDefaultCategories()
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

    private func populateDefaultCategories() {
        if categories.count == 0 {
            try! realm.write() { // 在 realm 上启动一个事务，准备向数据库中添加一些记录
                // 创建 Category 实例，并将其添加到数据库中
                let defaultCategories = ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids" ]

                for category in defaultCategories {
                    let newCategory = Category()
                    newCategory.name = category

                    realm.add(newCategory)
                }
            }

            // 从数据库中获取创建的类别，并存储到 categories 变量中
            categories = realm.objects(Category.self)
        }
    }
}

//
// MARK: - Table View Data Source
//
extension CategoriesTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategory = categories[indexPath.row]
        return indexPath
    }
}
