//
//  LabelViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/24.
//

import UIKit
import RxSwift
import RxCocoa

/**
 RxCocoa 中 UI 控件的使用：

 UILabel: <https://www.hangge.com/blog/cache/detail_1963.html>
 UITextField: <https://www.hangge.com/blog/cache/detail_1964.html>
 UIButton: <https://www.hangge.com/blog/cache/detail_1969.html>
 UISwitch、UISegmentedControl: <https://www.hangge.com/blog/cache/detail_1970.html>
 UIActivityIndicatorView、UIApplication: <https://www.hangge.com/blog/cache/detail_1971.html>
 UISlider、UIStepper: <https://www.hangge.com/blog/cache/detail_1972.html>
 UIDatePicker: <https://www.hangge.com/blog/cache/detail_1973.html>
 UIPickerView: <https://www.hangge.com/blog/cache/detail_1983.html>
 UITableView: <https://www.hangge.com/blog/cache/detail_1976.html>
 UITableView 的使用 4：表格数据的搜索过滤: <https://www.hangge.com/blog/cache/detail_1994.html>
 UITableView 的使用 6：不同类型的单元格混用: <https://www.hangge.com/blog/cache/detail_1996.html>
 RxDataSources: <https://www.hangge.com/blog/cache/detail_1982.html>
 UICollectionView 的使用 1：基本用法: <https://www.hangge.com/blog/cache/detail_2004.html>
 */
class LabelViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        bindDataToText()
        bindDataToAttributedText()
    }

    // 将数据绑定到 UILabel 的 text 属性
    func bindDataToText() {
        // 创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:200, width:300, height:100))
        view.addSubview(label)

        // 创建一个计时器（每0.1秒发送一个索引数）
        let timer = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.instance)

        // 将已过去的时间格式化成想要的字符串，并绑定到label上
        timer.map{ String(format: "%0.2d:%0.2d.%0.1d",
                          arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]) }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }

    // 将数据绑定到 UILabel 的 attributedText 属性
    func bindDataToAttributedText() {
        // 创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:400, width:300, height:100))
        self.view.addSubview(label)

        // 创建一个计时器（每0.1秒发送一个索引数）
        let timer = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.instance)

        // 将已过去的时间格式化成想要的字符串，并绑定到label上
        timer.map(formatTimeInterval)
            .bind(to: label.rx.attributedText)
            .disposed(by: disposeBag)
    }

    //将数字转成对应的富文本
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                         arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        // 富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        // 从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        // 设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        // 设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
}
