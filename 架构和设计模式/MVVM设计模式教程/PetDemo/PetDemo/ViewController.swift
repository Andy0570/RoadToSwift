//
//  ViewController.swift
//  PetDemo
//
//  Created by Qilin Hu on 2020/12/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Example
        // 1 Model
        let birthday = Date(timeIntervalSinceNow: (-2 * 86400 * 366))
        let image = UIImage(named: "stuart")!
        let stuart = Pet(name: "Stuart",
                         birthday: birthday,
                         rarity: .veryRare,
                         image: image)
        
        // 2 View Model
        let viewModel = PetViewModel(pet: stuart)
        
        // 3 View
        let frame = CGRect(x: 40, y: 80, width: 300, height: 420)
        let view = PetView(frame: frame)
        
        // 4 通过 View Model 配置 View 视图的内容
//        view.nameLabel.text = viewModel.name
//        view.imageView.image = viewModel.image
//        view.ageLabel.text = viewModel.ageText
//        view.adoptionFeeLabel.text = viewModel.adoptionFeeText
        
        // 优化，通过扩展的方式配置视图
        // 将所有视图配置逻辑放到视图模型中
        viewModel.configure(view)
        
        // 5
        self.view.addSubview(view)
    }
}

