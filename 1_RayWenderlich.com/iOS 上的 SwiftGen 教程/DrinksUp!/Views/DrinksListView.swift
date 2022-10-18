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

struct DrinksListView: View {
  @StateObject var drinkStore = DrinkStore()
  @State private var showInformation = false


  var body: some View {
    NavigationView {
      List {
        Section(footer: footerView) {
          ForEach(Array(0..<drinkStore.drinks.count), id: \.self) { index in
            NavigationLink(
              destination: DrinkDetailView(index: index).environmentObject(drinkStore)) {
              Text(drinkStore.drinks[index].name)
                .font(Font.custom("NotoSans", size: 17, relativeTo: .body))
            }
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          HStack(spacing: 0) {
            //Image("milkshake")
            Image(Asset.Assets.milkshake.name)
              .resizable()
              .frame(width: 40, height: 40)
            //Text("DrinkList.Navigation.Title")
            Text(Strings.DrinkList.Navigation.title)
              .font(Font.custom("NotoSans-Bold", size: 17, relativeTo: .body))
              .foregroundColor(Asset.Colors.textColor.color) // 使用 SwiftUI 支持的颜色
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            showInformation.toggle()
          }, label: {
            Text("DrinkList.Navigation.Button.LearnMore")
          })
        }
      }
    }
    .sheet(isPresented: $showInformation) {
      InformationView()
    }
  }

  private var drinkCountString: String {
//    let format = NSLocalizedString("drinksCount", comment: "")
//    return String.localizedStringWithFormat(format, drinkStore.drinks.count)
    Strings.drinksCount(drinkStore.drinks.count)
  }

  private var footerView: some View {
    Text(drinkCountString)
      .font(Font.custom("NotoSans", size: 11, relativeTo: .caption2))
  }
}

struct DrinksListView_Previews: PreviewProvider {
  struct Preview: View {
    @ObservedObject var drinkModel = DrinkStore()
    var body: some View {
      DrinksListView(drinkStore: drinkModel)
    }
  }

  static var previews: some View {
    Preview()
  }
}
