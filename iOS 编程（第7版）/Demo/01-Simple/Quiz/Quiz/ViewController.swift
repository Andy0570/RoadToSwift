//
//  ViewController.swift
//  Quiz
//
//  Created by Qilin Hu on 2020/11/5.
//

import UIKit

class ViewController: UIViewController {
    
    // 声明插座变量：指向对象的指针
    // @IBOutlet 关键字，告诉 Xcode，之后会使用 Interface Builder 关联插座变量。
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    // 创建模型对象
    // 常量使用 let 关键字定义，不能被修改
    let questions: [String] = [
        "What is 7+7?",
        "What is the capital of Vermont",
        "What is cognac made from"
    ]
    let answers: [String] = [
        "14",
        "Montepelier",
        "Grapes"
    ]
    // 变量使用 var 关键字定义，它的值可以被修改
    var currentQuestionIndex: Int = 0
    
    // 重载 ViewController 对象的 viewDidLoad() 方法。
    // 重载：为一个方法提供自定义的实现。
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
        answerLabel.text = "???"
    }
    
    // 声明并实现动作方法
    // 点击 UIButton 对象时，该按钮可以调用某个对象的某个方法
    // 被调用的对象：目标（targer）
    // 被调用的方法：动作（action）
    // @IBAction 关键字，告诉 Xcode，之后会使用 Interface Builder 关联该动作。
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer;
    }
}

