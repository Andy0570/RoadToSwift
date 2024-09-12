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

class LoginViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var welcomeField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  struct Storyboard {
    struct Identifiers {
      static let presentDiarySegue = "PresentDiarySegue"
    }
  }
  
  override func viewDidLoad() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    passwordField.becomeFirstResponder()
    
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let name = AccountManager.getName() {
      self.welcomeField.text = "Welcome back \(name)"
    }
    
    if !AccountManager.isPasswordProtected() {
      performSegue(withIdentifier: Storyboard.Identifiers.presentDiarySegue, sender: self)
    }
    
    super.viewWillAppear(animated)
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    let userInfo = notification.userInfo!
    
    let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      scrollView.contentInset = .zero
    } else {
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 72, right: 0)
    }
    
    scrollView.scrollIndicatorInsets = scrollView.contentInset
  }

  @IBAction func loginAction(_ sender: UIButton) {
    // This is a tutorial on Regular Expressions, not Authentication.
    // Do  not copy the authentication code used here!
    if let text = passwordField.text, AccountManager.validatePassword(text) {
      performSegue(withIdentifier: Storyboard.Identifiers.presentDiarySegue, sender: self)
    } else {
      let alertController = UIAlertController(title: "Invalid Password!", message: "Warning! Unauthorized access will get you fed to the sharks with laser beams attached to their heads.", preferredStyle: .alert)
      let dismissAction = UIAlertAction(title: "OK", style: .default)
      alertController.addAction(dismissAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
}

