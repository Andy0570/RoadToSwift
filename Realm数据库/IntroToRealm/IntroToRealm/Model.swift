//
//  Model.swift
//  IntroToRealm
//
//  Created by Josh R on 5/2/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

// 银行
class Bank: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    // !!!: 一对一关系，每家银行都有一名银行经理
    @objc dynamic var branchManager: BranchManager?
    // !!!: 一对多关系，每家银行都可以有很多客户
    let customers = List<Customer>()  //one-to-many
    @objc dynamic var type: BankType.RawValue = ""  //realm recognizes this as a string
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    //Primary key method provided by Realm
    override static func primaryKey() -> String? {
        return "id"
    }

    // CLLocation 计算属性将被 Realm 忽略
    // Computed properties are not persisted and ignored by realm
    var bankLocation: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }

    // 银行可以是信用合作社、中央银行或零售银行。
    // Realm 将忽略嵌套枚举
    // Enums are not persisted and ignored by realm
    enum BankType: String {
        case creditUnion = "Credit Union"
        case centralBank = "Central Bank"
        case retailBank = "Retail Bank"
    }
}

// 银行经理
class BranchManager: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 你可以使用 Realm 特定的 LinkObjects 结构体创建逆向关系。
    let bank = LinkingObjects(fromType: Bank.self, property: "branchManager")
}

// 客户
class Customer: Object {
    @objc dynamic var accountNumber = UUID().uuidString
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var startingBalance: Double = 0.0
    @objc dynamic var currentBalance: Double = 0.0
    @objc dynamic var dateJoined = Date()
    
    //Computed properties are not persisted and ignored by realm
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }

    // 你可以使用 Realm 特定的 LinkObjects 结构体创建逆向关系。比如：找到每个客户所属的银行
    let bank = LinkingObjects(fromType: Bank.self, property: "customers")

    override static func primaryKey() -> String? {
        return "accountNumber"
    }
}
