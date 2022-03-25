//
//  Date+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/25.
//

import Foundation

/**
 Date <-> String

 let strDate = "2020-08-10 15:00:00"
 let date = strDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
 let strDate2 = date?.toString(format: "yyyy-MM-dd HH:mm:ss")
 */
extension String {
    // MARK: String -> Date
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension Date {
    // MARK: Date -> String
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
