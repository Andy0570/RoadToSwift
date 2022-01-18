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

struct QuoteDetailsView: View {
  let quote: Quote
  let noImage = UIImage()
  @State private var image = UIImage()
  @State private var showLoginAlert = false
  @State private var isBookmarked = false

  init(withQuote quote: Quote, image: UIImage = UIImage()) {
    self.quote = quote
  }

  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        Text(quote.formattedBody)
          .multilineTextAlignment(.center)
          .font(Font.system(Font.TextStyle.largeTitle))
          .foregroundColor(.white)
          .shadow(color: .black, radius: 2, x: 0, y: 0)
        HStack {
          Spacer()
          Text(quote.formattedAuthor)
            .font(Font.system(Font.TextStyle.title2))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 2, x: 0, y: 0)
        }
        .padding()
        Spacer()
      }
      .padding()
      .background(
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill))
      .clipped()
      .navigationTitle("Quote")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Button {
          if let currentUser = User.currentUser {
            if !isBookmarked {
              DataProvider.sharedInstance.bookmark(quote: quote, forUser: currentUser) { success in
                DispatchQueue.main.async {
                  isBookmarked = success
                }
              }
            }
          } else {
            showLoginAlert.toggle()
          }
        } label: {
          Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
        }
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .alert(isPresented: $showLoginAlert) {
      Alert(
        title: Text("Login Error"),
        message: Text("You need to login before bookmarking your favorite quotes!"),
        dismissButton: .default(Text("OK")))
    }
    .onAppear {
      if image === noImage {
        DataProvider.sharedInstance.getRandomPicture { anImage in
          self.image = anImage ?? noImage
        }
      }
    }
  }
}

struct QuoteDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    QuoteDetailsView(withQuote: Quote.sample)
  }
}
