/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
    return true
  }
  
  func validateTextField(_ textField: UITextField) {
  }
  
  func allTextFieldsAreValid() -> Bool {
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


