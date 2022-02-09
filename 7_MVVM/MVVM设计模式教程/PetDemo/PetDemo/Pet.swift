//
//  Pet.swift
//  PetDemo
//
//  Created by Qilin Hu on 2020/12/16.
//

import Foundation
import UIKit

// MARK: - Model
public class Pet {
    public enum Rarity {
        case common
        case uncommon
        case rare
        case veryRare
    }
    
    public let name: String
    public let brithday: Date
    public let rarity: Rarity
    public let image: UIImage
    
    public init(name: String, birthday: Date, rarity: Rarity, image: UIImage) {
        self.name = name
        self.brithday = birthday
        self.rarity = rarity
        self.image = image
    }
}
