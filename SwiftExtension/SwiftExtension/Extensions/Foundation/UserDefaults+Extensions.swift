//
//  UserDefaults+Extensions.swift
//  SwiftExtension
//
//  Created by Qilin Hu on 2020/11/18.
//

import Foundation

/**
 保存数据到 UserDefaults 偏好设置
 
 Usage:
 let age = 25
 age.store(key: "age")
 print(Int(key: "age")) // Optional(25)
 print(Float(key: "age")) // Optional(25.0)
 print(String(key: "age")) // Optional("25")
 print(String(key: "age1")) // nil

 let dict: [String: Any] = [
   "name": "John",
   "surname": "Doe",
   "occupation": "Swift developer",
   "experienceYears": 5,
   "age": 32
 ]
 dict.store(key: "employee")
 print(Dictionary(key: "employee"))
 // Optional(["name": John, "occupation": Swift developer, "age": 32, "experienceYears": 5, "surname": Doe])
 */
extension Int {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.integer(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}

extension Bool {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.bool(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}

extension Float {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.float(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}

extension Double {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.double(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}

extension Data {
    init?(key: String) {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        self.init(data)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}

extension String {
    init?(key: String) {
        guard let str = UserDefaults.standard.string(forKey: key) else { return nil }
        self.init(str)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}

extension Array where Element == Any {
    init?(key: String) {
        guard let array = UserDefaults.standard.array(forKey: key) else { return nil }
        self.init()
        self.append(contentsOf: array)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
    init?(key: String) {
        guard let dict = UserDefaults.standard.dictionary(forKey: key) else { return nil }
        self.init()
        self.merge(dict: dict)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        if #available(iOS 12.0, *) {
            return
        } else {
            UserDefaults.standard.synchronize()
        }
    }
}
