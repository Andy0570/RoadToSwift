import Foundation

// 火箭组件
class RocketComponent {
    let model: String
    let serialNumber: String
    let reusable: Bool

    // 类方法
    static func decompose(identifier: String) -> (model: String, serialNumber: String)? {
        let identifierComponents = identifier.components(separatedBy: "-")
        guard identifierComponents.count == 2 else {
            return nil
        }

        return (model: identifierComponents[0], serialNumber: identifierComponents[1])
    }

    // 指定初始化方法
    // Init #1a - Designated
    init(model: String, serialNumber: String, reusable: Bool) {
        self.model = model
        self.serialNumber = serialNumber
        self.reusable = reusable
    }

    // 便捷初始化方法
    // Init #1b - Convenience
    convenience init(model: String, serialNumber: String) {
        self.init(model: model, serialNumber: serialNumber, reusable: false)
    }

    // 可失败的指定初始化方法
    // Init #1c - Convenience
//    convenience init?(identifier: String, reusable: Bool) {
//        let identifierComponents = identifier.components(separatedBy: "-")
//        guard identifierComponents.count == 2 else {
//            return nil
//        }
//
//        self.init(model: identifierComponents[0], serialNumber: identifierComponents[1],
//                  reusable: reusable)
//    }

    // 可失败的指定初始化方法
    // Init #1c - Convenience
    convenience init?(identifier: String, reusable: Bool) {
        // 重复代码使用类方法优化
        guard let (model, serialNumber) = RocketComponent.decompose(identifier: identifier) else {
            return nil
        }

        self.init(model: model, serialNumber: serialNumber, reusable: reusable)
    }
}

// 指定初始化器
let payload = RocketComponent(model: "RT-1", serialNumber: "234", reusable: false)
// 便捷初始化器
let fairing = RocketComponent(model: "Serpent", serialNumber: "0")
// 可失败初始化器
let component = RocketComponent(identifier: "R2-D21", reusable: true)
let nocomponent = RocketComponent(identifier: "", reusable: true)


class Tank: RocketComponent {
    var encasingMaterial: String

    // 子类的指定初始化方法，内部调用父类的指定初始化方法
    // Init #2a - Designated
    init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
        self.encasingMaterial = encasingMaterial
        super.init(model: model, serialNumber: serialNumber, reusable: reusable)
    }

    // 重写父类的指定初始化方法，内部调用父类的指定初始化方法
    // Init #2b - Designated
    override init(model: String, serialNumber: String, reusable: Bool) {
        self.encasingMaterial = "Aluminum"
        super.init(model: model, serialNumber: serialNumber, reusable: reusable)
    }
}

// 如果子类自己实现了指定初始化方法，系统就不会默认继承父类的指定初始化方法和便捷初始化方法。
// 这时，如果子类还想继续使用父类的指定初始化方法，就必须在子类中重写父类的指定初始化方法
let fuelTank = Tank(model: "Athena", serialNumber:"003", reusable: true)
// 当你把父类所有的指定初始化方法都重写后，你也就自动继承了父类所有的便捷初始化方法了。
let liquidOxygenTank = Tank(identifier: "LOX-012", reusable: true)


class LiquidTank: Tank {
    let liquidType: String
    
    // Init #3a - Designated
    init(model: String, serialNumber: String, reusable: Bool,
         encasingMaterial: String, liquidType: String) {
        self.liquidType = liquidType
        super.init(model: model, serialNumber: serialNumber, reusable: reusable,
                   encasingMaterial: encasingMaterial)
    }

    // Init #3b - Convenience
    convenience init(model: String, serialNumberInt: Int, reusable: Bool,
                     encasingMaterial: String, liquidType: String) {
        let serialNumber = String(serialNumberInt)
        self.init(model: model, serialNumber: serialNumber, reusable: reusable,
                  encasingMaterial: encasingMaterial, liquidType: liquidType)
    }

    // Init #3c - Convenience
    convenience init(model: String, serialNumberInt: Int, reusable: Int,
                     encasingMaterial: String, liquidType: String) {
        let reusable = reusable > 0
        self.init(model: model, serialNumberInt: serialNumberInt, reusable: reusable,
                  encasingMaterial: encasingMaterial, liquidType: liquidType)
    }

//    // 重写父类的指定初始化方法，内部调用父类的指定初始化方法
//    // Init #3d - Designated
//    override init(model: String, serialNumber: String, reusable: Bool) {
//        self.liquidType = "LOX"
//        super.init(model: model, serialNumber: serialNumber,
//                   reusable: reusable, encasingMaterial: "Aluminum")
//    }
//
//    // 重写父类的指定初始化方法，内部调用父类的指定初始化方法
//    // Init #3e - Designated
//    override init(model: String, serialNumber: String, reusable: Bool,
//                  encasingMaterial: String) {
//        self.liquidType = "LOX"
//        super.init(model: model, serialNumber: serialNumber, reusable:
//                    reusable, encasingMaterial: encasingMaterial)
//    }

    // 重写父类的指定初始化方法，并将其设置为便捷初始化方法，内部调用本类的指定初始化方法
    // Init #3d - Convenience
    convenience override init(model: String, serialNumber: String, reusable: Bool) {
        self.init(model: model, serialNumber: serialNumber, reusable: reusable,
                  encasingMaterial: "Aluminum", liquidType: "LOX")
    }

    // 重写父类的指定初始化方法，并将其设置为便捷初始化方法，内部调用本类的指定初始化方法
    // Init #3e - Convenience
    convenience override init(model: String, serialNumber: String, reusable: Bool,
                              encasingMaterial: String) {
        self.init(model: model, serialNumber: serialNumber,
                  reusable: reusable, encasingMaterial: encasingMaterial, liquidType: "LOX")
    }

    // 可失败的便捷初始化方法，调用自身的指定初始化方法
    // Init #3f - Convenience
//    convenience init?(identifier: String, reusable: Bool, encasingMaterial: String,
//                      liquidType: String) {
//        let identifierComponents = identifier.components(separatedBy: "-")
//        guard identifierComponents.count == 2 else {
//            return nil
//        }
//
//        self.init(model: identifierComponents[0], serialNumber: identifierComponents[1],
//                  reusable: reusable, encasingMaterial: encasingMaterial, liquidType: liquidType)
//    }

    // 可失败的便捷初始化方法，调用自身的指定初始化方法
    // Init #3f - Convenience
    convenience init?(identifier: String, reusable: Bool, encasingMaterial: String,
                      liquidType: String) {
        // 重复代码使用类方法优化
        guard let (model, serialNumber) = RocketComponent.decompose(identifier: identifier) else {
            return nil
        }
        
        self.init(model: model, serialNumber: serialNumber, reusable: reusable, encasingMaterial: encasingMaterial, liquidType: liquidType)
    }
}


let rp1Tank = LiquidTank(model: "Hermes", serialNumberInt: 5, reusable: 1, encasingMaterial: "Aluminum", liquidType: "LOX")
// LiquidTank 重写了父类所有的指定初始化方法，它也就自动获得了父类的所有便捷初始化方法。
let loxTank = LiquidTank(identifier: "LOX-1", reusable: true)
// 可失败的便捷初始化方法
let athenaFuelTank = LiquidTank(identifier: "Athena-9", reusable: true,
  encasingMaterial: "Aluminum", liquidType: "RP-1")
