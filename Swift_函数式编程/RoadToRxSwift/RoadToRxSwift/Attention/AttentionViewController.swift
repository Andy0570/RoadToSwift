//
//  AttentionViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class AttentionViewController: UIViewController {

    let viewModel = AttentionViewModel()
    private let disposeBag: DisposeBag = DisposeBag()

    private lazy var attentionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        let size = CGSize(width: 60, height: 25)
        button.setTitle("+关注", for: .normal)
        button.setTitle("已关注", for: .selected)
        button.backgroundColor = UIColor.gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(attentionButton)
        NSLayoutConstraint.activate([
            attentionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attentionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            attentionButton.widthAnchor.constraint(equalToConstant: 120),
            attentionButton.heightAnchor.constraint(equalToConstant: 80)
        ])

        bindToViewModel()
    }

    private func bindToViewModel() {
        /**
         * button.rx.tap -> ViewModel.transform -> button.rx.isisSelected
         * 
         * 把按钮的点击事件传递到 ViewModel 的 Input 中；
         * ViewModel 内部通过 transform 函数，对 input 中的事件进行处理；
         * 把 ViewModel 中的 Output 和按钮的状态（attentionButton.rx.isSelected）绑定在一起
         */
        let output = viewModel.transform(input: AttentionViewModel.Input(attention: attentionButton.rx.tap))

        output.attentionStatus.bind(to: attentionButton.rx.isSelected).disposed(by: disposeBag)
    }
}
