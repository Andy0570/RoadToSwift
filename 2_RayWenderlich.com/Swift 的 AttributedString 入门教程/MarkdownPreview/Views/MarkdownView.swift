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

struct MarkdownView: View {
  @State var markdownString: String = ""
  @State var selectedTheme: TextTheme = .noTheme
  @Environment(\.presentationMode) var presentation

  var dataSource: AttributedStringsDataSource<CustomAttributedString>

  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        List {
          HStack {
            Text("Theme:")
            Spacer()
            NavigationLink(selectedTheme.rawValue) {
              SelectThemeView(selectedTheme: $selectedTheme)
                .navigationTitle("Select Theme")
            }
            .frame(width: 120.0)
          }


          VStack {
            HStack {
              Text("Raw Markdown:")
                .bold()
              Spacer()
            }
            TextEditor(text: $markdownString)
              .frame(height: geometry.size.height * 0.3)
              .border(.gray, width: 1)
          }
          VStack {
            HStack {
              Text("Rendered Markdown:")
                .bold()
              Spacer()
            }
            HStack {
              CustomText(convertMarkdown(markdownString))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.top, 4.0)
              Spacer()
            }
            Spacer()
          }
        }
      }
      .navigationTitle("Markdown Preview")
      .navigationBarItems(
        leading: Button(action: cancelEntry) {
          Text("Cancel")
        },
        trailing: Button(action: saveEntry) {
          Text("Save")
        }.disabled(markdownString.isEmpty)
      )
    }.navigationViewStyle(.stack)
  }

  func saveEntry() {
    let originalAttributedString = convertMarkdown(markdownString)
    let customAttributedString = CustomAttributedString(
      originalAttributedString,
      theme: selectedTheme)
    dataSource.save(customAttributedString)
    cancelEntry()
  }


  func cancelEntry() {
    presentation.wrappedValue.dismiss()
  }

  private func convertMarkdown(_ string: String) -> AttributedString {
    // 将原始字符串转换为 markdown 格式的属性字符串
    guard var attributedString = try? AttributedString(
      markdown: string,
      including: AttributeScopes.CustomAttributes.self,
      options: AttributedString.MarkdownParsingOptions(allowsExtendedAttributes: true)
    ) else {
      return AttributedString(string)
    }

    // 将「通过 markdown 创建的属性字符串」属性与「主题属性容器」中的属性合并
    attributedString.mergeAttributes(selectedTheme.attributeContainer)
    printStringInfo(attributedString)
    return attributedString
  }

  private func printStringInfo(_ attributedString: AttributedString) {
    print("The string has \(attributedString.characters.count) characters")
    let characters =  attributedString.characters
    for char in characters {
      print(char)
    }

    print("The string has \(attributedString.runs.count) runs")
    let runs = attributedString.runs
    for run in runs {
      print(run)

      if let textStyle = run.inlinePresentationIntent {
        if textStyle.contains(.stronglyEmphasized) {
          print("Text is Bold")
        }
        if textStyle.contains(.emphasized) {
          print("Text is Italic")
        }
      } else {
        print("Text is Regular")
      }
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MarkdownView(dataSource: AttributedStringsDataSource())
  }
}
