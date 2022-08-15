/// Copyright (c) 2019 Razeware LLC
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

protocol NewContactViewControllerDelegate: class {
  func newContactViewController(_ newContactViewController: NewContactViewController, created: Contact)
  func newContactViewControllerDidCancel(_ newContactViewController: NewContactViewController)
}

class NewContactViewController: UIViewController {
  weak var delegate: NewContactViewControllerDelegate?

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var countryCodeTextField: UITextField!
  @IBOutlet weak var numberTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    firstNameTextField.delegate = self
    lastNameTextField.delegate = self
    countryCodeTextField.delegate = self
    numberTextField.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    firstNameTextField.becomeFirstResponder()
  }

  private func closeKeyboard() {
    for view in view.subviews where view.isFirstResponder {
        view.resignFirstResponder()
    }
  }

  @IBAction func cancel(_ sender: AnyObject) {
    closeKeyboard()
    delegate?.newContactViewControllerDidCancel(self)
  }

  @IBAction func save(_ sender: AnyObject) {
    // Validation
    guard let firstName = self.firstNameTextField.text,
      let lastName = self.lastNameTextField.text,
      let countryCode = self.countryCodeTextField.text,
      let numberString = self.numberTextField.text, firstName != "" || lastName != "" else {
        return
    }

    closeKeyboard()
    let contact = Contact(firstName: firstName, lastName: lastName)
    let number = Number(countryCode: countryCode, numberString: numberString, contact: contact)
    contact.number = number
    self.delegate?.newContactViewController(self, created: contact)
  }
}

// MARK: - UITextFieldDelegate

extension NewContactViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()

    switch textField {
    case firstNameTextField:
      lastNameTextField.becomeFirstResponder()
    case lastNameTextField:
      countryCodeTextField.becomeFirstResponder()
    case countryCodeTextField:
      numberTextField.becomeFirstResponder()
    case numberTextField:
      save(self)
    default:
      break
    }

    return true
  }
}
