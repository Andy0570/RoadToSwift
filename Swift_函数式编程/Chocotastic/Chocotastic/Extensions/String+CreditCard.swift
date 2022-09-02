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
  var areAllCharactersNumbers: Bool {
    let nonNumberCharacterSet = CharacterSet.decimalDigits.inverted
    return (rangeOfCharacter(from: nonNumberCharacterSet) == nil)
  }
  
  var isLuhnValid: Bool {
    //https://www.rosettacode.org/wiki/Luhn_test_of_credit_card_numbers
    
    guard areAllCharactersNumbers else {
      //Definitely not valid.
      return false
    }
    
    let reversed = self.reversed().map { String($0) }
    
    var sum = 0
    for (index, element) in reversed.enumerated() {
      guard let digit = Int(element) else {
        //This is not a number.
        return false
      }
      
      if index % 2 == 1 {
        //Even digit
        switch digit {
        case 9:
          //Just add nine.
          sum += 9
        default:
          //Multiply by 2, then take the remainder when divided by 9 to get addition of digits.
          sum += ((digit * 2) % 9)
        }
      } else {
        //Odd digit
        sum += digit
      }
    }
    
    //Valid if divisible by 10
    return sum % 10 == 0
  }
  
  var removingSpaces: String {
    return replacingOccurrences(of: " ", with: "")
  }
  
  func integerValue(ofFirstCharacters count: Int) -> Int? {
    guard areAllCharactersNumbers, count <= self.count else {
      return nil
    }
    
    let substring = prefix(count)
    guard let integerValue = Int(substring) else {
      return nil
    }
    
    return integerValue
  }
}
