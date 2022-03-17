//
//  RecordingsResult.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import Foundation

struct RecordingsResult {
    let recordings: [Recording]?
    let error: Error?
    let currentPage: Int
    let pageCount: Int

    var hasMorePages: Bool {
        return currentPage < pageCount
    }

    var nextPage: Int {
        return hasMorePages ? currentPage + 1 : currentPage
    }
}
