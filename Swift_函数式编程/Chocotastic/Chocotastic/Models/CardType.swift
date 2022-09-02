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


import UIKit

enum CardType {
    case
    unknown,
    amex,
    mastercard,
    visa,
    discover

    //https://en.wikipedia.org/wiki/Payment_card_number
    static func fromString(string: String) -> CardType {
        guard !string.isEmpty else {
            //We definitely can't determine from an empty string.
            return .unknown
        }

        guard string.areAllCharactersNumbers else {
            assertionFailure("One of these characters is not a number!")
            return .unknown
        }

        //Visa: Starts with 4
        //Mastercard: Starts with 2221-2720 or 51-55
        //Amex: Starts with 34 or 37
        //Discover: Starts with 6011, 622126-622925, 644-649, or 65


        if string.hasPrefix("4") {
            //If the first # is a 4, it's a visa
            return .visa
        } //Else, we need more info, keep going


        guard let firstTwo = string.integerValue(ofFirstCharacters: 2) else {
            return .unknown
        }

        switch firstTwo {
        case 51...55:
            return .mastercard
        case 65:
            return .discover
        case 34, 37:
            return .amex
        default:
            //Can't determine type yet
            break
        }

        guard let firstThree = string.integerValue(ofFirstCharacters: 3) else {
            return .unknown
        }

        switch firstThree {
        case 644...649:
            return .discover
        default:
            //Can't determine type yet
            break
        }


        guard let firstFour = string.integerValue(ofFirstCharacters: 4) else {
            return .unknown
        }

        switch firstFour {
        case 2221...2720:
            return .mastercard
        case 6011:
            return .discover
        default:
            //Can't determine type yet
            break
        }

        guard let firstSix = string.integerValue(ofFirstCharacters: 6) else {
            return .unknown
        }

        switch firstSix {
        case 622126...622925:
            return .discover
        default:
            //If we've gotten here, ¯\_(ツ)_/¯
            return .unknown
        }
    }

    var expectedDigits: Int {
        switch self {
        case .amex:
            return 15
        default:
            return 16
        }
    }

    var image: UIImage? {
        switch self {
        case .amex:
            return ImageName.amex.image
        case .discover:
            return ImageName.discover.image
        case .mastercard:
            return ImageName.mastercard.image
        case .visa:
            return ImageName.visa.image
        case .unknown:
            return ImageName.unknownCard.image
        }
    }

    var cvvDigits: Int {
        switch self {
        case .amex:
            return 4
        default:
            return 3
        }
    }

    func format(noSpaces: String) -> String {
        guard noSpaces.count >= 4 else {
            //No formatting necessary if <= 4
            return noSpaces
        }


        let startIndex = noSpaces.startIndex


        let index4 = noSpaces.index(startIndex, offsetBy: 4)
        //All cards start with four digits before the get to spaces
        let firstFour = String(noSpaces.prefix(upTo: index4))
        var formattedString = firstFour + " "

        switch self {
        case .amex:
            //Amex format is xxxx xxxxxx xxxxx
            guard noSpaces.count > 10 else {
                //No further formatting required.
                return formattedString + String(noSpaces.suffix(from: index4))
            }


            let index10 = noSpaces.index(startIndex, offsetBy: 10)
            let nextSix = String(noSpaces[index4..<index10])
            let remaining = String(noSpaces.suffix(from: index10))
            return formattedString + nextSix + " " + remaining
        default:
            //Other cards are formatted as xxxx xxxx xxxx xxxx
            guard noSpaces.count > 8 else {
                //No further formatting required.
                return formattedString + String(noSpaces.suffix(from: index4))
            }

            let index8 = noSpaces.index(startIndex, offsetBy: 8)
            let nextFour = String(noSpaces[index4..<index8])
            formattedString += nextFour + " "

            guard noSpaces.count > 12 else {
                //Just add the remaining spaces
                let remaining = String(noSpaces.suffix(from: index8))
                return formattedString + remaining
            }

            let index12 = noSpaces.index(startIndex, offsetBy: 12)
            let followingFour = String(noSpaces[index8..<index12])
            let remaining = String(noSpaces.suffix(from: index12))
            return formattedString + followingFour + " " + remaining
        }
    }
}
