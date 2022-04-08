/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

public struct CustomText: View {
  private var attributedString: AttributedString

  private var font: Font = .system(.body)

  public var body: some View {
    Text(attributedString)
  }

  public init(_ attributedString: AttributedString) {
    self.attributedString = CustomText.annotateCustomAttributes(from: attributedString)
  }

  public init(_ localizedKey: String.LocalizationValue) {
    attributedString = CustomText.annotateCustomAttributes(
      from: AttributedString(localized: localizedKey, including: \.customAttributes))
  }

  public func font(_ font: Font) -> CustomText {
    var selfText = self
    selfText.font = font
    return selfText
  }

  private static func annotateCustomAttributes(from source: AttributedString) -> AttributedString {
    var attrString = source

    for run in attrString.runs {
      guard run.customColor != nil || run.customStyle != nil else {
        continue
      }
      let range = run.range
      if let value = run.customStyle {
        if value == .boldcaps {
          let uppercased = attrString[range].characters.map { $0.uppercased() }.joined()
          attrString.characters.replaceSubrange(range, with: uppercased)
          attrString[range].inlinePresentationIntent = .stronglyEmphasized
        } else if value == .smallitalics {
          let lowercased = attrString[range].characters.map { $0.lowercased() }.joined()
          attrString.characters.replaceSubrange(range, with: lowercased)
          attrString[range].inlinePresentationIntent = .emphasized
        }
      }
      if let value = run.customColor {
        if value == .danger {
          attrString[range].backgroundColor = .red
          attrString[range].underlineStyle = Text.LineStyle(pattern: .dash, color: .yellow)
        } else if value == .highlight {
          attrString[range].backgroundColor = .yellow
          attrString[range].underlineStyle = Text.LineStyle(pattern: .dot, color: .red)
        }
      }
    }

    return attrString
  }
}
