//
//  JSON+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

/**
 JSON 字符串解析
 
 Usage:
 let dict: [String: Any] = [
   "name": "John",
   "surname": "Doe",
   "age": 31
 ]
 print(dict)
 // ["surname": "Doe", "name": "John", "age": 31]
 let json = String(json: dict)
 print(json)
 // Optional("{\"surname\":\"Doe\",\"name\":\"John\",\"age\":31}")

 let restoredDict = json?.jsonToDictionary()
 print(restoredDict)
 // Optional(["name": John, "surname": Doe, "age": 31])
 */
extension String {
    init?(json: Any) {
        guard let data = Data(json: json) else { return nil }
        self.init(decoding: data, as: UTF8.self)
    }
    
    func jsonToDictionary() -> [String: Any]? {
        self.data(using: .utf8)?.jsonToDictionary()
    }
    
    func jsonToArray() -> [Any]? {
        self.data(using: .utf8)?.jsonToArray()
    }
}

extension Data {
    init?(json: Any) {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) else { return nil }
        self.init(data)
    }
    
    func jsonToDictionary() -> [String: Any]? {
        (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? [String: Any]
    }
    
    func jsonToArray() -> [Any]? {
        (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? [Any]
    }
}
