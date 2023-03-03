import UIKit
import RealmSwift

//
// MARK: - Add New Entry View Controller
//
class AddNewEntryViewController: UIViewController {
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var nameTextField: UITextField!

    //
    // MARK: - Variables And Properties
    //
    var selectedAnnotation: SpecimenAnnotation!
    var selectedCategory: Category!
    var specimen: Specimen!

    //
    // MARK: - IBActions
    //
    @IBAction func unwindFromCategories(segue: UIStoryboardSegue) {
        if segue.identifier == "CategorySelectedSegue" {
            let categoriesController = segue.source as! CategoriesTableViewController
            selectedCategory = categoriesController.selectedCategory
            categoryTextField.text = selectedCategory.name
        }
    }

    //
    // MARK: - Private Methods
    //

    // 创建并添加标本到数据库
    func addNewSpecimen() {
        let realm = try! Realm()

        try! realm.write {
            let newspecimen = Specimen()

            newspecimen.name = nameTextField.text!
            newspecimen.category = selectedCategory
            newspecimen.specimenDescription = descriptionTextField.text
            newspecimen.latitude = selectedAnnotation.coordinate.latitude
            newspecimen.longitude = selectedAnnotation.coordinate.longitude

            realm.add(newspecimen)
            specimen = newspecimen
        }
    }

    // 更新标本时，将旧数据填充到输入框
    func fillTextField() {
        nameTextField.text = specimen.name
        categoryTextField.text = specimen.category.name
        descriptionTextField.text = specimen.specimenDescription

        selectedCategory = specimen.category
    }

    // 更新标本
    func updateSpecimen() {
        let realm = try! Realm()

        try! realm.write {
            specimen.name = nameTextField.text!
            specimen.category = selectedCategory
            specimen.specimenDescription = descriptionTextField.text
        }
    }

    func validateFields() -> Bool {
        if nameTextField.text!.isEmpty ||
            descriptionTextField.text!.isEmpty ||
            selectedCategory == nil {
            let alertController = UIAlertController(title: "Validation Error",
                                                    message: "All fields must be filled",
                                                    preferredStyle: .alert)

            let alertAction = UIAlertAction(title: "OK", style: .destructive) { alert in
                alertController.dismiss(animated: true, completion: nil)
            }

            alertController.addAction(alertAction)

            present(alertController, animated: true, completion: nil)

            return false
        } else {
            return true
        }
    }
                                              
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        if let specimen = specimen {
            title = "Edit \(specimen.name)"
            fillTextField()
        } else {
            title = "Add New Specimen"
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if validateFields() {

            // 判断是更新还是添加标本
            if specimen != nil {
                updateSpecimen()
            } else {
                addNewSpecimen()
            }

            return true
        } else {
            return false
        }
    }
}

//
// MARK: - Text Field Delegate
//
extension AddNewEntryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "Categories", sender: self)
    }
}
