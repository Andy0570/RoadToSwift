//
//  Page.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

struct Page {
    let page: Int

    private init(page: Int) {
        self.page = page
    }
}

extension Page {
    static var first: Page {
        return Page(page: 1)
    }

    var next: Page {
        return Page(page: page + 1)
    }

    var isFirst: Bool {
        return page == 0
    }
}
