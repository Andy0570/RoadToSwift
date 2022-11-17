import RxSwift
import RxCocoa

class BillingInfoViewController: UIViewController {
    @IBOutlet private var creditCardNumberTextField: ValidatingTextField!
    @IBOutlet private var creditCardImageView: UIImageView!
    @IBOutlet private var expirationDateTextField: ValidatingTextField!
    @IBOutlet private var cvvTextField: ValidatingTextField!
    @IBOutlet private var purchaseButton: UIButton!
    
    private let cardType: BehaviorRelay<CardType> = BehaviorRelay(value: .unknown)
    private let disposeBag = DisposeBag()
    // 💡 节流是 RxSwift 中的特色功能，因为当某些事情发生变化时，通常会有相当多的逻辑要运行。在这种情况下，小油门是值得的。
    // 每隔 100 毫秒读取一次变化
    private let throttleIntervalInMilliseconds = 100
}

// MARK: - View Lifecycle'
extension BillingInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "💳 Info"
        
        setupCardImageDisplay()
        setupTextChangeHandling()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = self.identifier(forSegue: segue)
        switch identifier {
        case .purchaseSuccess:
            guard let destination = segue.destination as? ChocolateIsComingViewController else {
                assertionFailure("Couldn't get chocolate is coming VC!")
                return
            }
            destination.cardType = cardType.value
        }
    }
}

// MARK: - RX Setup

private extension BillingInfoViewController {
    func setupCardImageDisplay() {
        // 根据信用卡类型更新卡片图片样式
        // 将 BehaviorRelay<CardType> 转换为可观察序列，通过观察者订阅它并实时更新 UI。
        cardType.asObservable()
            .subscribe(onNext: { [unowned self] cardType in
                self.creditCardImageView.image = cardType.image
            })
            .disposed(by: disposeBag)
    }
    
    func setupTextChangeHandling() {
        // 将文本字段的内容作为 Observable 值返回
        let creditCardValid = creditCardNumberTextField.rx.text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance) // 节流
            .map { [unowned self] in
                self.validate(cardText: $0)
            }
        
        // 订阅 Observable 值
        creditCardValid.subscribe(onNext: { [unowned self] in
            self.creditCardNumberTextField.valid = $0
        })
        .disposed(by: disposeBag)
        
        let expirationValid = expirationDateTextField.rx.text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validate(expirationDateText: $0)
            }

        expirationValid.subscribe(onNext: { [unowned self] in
            self.expirationDateTextField.valid = $0
        })
        .disposed(by: disposeBag)
        
        let cvvValid = cvvTextField.rx.text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .map { [unowned self] in
                self.validate(cvvText: $0)
            }

        cvvValid.subscribe(onNext: { [unowned self] in
            self.cvvTextField.valid = $0
        })
        .disposed(by: disposeBag)
        
        let everythingValid = Observable.combineLatest(creditCardValid, expirationValid, cvvValid) {
            $0 && $1 && $2 // All must be true
        }
        everythingValid.bind(to: purchaseButton.rx.isEnabled).disposed(by: disposeBag)
    }
}

// MARK: - Validation methods

private extension BillingInfoViewController {
    func validate(cardText: String?) -> Bool {
        guard let cardText = cardText else {
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

// MARK: - SegueHandler

extension BillingInfoViewController: SegueHandler {
    enum SegueIdentifier: String {
        case purchaseSuccess
    }
}

