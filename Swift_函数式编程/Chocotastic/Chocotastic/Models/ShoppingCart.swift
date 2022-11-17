import RxSwift
import RxCocoa

// ShoppingCart 是一个管理购物车选中商品的单例
class ShoppingCart {
    static let sharedCart = ShoppingCart()
    var chocolates: BehaviorRelay<[Chocolate]> = BehaviorRelay(value: [])
}

//MARK: Non-Mutating Functions

extension ShoppingCart {
    var totalCost: Float {
        // 💡 通过 value 属性访问 BehaviorRelay<[Chocolate]> 包含的内容
        return chocolates.value.reduce(0) { runningTotal, chocolate in
            return runningTotal + chocolate.priceInDollars
        }
    }

    var itemCountString: String {
        guard chocolates.value.count > 0 else {
            return "🚫🍫"
        }

        //Unique the chocolates
        let setOfChocolates = Set<Chocolate>(chocolates.value)

        //Check how many of each exists
        let itemStrings: [String] = setOfChocolates.map { chocolate in

            let count: Int = chocolates.value.reduce(0) { runningTotal, reduceChocolate in
                if chocolate == reduceChocolate {
                    return runningTotal + 1
                }
                return runningTotal
            }

            return "\(chocolate.countryFlagEmoji)🍫: \(count)"
        }

        return itemStrings.joined(separator: "\n")
    }
}
