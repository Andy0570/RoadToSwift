//
//  ViewController.swift
//  Project8
//
//  Created by Qilin Hu on 2021/12/28.
//

import UIKit

// 编写代码时，要考虑到最终维护你的代码的人可能是一个具有暴力倾向的精神病患者，而且他还知道你住在哪里。—— John Woods
// 言下之意是说：你编写的代码要条理清晰、易读、并遵循各种规范和最佳实践，否则未来维护你代码的人看了你糟糕混乱的代码，真的会想杀了你的！
class ViewController: UIViewController {

    // 线索标签
    var cluesLabel: UILabel!
    // 答案标签
    var answerLabel: UILabel!
    // 当前答案
    var currentAnswer: UITextField!
    // 玩家分数
    var scoreLabel: UILabel!
    // 显示所有单词的按钮
    var letterButtons = [UIButton]()
    
    // 该数组用于存储当前用于拼写答案的按钮
    var activatedButtons = [UIButton]()
    // 该数组用于存储所有可能的解决方案
    var solutions = [String]()
    
    // 玩家当前分数
    var score = 0
    // 玩家当前等级
    var level = 1
    
    
    // MARK: View Life Cycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUSE"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.text = "ANSWERS"
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .right
        view.addSubview(answerLabel)
        
        // 降低这两个标签的内容抗拉伸优先级
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            // scoreLabel.top = view.top
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            // scoreLabel.right = view.right
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // cluesLabel.top = scoreLabel.bottom
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // cluesLabel.left = view.left + 100
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            // cluesLabel.width = view.width * 0.6 - 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            // answerLabel.top = scoreLabel.bottom
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // answerLabel.right = view.right - 100
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            // answerLabel.width = view.width * 0.4 - 100
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // answerLabel.height = cluesLabel.height
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            // currentAnswer.centerX = view.centerX
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // currentAnswer.width = view.width * 0.5
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            // currentAnswer.top = cluesLabel.bottom + 20
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            // submit.top = currentAnswer.bottom
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            // submit.centerX = view.centerX - 100
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            // submit.height = 44
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            // clear.centerX = view.centerX + 100
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            // clear.centerY = submit.centerY
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            // clear.height = 44
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            // buttonsView.size = 750 * 320
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            // buttonsView.centerX = view.centerX
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // buttonsView.top = submit.bottom + 20
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            // buttonsView.bottom = view.bottom - 20
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])
        
        // MARK: 通过绝对值坐标方式布局按钮数组
        let width = 150
        let height = 80
        
        // 在 4x5 的方格内创建 20 个按钮
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                // 计算各按钮 frame
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }


    // MARK: - Actions
    
    // 点击任何字母按钮 Action
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {
            return
        }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    // 提交按钮 Action
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    // 清除按钮 Action
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    // MARK: - Private
    
    func loadLevel() {
        // 存储所有关卡的线索
        var clueString = ""
        // 存储每个答案是多少个字母
        var solutionString = ""
        // 存储所有字母组：HA、UNT、ED，
        var letterBits = [String]()
        
        // 加载 Bundle 资源包中的 level1.txt 文件
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                // 按行切分数据，存入数组
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle() // 数组洗牌
                
                for (index, line) in lines.enumerated() {
                    // 按 ": " 切分每一行数据，左边是答案，右边是线索
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    // 线索字符串，每条线索按 \n 换行
                    clueString += "\(index + 1). \(clue)\n"
                    
                    // 提示字符串，描述这个单词有几个字符，也是按 \n 换行
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    // 单词碎片
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // 删除字符串首尾指定字符，修剪空格、制表符和换行符
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
}

