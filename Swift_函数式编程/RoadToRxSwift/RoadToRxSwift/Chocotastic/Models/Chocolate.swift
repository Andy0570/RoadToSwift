//
//  Chocolate.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import Foundation

struct Chocolate: Equatable, Hashable {
    let priceInDollars: Float
    let countryName: String
    let countryFlagEmoji: String

    // An array of chocolate from europe
    static let ofEurope: [Chocolate] = {
        let belgian = Chocolate(priceInDollars: 8, countryName: "比利时", countryFlagEmoji: "🇧🇪")
        let british = Chocolate(priceInDollars: 7, countryName: "英国", countryFlagEmoji: "🇬🇧")
        let dutch = Chocolate(priceInDollars: 8, countryName: "荷兰", countryFlagEmoji: "🇳🇱")
        let german = Chocolate(priceInDollars: 7, countryName: "德国", countryFlagEmoji: "🇩🇪")
        let swiss = Chocolate(priceInDollars: 10, countryName: "瑞士", countryFlagEmoji: "🇨🇭")

        return [belgian, british, dutch, german, swiss]
    }()
}
