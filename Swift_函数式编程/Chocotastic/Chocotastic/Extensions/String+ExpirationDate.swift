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

extension String {
  var addingSlash: String {
    guard count > 2 else {
      //Nothing to add
      return self
    }
    
    let index2 = index(startIndex, offsetBy: 2)
    let firstTwo = prefix(upTo: index2)
    let rest = suffix(from: index2)
    
    return firstTwo + " / " + rest
  }
  
  var removingSlash: String {
    return removingSpaces.replacingOccurrences(of: "/", with: "")
  }
  
  var isExpirationDateValid: Bool {
    let noSlash = removingSlash
    
    guard noSlash.count == 6 //Must be mmyyyy
      && noSlash.areAllCharactersNumbers else { //must be all numbers
        return false
    }
    
    let index2 = index(startIndex, offsetBy: 2)
    let monthString = prefix(upTo: index2)
    let yearString = suffix(from: index2)
    
    guard let month = Int(monthString),
      let year = Int(yearString) else {
        //We can't even check.
        return false
    }
    
    //Month must be between january and december.
    guard (month >= 1 && month <= 12) else {
      return false
    }
    
    let now = Date()
    let currentYear = now.year
    
    guard year >= currentYear else {
      //Year is before current: Not valid.
      return false
    }
    
    if year == currentYear {
      let currentMonth = now.month
      guard month >= currentMonth else {
        //Month is before current in current year: Not valid.
        return false
      }
    }
    
    //If we made it here: Woo!
    return true
  }
}
