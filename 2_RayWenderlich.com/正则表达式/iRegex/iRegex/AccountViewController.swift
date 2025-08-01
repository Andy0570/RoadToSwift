
import UIKit

class AccountViewController: UITableViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var middleInitialField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var superVillianNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    struct Storyboard {
        struct Identifiers {
            static let unwindSegueIdentifier = "UnwindSegue"
        }
    }
    
    lazy var textFields: [UITextField] = []
    var regexes: [NSRegularExpression?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFields = [
            firstNameField,
            middleInitialField,
            lastNameField,
            superVillianNameField,
            passwordField,
        ]

        let patterns = [
            "^[a-z]{1,10}$",
            "^[a-z]$",
            "^[a-z'\\-]{2,20}$",
            "^[a-z0-9'.\\-\\s]{2,20}$",
            "^(?=\\P{Ll}*\\p{Ll})(?=\\P{Lu}*\\p{Lu})(?=\\P{N}*\\p{N})(?=[\\p{L}\\p{N}]*[^\\p{L}\\p{N}])[\\s\\S]{8,}$",
        ]

        // 根据 pattern 创建相应的 NSRegularExpression 实例
        regexes = patterns.map {
            do {
                let regex = try NSRegularExpression(pattern: $0, options: .caseInsensitive)
                return regex
            } catch {
                #if targetEnvironment(simulator)
                    fatalError("Error initializing regular expressions. Exiting.")
                #else
                    return nil
                #endif
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firstNameField.text = AccountManager.getFirstName()
        self.middleInitialField.text = AccountManager.getFMiddleInitial()
        self.lastNameField.text = AccountManager.getLastName()
        self.superVillianNameField.text = AccountManager.getSuperVillianName()
        self.passwordField.text = AccountManager.getPassword()
        
        super.viewWillAppear(animated)
    }
    
    @IBAction func saveTapped(_ sender: AnyObject) {
        if allTextFieldsAreValid() {
            AccountManager.setAccountWith(firstName: firstNameField.text,
                                          middleInitial: middleInitialField.text,
                                          lastName: lastNameField.text,
                                          superVillianName: superVillianNameField.text,
                                          password: passwordField.text)
            
            performSegue(withIdentifier: Storyboard.Identifiers.unwindSegueIdentifier, sender: self)
        } else {
            let alertController = UIAlertController(title: "Error!", message: "Could not save account details. Some text fields failed to validate.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(dismissAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func validate(string: String, withRegex regex: NSRegularExpression) -> Bool {
        let range = NSRange(string.startIndex..., in: string)
        let matchRange = regex.rangeOfFirstMatch(in: string, options: .reportProgress, range: range)
        return matchRange.location != NSNotFound
    }
    
    // 测试单个文本输入框，更新字体颜色
    func validateTextField(_ textField: UITextField) {
        let index = textFields.firstIndex(of: textField)
        if let regex = regexes[index!] {
            if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                let valid = validate(string: text, withRegex: regex)
                
                textField.textColor = (valid) ? .trueColor : .falseColor
            }
        }
    }
    
    // 测试每个非空的文本输入框是否有效
    func allTextFieldsAreValid() -> Bool {
        for (index, textField) in textFields.enumerated() {
            if let regex = regexes[index] {
                if let text = textField.text?.trimmingCharacters(in: .whitespaces) {
                    let valid = text.isEmpty || validate(string: text, withRegex: regex)
                    
                    if !valid {
                        return false
                    }
                }
            }
        }
        return true
    }
}

// MARK: - UITextFieldDelegate

extension AccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextField(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateTextField(textField)
        
        makeNextTextFieldFirstResponder(textField)
        
        return true
    }
    
    func makeNextTextFieldFirstResponder(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        if var index =  textFields.index(of: textField) {
            index += 1
            if index < textFields.count {
                textFields[index].becomeFirstResponder()
            }
        }
    }
}

// MARK: - UIColor helpers

extension UIColor {
    static var trueColor = UIColor(red: 0.1882, green: 0.6784, blue: 0.3882, alpha: 1.0)
    static var falseColor = UIColor(red: 0.7451, green: 0.2275, blue: 0.1922, alpha: 1.0)
}


