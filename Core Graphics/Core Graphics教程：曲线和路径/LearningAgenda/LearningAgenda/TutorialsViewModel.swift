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

import Foundation

final class TutorialsViewModel {
  let thingsToLearn = ["Drawing Rects", "Drawing Gradients", "Drawing Arcs"]
  let thingsLearned = ["Table Views", "UIKit", "Swift"]

  var numberOfSections: Int {
    return Section.allCases.count
  }

  func numberOfRows(in section: Int) -> Int {
    guard let section = Section(rawValue: section) else { return 0 }

    switch section {
    case .thingsToLearn:
      return thingsToLearn.count
    case .thingsLearned:
      return thingsLearned.count
    }
  }

  func text(at indexPath: IndexPath) -> String {
    guard let section = Section(rawValue: indexPath.section) else { return "" }

    switch section {
    case .thingsToLearn:
      return thingsToLearn[indexPath.row]
    case .thingsLearned:
      return thingsLearned[indexPath.row]
    }
  }

  func title(for section: Int) -> String {
    return Section(rawValue: section)?.description ?? ""
  }
}

extension TutorialsViewModel {
  enum Section: Int, CaseIterable {
    case thingsToLearn
    case thingsLearned
  }
}

extension TutorialsViewModel.Section: CustomStringConvertible {
  var description: String {
    switch self {
    case .thingsToLearn:
      return "Things To Learn"
    case .thingsLearned:
      return "Things Learned"
    }
  }
}
