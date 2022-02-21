//
//  ItemStore.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/16.
//

import Foundation

class ItemStore {

    func fetchItems(form jsonFile: String, complete: @escaping (_ sections: [Section])->() ) {
        DispatchQueue.global().async {
            // 加载Bundle包中的 json 文件，并使用 Codable 解析为 Item 数组
            let path = Bundle.main.path(forResource: jsonFile, ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let sections = try! decoder.decode([Section].self, from: data)

            DispatchQueue.main.async {
                complete(sections)
            }
        }
    }

}
