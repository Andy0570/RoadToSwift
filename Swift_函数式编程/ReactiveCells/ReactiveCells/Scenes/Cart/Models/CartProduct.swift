//
//  CartProduct.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit.UIImage

struct CartProduct {
    let id: String
    let title: String
    let description: String
    let price: Int
    let image: String
}

extension CartProduct: Equatable { }

extension CartProduct {
    var productImage: UIImage? {
        return UIImage(named: image)
    }
}

extension CartProduct {
    static var all: [CartProduct] {
        return [
            CartProduct(id: "1",
                    title: "Burger",
                    description: "A huge single burger with all the fixings, cheese, lettuce, tomato, onions and special sauce!",
                    price: 1000,
                    image: "burger"),
            CartProduct(id: "2",
                    title: "Bubble Tea",
                    description: "Delicious fruit tea infusion served iced cold. Delicious and ever-so-quirky drink and snack.",
                    price: 550,
                    image: "bubble_tea"),
            CartProduct(id: "3",
                    title: "Burrito",
                    description: "The name 'burrito' translates to 'little donkey' because the folded end of the tortilla looks like a donkey's ear!",
                    price: 799,
                    image: "burrito"),
            CartProduct(id: "4",
                    title: "Cake",
                    description: "Light sponge, silky milk chocolate buttercream and glossy dark chocolate ganache, this decadent cake is a chocolate lover's dream.",
                    price: 400,
                    image: "cake"),
            CartProduct(id: "5",
                    title: "Cereal",
                    description: "Wheat bran fibre is a Superior Fibre, which fuels a Happy Gut for a Healthy You.",
                    price: 390, image: "cereal"),
            CartProduct(id: "6",
                    title: "Chocolate",
                    description: "Deliciously creamy milk chocolate!",
                    price: 299,
                    image: "chocolate"),
            CartProduct(id: "7",
                    title: "Churros",
                    description: "A sweet Spanish snack consisting of a strip of fried dough dusted with sugar or cinnamon.",
                    price: 495,
                    image: "churros"),
            CartProduct(id: "8",
                    title: "Coconut Water",
                    description: "Naturally refreshing and sweet with a nutty taste. Easily digested carbohydrates in the form of sugar and electrolytes.",
                    price: 300,
                    image: "coconut_water"),
            CartProduct(id: "9",
                    title: "Donut",
                    description: "Fried and dredged in sugar...say no more!",
                    price: 200,
                    image: "donut"),
            CartProduct(id: "10",
                    title: "Green Tea",
                    description: "Minimally oxidized and non-fermented refreshing tea.",
                    price: 250,
                    image: "green_tea")
        ]
    }
    
    static func random() -> CartProduct {
        all.randomElement()!
    }
}
