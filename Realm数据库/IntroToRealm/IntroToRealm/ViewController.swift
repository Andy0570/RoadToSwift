//
//  ViewController.swift
//  IntroToRealm
//
//  Created by Josh R on 5/2/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    // 创建一个默认的本地 Realm 数据库
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 打印 Realm 数据库文件路径
        print(realm.configuration.fileURL ?? "Realm URL not found.")
        
        //MARK: Create test data -- these methods check to see if data has already been created
        createCustomersAndBranchManager()
        createBank()
        
        
        //MARK: Retrieve all customers, branch manager, and bank
        let allCustomers = realm.objects(Customer.self)
        let branchManager = realm.objects(BranchManager.self).first!
        let usBank = realm.objects(Bank.self).first!
        

        //MARK: Change an objects value，检索到对象后，直接在写事务中修改对象
        try! realm.write {
            branchManager.lastName = "Miller"
        }
        
        print("Lauren's new last name is \(branchManager.lastName)")
        
        
        //MARK: Add relationships method call
        createRelationships()

        // 从反向关系中检索客户的银行
        //MARK: Retrieving the customer's bank from the Customer class
        let firstCustomersBank  = allCustomers.first!.bank.first!
        print("The first customer's bank is: \(firstCustomersBank.name)")
        
        // 使用 .filter 高阶函数过滤 Realm 集合
        //MARK: Filtering allCustomers to find all customers where their first name is Jon
        let jonCustomer = allCustomers.filter({ $0.firstName == "Jon" })
        print(jonCustomer.first!.fullName)
    }

    // 创建银行经理和客户
    private func createCustomersAndBranchManager() {
        let customers = realm.objects(Customer.self)
        let branchManagers = realm.objects(BranchManager.self)
        
        //Check to see if the test data exists.  If it does, not create additional.
        if customers.count == 0 && branchManagers.count == 0 {
            // !!!: 任何时候你想创建一个新对象或改变一个现有对象，你都必须在一个 Realm write 事务中执行。
            // !!!: 在生产环境中，你应该将 write 事务包装在一个 do-catch 块中以捕获任何潜在的错误！
            try! realm.write {
                let customer1 = Customer()
                customer1.firstName = "Jon"
                customer1.lastName = "Smith"
                customer1.currentBalance = 1234.12
                
                let customer2 = Customer()
                customer2.firstName = "Susan"
                customer2.lastName = "Alexander"
                customer2.currentBalance = 54321.10
                
                let branchManager = BranchManager()
                branchManager.firstName = "Lauren"
                branchManager.lastName = "Scott"
                
                realm.add([customer1, customer2, branchManager])
            }
        }
    }

    // 创建银行
    private func createBank() {
        let banks = realm.objects(Bank.self)
        
        //Check to see if the test data exists, if not, create one
        if banks.count == 0 {
            try! realm.write {
                let usBank = Bank()
                usBank.name = "US Bank"
                usBank.latitude = 44.9778
                usBank.longitude = 93.2650
                usBank.type = Bank.BankType.retailBank.rawValue
                
                realm.add(usBank)
            }
        }
    }

    // 添加关系
    private func createRelationships() {
        let allCustomers = realm.objects(Customer.self)
        let branchManager = realm.objects(BranchManager.self).first!
        let usBank = realm.objects(Bank.self).first!

        // 在银行和分行经理之间建立关系，然后在银行和客户之间建立关系
        // Check to see if relationships already exists, if not, create them.
        if usBank.branchManager == nil && usBank.customers.count == 0 {
            try! realm.write {
                usBank.branchManager = branchManager
                
                for customer in allCustomers {
                    usBank.customers.append(customer)
                }
            }
        }
    }
    
}

