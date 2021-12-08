//
//  Item.swift
//  LootLogger
//
//  Created by Qilin Hu on 2021/11/13.
//

import UIKit

class Item: Equatable {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreate: Date
    
    // 指定初始化方法
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreate = Date()
    }
    
    // 便捷初始化方法
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            let randomAdjective = adjectives.randomElement()!
            let randomNouns = nouns.randomElement()!
            
            let randomName = "\(randomAdjective) \(randomNouns)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
    // MARK: - Equatable
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
            && lhs.serialNumber == rhs.serialNumber
            && lhs.valueInDollars == rhs.valueInDollars
            && lhs.dateCreate == rhs.dateCreate
    }
}
