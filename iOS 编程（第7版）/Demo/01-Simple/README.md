Quiz 的功能：在视图中显示一个问题，用户点击视图下方的按钮，可以显示相应的答案，用户点击上方的按钮，则会显示一个新的问题。



## 模型-视图-控制器（MVC）

模型-视图-控制器（MVC）设计模式的含义：**应用创建的任何一个对象，其类型必定是模型对象、视图对象或控制器对象三种类型的一种。**

* **模型对象**：负责存储数据，与用户界面无关。
* **视图对象**：是用户可以看见的对象，例如按钮、文本框、滑动条等。
* **控制器对象**：控制视图对象为用户呈现的内容，以及负责确保视图对象和模型对象的数据保持一致。

**模型对象**和**视图对象**之间没有直接产生联系，而是由**控制器对象**负责彼此之间的消息发送和数据传递。



## Interface Builder：可视化编辑器

Interface Builder 并不是把其他代码文件的内容以图像形式展现出来。
Interface Builder 是一个可以创建对象、维护对象属性的编辑器。



## 插座变量

通过**关联**（connection），一个对象可以知道另一个对象在内存中的位置，从而使这两个对象可以协同工作。

在 Interface Builder 中可以创建两种关联：「插座变量」和「动作」。
* **插座变量**：指向对象的指针。
* **动作**：一种方法。

## 源码

```swift
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
```