//
//  ViewController.swift
//  CoreTextMagazine
//
//  Created by Qilin Hu on 2024/1/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.将 zombie.txt 文件中的文本加载到 String 中
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }

        do {
            let text = try String(contentsOfFile: file, encoding: .utf8)
            // 2.创建一个新的解析器，输入文本，然后将返回的属性字符串传递给 ViewController 的 CTView。
            let parser = MarkupParser()
            parser.parseMarkup(text)
            //(view as? CTView)?.importAttrString(parser.attrString)
            (view as? CTView)?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)
        } catch _ {
        }
    }


}

