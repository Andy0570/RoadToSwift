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

struct SearchOptions {
  let searchString: String
  var replacementString: String?
  let matchCase: Bool
  let wholeWords: Bool
}

class SearchOptionsViewController: UITableViewController {
  
  var searchOptions: SearchOptions?
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var replacementTextField: UITextField!
  @IBOutlet weak var replaceTextSwitch: UISwitch!
  @IBOutlet weak var matchCaseSwitch: UISwitch!
  @IBOutlet weak var wholeWordsSwitch: UISwitch!
  
  struct Storyboard {
    struct Identifiers {
      static let unwindSegueIdentifier = "UnwindSegue"
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let options = searchOptions {
      searchTextField.text = options.searchString
      replacementTextField.text = options.replacementString
      replaceTextSwitch.isOn = options.replacementString != nil
      matchCaseSwitch.isOn = options.matchCase
      wholeWordsSwitch.isOn = options.wholeWords
    }
    
    searchTextField.becomeFirstResponder()
  }
  
  @IBAction func cancelTapped(_ sender: AnyObject) {
    searchOptions = nil
    
    performSegue(withIdentifier: Storyboard.Identifiers.unwindSegueIdentifier, sender: self)
  }
  
  @IBAction func searchTapped(_ sender: AnyObject) {
    searchOptions = SearchOptions(searchString: searchTextField.text!,
                                  replacementString: replaceTextSwitch.isOn ? replacementTextField.text : nil,
                                  matchCase: matchCaseSwitch.isOn,
                                  wholeWords: wholeWordsSwitch.isOn)
    
    performSegue(withIdentifier: Storyboard.Identifiers.unwindSegueIdentifier, sender: self)
  }
  
  @IBAction func replaceTextSwitchToggled(_ sender: AnyObject) {
    replacementTextField.isEnabled = replaceTextSwitch.isOn
  }
}

