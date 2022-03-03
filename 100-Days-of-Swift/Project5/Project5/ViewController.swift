//
//  ViewController.swift
//  Project5
//
//  Created by Qilin Hu on 2021/12/24.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // 1. 通过 Bundle 的 path(forResource:) 方法获取沙盒目录中的 start.txt 文件 URL 路径
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. 通过 String 的构造器方法加载文件数据到字符串中
            // Note：try? 表示调用这段代码，如果它抛出一个错误，就返回 nil
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. 将字符串按 \n 分割为数组
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // [weak self, weak ac] 在闭包的引用列表中声明弱引用，以解除强引用循环问题
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {
                return
            }
            
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    // 更新模型
                    usedWords.insert(answer, at: 0)
                    
                    // 更新列表视图
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognised"
                                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        }
        
        // 错误反馈
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        // 遍历输入的每个字符
        for letter in word {
            // 如果当前字符在标题中存在，就（从临时变量中）删除该字符
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        // UITextChecker 用于查找给定的字符串是否存在拼写错误
        let checker = UITextChecker()
        /**
         💡 word.utf16 是为了解决向后兼容性问题。
         
         在 Swift 语言中，String 字符串使用 unicode 编码作为字符集。也就是说，字母“é”会被精确存储为一个字符。
         而 UIKit 框架是在 Swift 语言之前使用 Objective-C 语言编写的，而它使用 UTF-16 字符编码。也就是说，
         字母“é”会被分开存储为2个字符。
         
         这个差别很微妙，也很少遇到。但由于 Emoji 表情符号的广泛使用，问题变得越来越棘手。因为在 Swift 看来，
         一个 Emoji 符号占1个字符，而 UTF-16 认为一个 Emoji 占2个字符。这意味着如果我们在 UIKit 方法中使
         用 count 方法计算字符串个数，会有误计字符串长度的风险。
         
         我意识到这似乎是毫无意义的额外负担，所以让我尝试给你一个简单的规则：当你与 UIKit、SpriteKit 或
         任何其他苹果框架一起工作时，使用 utf16.count 来计算字符数量。如果只是你自己的代码--即在字符上循环并
         单独处理每一个字符--那么就用 count 方法即可。
         */
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // NSNotFound 是一个特殊值，表示没有找到拼写错误的位置
        return misspelledRange.location == NSNotFound
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    
}

