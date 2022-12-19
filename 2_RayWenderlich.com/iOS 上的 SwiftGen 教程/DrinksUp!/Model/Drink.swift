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

class DrinkStore: ObservableObject {
  @Published var drinks: [Drink] = []
  init() {
    drinks.append(contentsOf: DrinkStore.mockData)
  }
}

class Drink: Decodable {
  var name: String
  var rating: Int
  var description: String

  init(name: String, rating: Int, description: String) {
    self.name = name
    self.rating = rating
    self.description = description
  }
}

extension Drink: Identifiable {
  var id: String { name }
}

//struct MockData: Decodable {
//  let starterDrinks: [Drink]
//}

extension DrinkStore {
  static var mockData: [Drink] {
//    guard let jsonURL = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
//      return []
//    }
//    do {
//      let data = try Data(contentsOf: jsonURL)
//      let mockDrink = try JSONDecoder().decode(MockData.self, from: data)
//      return mockDrink.starterDrinks
//    } catch {
//      print(error.localizedDescription)
//      return []
//    }

    do {
      let data = try JSONSerialization.data(withJSONObject: JSONFiles.starterDrinks, options: [])
      let mockDrink = try JSONDecoder().decode([Drink].self, from: data)
      return mockDrink
    } catch {
      print(error.localizedDescription)
      return []
    }
    
  }
}
