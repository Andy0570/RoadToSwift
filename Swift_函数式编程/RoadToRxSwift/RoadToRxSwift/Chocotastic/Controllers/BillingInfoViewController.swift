//
//  BillingInfoViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import UIKit
import RxSwift
import RxCocoa

/// 信息卡输入表单
/// 测试信用卡 4111 1111 1111 1111，11/2025，123
final class BillingInfoViewController: UIViewController {

    // MARK: Properties

    private let cardType: BehaviorRelay<CardType> = BehaviorRelay(value: .unknown)
    private let disposeBag: DisposeBag = DisposeBag()

    // 💡 节流是 RxSwift 中的特色功能，因为当某些事情发生变化时，通常会有相当多的逻辑要运行。在这种情况下，小油门是值得的。
    // 每隔 100 毫秒读取一次变化
    private let throttleIntervalInMilliseconds = 100

    // MARK: - Controls

    /// 垂直布局的堆栈视图
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    /// 水平布局的堆栈视图
    private lazy var topHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    private lazy var creditCardNumberTextField: ValidatingTextField = {
        let textField = ValidatingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Card Number"
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.black
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let creditCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "unknownCard")
        return imageView
    }()

    /// 水平布局的堆栈视图
    private lazy var bottomHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    private lazy var expirationDateTextField: ValidatingTextField = {
        let textField = ValidatingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Exp."
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.black
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var cvvTextField: ValidatingTextField = {
        let textField = ValidatingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "CVV"
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.black
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Buy Chocolate!", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.backgroundColor = UIColor.brown
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "💳 Info"
        view.backgroundColor = UIColor.systemBackground
        setupSubview()
        setupCardImageDisplay()
        setupTextChangeHandling()

        purchaseButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.navigationController?.pushViewController(ChocolateIsComingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSubview() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(topHorizontalStackView)
        stackView.addArrangedSubview(bottomHorizontalStackView)
        stackView.addArrangedSubview(purchaseButton)

        topHorizontalStackView.addArrangedSubview(creditCardNumberTextField)
        topHorizontalStackView.addArrangedSubview(creditCardImageView)

        bottomHorizontalStackView.addArrangedSubview(expirationDateTextField)
        bottomHorizontalStackView.addArrangedSubview(cvvTextField)

        creditCardNumberTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        expirationDateTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            topHorizontalStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            topHorizontalStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomHorizontalStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bottomHorizontalStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            purchaseButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            purchaseButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            creditCardImageView.widthAnchor.constraint(equalToConstant: 48),
            creditCardImageView.heightAnchor.constraint(equalToConstant: 30),

            cvvTextField.widthAnchor.constraint(equalTo: expirationDateTextField.widthAnchor, multiplier: 0.5)
        ])
    }

    private func setupCardImageDisplay() {
        // 根据信用卡类型更新卡片图片样式
        // 将 BehaviorRelay<CardType> 转换为可观察序列，通过观察者订阅它并实时更新 UI。
        cardType.asObservable()
            .subscribe(onNext: { [unowned self] cardType in
                self.creditCardImageView.image = cardType.image
            })
            .disposed(by: disposeBag)
    }

    private func setupTextChangeHandling() {
        // ----------------------------------
        // 校验信用卡号码
        let creditCardValid = creditCardNumberTextField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validate(cardText: $0)
            }

        // 订阅 Observable 值
        creditCardValid.subscribe(onNext: { [unowned self] in
            self.creditCardNumberTextField.valid = $0
        })
        .disposed(by: disposeBag)

        // ----------------------------------
        // 信用卡有效期
        let expirationValid = expirationDateTextField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validate(expirationDateText: $0)
            }

        expirationValid.subscribe(onNext: { [unowned self] in
            self.expirationDateTextField.valid = $0
        })
        .disposed(by: disposeBag)

        // ----------------------------------
        // 信用卡校验码
        let cvvValid = cvvTextField.rx.text
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validate(cvvText: $0)
            }

        cvvValid.subscribe(onNext: { [unowned self] in
            self.cvvTextField.valid = $0
        })
        .disposed(by: disposeBag)

        // ----------------------------------
        let everythingValid = Observable.combineLatest(creditCardValid, expirationValid, cvvValid) {
            $0 && $1 && $2 // All must be true
        }
        everythingValid.bind(to: purchaseButton.rx.isEnabled).disposed(by: disposeBag)
    }

}

// MARK: - Validation methods

extension BillingInfoViewController {
    // 通过输入卡号校验信用卡是否合法有效
    func validate(cardText: String?) -> Bool {
        guard let cardText else {
            return false
        }

        let noWhitespace = cardText.removingSpaces

        updateCardType(using: noWhitespace)
        formatCardNumber(using: noWhitespace)
        advanceIfNecessary(noSpacesCardNumber: noWhitespace)

        guard cardType.value != .unknown else {
            //Definitely not valid if the type is unknown.
            return false
        }

        guard noWhitespace.isLuhnValid else {
            //Failed luhn validation
            return false
        }

        return noWhitespace.count == cardType.value.expectedDigits
    }

    func validate(expirationDateText expiration: String?) -> Bool {
        guard let expiration = expiration else {
            return false
        }
        let strippedSlashExpiration = expiration.removingSlash

        formatExpirationDate(using: strippedSlashExpiration)
        advanceIfNecessary(expirationNoSpacesOrSlash:  strippedSlashExpiration)

        return strippedSlashExpiration.isExpirationDateValid
    }

    func validate(cvvText cvv: String?) -> Bool {
        guard let cvv = cvv else {
            return false
        }
        guard cvv.areAllCharactersNumbers else {
            //Someone snuck a letter in here.
            return false
        }
        dismissIfNecessary(cvv: cvv)
        return cvv.count == cardType.value.cvvDigits
    }
}

// MARK: Single-serve helper functions

private extension BillingInfoViewController {
    func updateCardType(using noSpacesNumber: String) {
        cardType.accept(CardType.fromString(string: noSpacesNumber))
    }

    func formatCardNumber(using noSpacesCardNumber: String) {
        creditCardNumberTextField.text = cardType.value.format(noSpaces: noSpacesCardNumber)
    }

    func advanceIfNecessary(noSpacesCardNumber: String) {
        if noSpacesCardNumber.count == cardType.value.expectedDigits {
            expirationDateTextField.becomeFirstResponder()
        }
    }

    func formatExpirationDate(using expirationNoSpacesOrSlash: String) {
        expirationDateTextField.text = expirationNoSpacesOrSlash.addingSlash
    }

    func advanceIfNecessary(expirationNoSpacesOrSlash: String) {
        if expirationNoSpacesOrSlash.count == 6 { //mmyyyy
            cvvTextField.becomeFirstResponder()
        }
    }

    func dismissIfNecessary(cvv: String) {
        if cvv.count == cardType.value.cvvDigits {
            let _ = cvvTextField.resignFirstResponder()
        }
    }
}


