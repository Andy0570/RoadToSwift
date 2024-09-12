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

class SearchViewController: UIViewController {
  
  struct Storyboard {
    struct Identifiers {
      static let searchOptionsSegueIdentifier = "SearchOptionsSegue"
    }
  }
  
  enum Decoration {
    case underlining
    case noDecoration
  }
  
  var searchOptions: SearchOptions?
  var readingModeEnabled: Bool = false
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var readingModeButton: UIBarButtonItem!
  
  @IBAction func unwindToTextHighlightViewController(_ segue: UIStoryboardSegue) {
    if let searchOptionsViewController = segue.source as? SearchOptionsViewController,
      let options = searchOptionsViewController.searchOptions {
        performSearchWithOptions(options)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.Identifiers.searchOptionsSegueIdentifier {
      if let options = self.searchOptions,
        let navigationController = segue.destination as? UINavigationController,
        let searchOptionsViewController = navigationController.topViewController as? SearchOptionsViewController {
          searchOptionsViewController.searchOptions = options
      }
    }
  }
  
  //MARK: Text highlighting, and Find and Replace
  
  func performSearchWithOptions(_ searchOptions: SearchOptions) {
    self.searchOptions = searchOptions
    
    if let replacementString = searchOptions.replacementString {
      searchForText(searchOptions.searchString, replaceWith: replacementString, inTextView: textView)
    } else {
      highlightText(searchOptions.searchString, inTextView: textView)
    }
  }
  
  func searchForText(_ searchText: String, replaceWith replacementText: String, inTextView textView: UITextView) {
    if let beforeText = textView.text, let searchOptions = self.searchOptions {
      let range = NSRange(beforeText.startIndex..., in: beforeText)
      
      if let regex = try? NSRegularExpression(options: searchOptions) {
        let afterText = regex?.stringByReplacingMatches(
          in: beforeText,
          options: [],
          range: range,
          withTemplate: replacementText
        )
        textView.text = afterText
      }
    }
  }
  
  func highlightText(_ searchText: String, inTextView textView: UITextView) {
    let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
    let attributedTextRange = NSMakeRange(0, attributedText.length)
    attributedText.removeAttribute(NSAttributedString.Key.backgroundColor, range: attributedTextRange)

    if let searchOptions = self.searchOptions, let regex = try? NSRegularExpression(options: searchOptions) {
      let range = NSRange(textView.text.startIndex..., in: textView.text)
      if let matches = regex?.matches(in: textView.text, options: [], range: range) {
        for match in matches {
          let matchRange = match.range
          attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: matchRange)
        }
      }
    }

    textView.attributedText = (attributedText.copy() as! NSAttributedString)
  }
  
  func rangeForAllTextInTextView() -> NSRange {
    return NSRange(textView.text.startIndex..., in: textView.text)
  }
  
  //MARK: Underline dates, times, and splitters
  
  @IBAction func toggleReadingMode(_ sender: AnyObject) {
    if !self.readingModeEnabled {
      readingModeEnabled = true
      decorateAllDatesWith(.underlining)
      decorateAllTimesWith(.underlining)
      decorateAllSplittersWith(.underlining)
    } else {
      readingModeEnabled = false
      decorateAllDatesWith(.noDecoration)
      decorateAllTimesWith(.noDecoration)
      decorateAllSplittersWith(.noDecoration)
    }
  }
  
  func decorateAllDatesWith(_ decoration: Decoration) {
    if let regex = NSRegularExpression.regularExpressionForDates {
      let matches = matchesForRegularExpression(regex, inTextView: textView)
      switch decoration  {
      case .underlining:
        highlightMatches(matches)
      case .noDecoration:
        removeHighlightedMatches(matches)
      }
    }
  }

  func decorateAllTimesWith(_ decoration: Decoration) {
    if let regex = NSRegularExpression.regularExpressionForTimes {
      let matches = matchesForRegularExpression(regex, inTextView: textView)
      switch decoration {
      case .underlining:
        highlightMatches(matches)
      case .noDecoration:
        removeHighlightedMatches(matches)
      }
    }
  }

  func decorateAllSplittersWith(_ decoration: Decoration) {
    if let regex = NSRegularExpression.regularExpressionForSplitter {
      let matches = matchesForRegularExpression(regex, inTextView: textView)
      switch decoration {
      case .underlining:
        highlightMatches(matches)
      case .noDecoration:
        removeHighlightedMatches(matches)
      }
    }
  }
  
  func matchesForRegularExpression(_ regex: NSRegularExpression, inTextView textView: UITextView) -> [NSTextCheckingResult] {
    let string = textView.text
    let range = rangeForAllTextInTextView()
    
    return regex.matches(in: string!, options: [], range: range)
  }
  
  func highlightMatches(_ matches: [NSTextCheckingResult]) {
    let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
    for match in matches {
      let matchRange = match.range
      attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: matchRange)
    }
    textView.attributedText = (attributedText.copy() as! NSAttributedString)
  }
  
  func removeHighlightedMatches(_ matches: [NSTextCheckingResult]) {
    let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
    
    for match in matches {
      let matchRange = match.range
      attributedText.removeAttribute(NSAttributedString.Key.foregroundColor, range: matchRange)
    }
    textView.attributedText = (attributedText.copy() as! NSAttributedString)
  }
}

