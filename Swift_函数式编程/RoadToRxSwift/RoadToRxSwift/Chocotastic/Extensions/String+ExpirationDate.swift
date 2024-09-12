//
//  String+ExpirationDate.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import Foundation

extension String {
    // 当字符数超过2个时，在年月之间添加斜杠线
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
    
    // 校验信用卡有效期
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
