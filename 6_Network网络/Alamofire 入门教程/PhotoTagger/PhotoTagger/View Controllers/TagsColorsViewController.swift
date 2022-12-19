import UIKit

class TagsColorsViewController: UIViewController {
    
    // MARK: - Properties

    var tags: [String]?
    var colors: [PhotoColor]?
    var tableViewController: TagsColorsTableViewController?
    
    // MARK: - IBOutlets

    @IBOutlet var segmentedControl: UISegmentedControl!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DataTable" {
            tableViewController = segue.destination as? TagsColorsTableViewController
        }
    }
    
    // MARK: - IBActions

    @IBAction func tagsColorsSegmentedControlChanged(_ sender: UISegmentedControl) {
        setupTableData()
    }
    
    // MARK: - Public

    func setupTableData() {
        if segmentedControl.selectedSegmentIndex == 0 {
            setupTagsTableData()
        } else {
            setupColorsTableData()
        }
        
        tableViewController?.tableView.reloadData()
    }
    
    func setupTagsTableData() {
        if let tags = tags {
            tableViewController?.data = tags.map { tag in
                TagsColorTableData(label: tag, color: nil)
            }
        } else {
            tableViewController?.data = [TagsColorTableData(label: "No tags were fetched.", color: nil)]
        }
    }
    
    func setupColorsTableData() {
        if let colors = colors {
            tableViewController?.data = colors.map { photoColor in
                let color = UIColor(red: CGFloat(photoColor.red) / 255,
                                    green: CGFloat(photoColor.green) / 255,
                                    blue: CGFloat(photoColor.blue) / 255,
                                    alpha: 1.0)
                return TagsColorTableData(label: photoColor.colorName, color: color)
            }
        } else {
            tableViewController?.data = [TagsColorTableData(label: "No colors were fetched.", color: nil)]
        }
    }
}
