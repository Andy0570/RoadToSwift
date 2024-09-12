//
//  CardType.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import UIKit

enum CardType {
    case unknown
    case amex // 美国运通卡
    case mastercard // MasterCart
    case visa // Visa 卡
    case discover // Discover 卡

    // 通过输入字符串判断信用卡类型
    // https://en.wikipedia.org/wiki/Payment_card_number
    static func fromString(string: String) -> CardType {
        // 如果字符串为空，则无法判断信用卡类型
        guard !string.isEmpty else {
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

    // 信用卡卡号的位数
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
