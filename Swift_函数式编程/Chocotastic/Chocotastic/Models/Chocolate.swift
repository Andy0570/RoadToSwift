import Foundation

//MARK: - Mmmm...chocolate...
struct Chocolate: Equatable, Hashable {
    let priceInDollars: Float
    let countryName: String
    let countryFlagEmoji: String
    
    // An array of chocolate from europe
    static let ofEurope: [Chocolate] = {
        let belgian = Chocolate(priceInDollars: 8,
                                countryName: "Belgium",
                                countryFlagEmoji: "🇧🇪")
        let british = Chocolate(priceInDollars: 7,
                                countryName: "Great Britain",
                                countryFlagEmoji: "🇬🇧")
        let dutch = Chocolate(priceInDollars: 8,
                              countryName: "The Netherlands",
                              countryFlagEmoji: "🇳🇱")
        let german = Chocolate(priceInDollars: 7,
                               countryName: "Germany", countryFlagEmoji: "🇩🇪")
        let swiss = Chocolate(priceInDollars: 10,
                              countryName: "Switzerland",
                              countryFlagEmoji: "🇨🇭")
        
        return [belgian,
                british,
                dutch,
                german,
                swiss]
    }()
}
