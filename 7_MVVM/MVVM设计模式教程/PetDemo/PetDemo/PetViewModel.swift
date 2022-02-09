//
//  PetView.swift
//  PetDemo
//
//  Created by Qilin Hu on 2020/12/16.
//

import Foundation
import UIKit

// MARK: - ViewModel
public class PetViewModel {
    
    // 1 创建两个属性，并在初始化方法中设值
    private let pet: Pet
    private let calendar: Calendar
    
    public init(pet: Pet) {
        self.pet = pet
        self.calendar = Calendar(identifier: .gregorian)
    }
    
    // 2 声明 name 和 image 为计算属性
    public var name: String {
        return pet.name
    }
    
    public var image: UIImage {
        return pet.image
    }
    
    // 3 计算属性转换后，将可以使用显示
    public var ageText: String {
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.brithday)
        let components = calendar.dateComponents([.year], from: birthday, to: today)
        
        let age = components.year!
        return "\(age) years old"
    }
    
    // 4 根据 rarity 决定价格
    public var adoptionFeeText: String {
        switch pet.rarity {
        case .common:
            return "$50.00"
        case .uncommon:
            return "$75.00"
        case .rare:
            return "$150.00"
        case .veryRare:
            return "$500.00"
        }
    }
}

// MARK: - 改进，通过扩展的方式配置视图
// 在 view model 中添加与视图配置相关的逻辑代码
extension PetViewModel {
    public func configure(_ view: PetView) {
        view.nameLabel.text = name
        view.imageView.image = image
        view.ageLabel.text = ageText
        view.adoptionFeeLabel.text = adoptionFeeText
    }
}
