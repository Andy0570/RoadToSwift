//
//  Date+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

/**
 Usage:
 
 let strDate = "2020-08-10 15:00:00"
 let date = strDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
 let strDate2 = date?.toString(format: "yyyy-MM-dd HH:mm:ss")
 */
extension String {
    // MARK: String -> Date
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)
    }
}

extension Date {
    // MARK: Date -> String
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}
