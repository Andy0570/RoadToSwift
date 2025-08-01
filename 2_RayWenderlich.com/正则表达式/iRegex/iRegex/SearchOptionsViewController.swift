
import UIKit

struct SearchOptions {
    let searchString: String
    var replacementString: String?
    let matchCase: Bool //忽略大小写
    let wholeWords: Bool //匹配整个单词
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

