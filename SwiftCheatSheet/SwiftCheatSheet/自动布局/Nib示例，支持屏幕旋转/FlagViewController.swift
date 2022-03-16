//
//  FlagViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/3.
//

/**
 参考：<https://www.hackingwithswift.com/100/19>
 */
import UIKit

class FlagViewController: UIViewController {
    // @IBOutlet 用于将代码连接到 storyboard 布局
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!

    var countries: [String] = []
    var correntAnswer = 0
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        // 洗牌，对数组中的元素进行随机重新排序
        countries.shuffle()

        // 更新按钮图片，显示随机旗帜
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        // 随机选择一个数值索引，作为正确答案
        correntAnswer = Int.random(in: 0...2)
        // 将正确答案文本的大些字母显示为导航栏标题
        title = countries[correntAnswer].uppercased()
    }

    // @IBAction 是使 storyboard 布局触发代码的一种方式
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String

        // 1.检查答案是否正确；2.更新玩家的分数
        if sender.tag == correntAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }

        // 3.显示玩家当前得分
        let alertController = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion(action:)))
        present(alertController, animated: true, completion: nil)
    }
}
