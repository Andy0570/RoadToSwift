import UIKit
import RxSwift
import RxCocoa

class ViewController : UIViewController {
    @IBOutlet private var hexTextField: UITextField!
    @IBOutlet private var rgbTextField: UITextField!
    @IBOutlet private var colorNameTextField: UITextField!
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private var zeroButton: UIButton!
    @IBOutlet private var buttons: [UIButton]!

    private let disposeBag = DisposeBag()
    private let viewModel = ViewModel()
    private let backgroundColor = PublishSubject<UIColor>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        guard let textField = self.hexTextField else { return }

        // 将 textField 中的文字绑定到视图模型的 hexString 可观察变量
        textField.rx.text.orEmpty
            .bind(to: viewModel.hexString)
            .disposed(by: disposeBag)

        for button in buttons {
            button.rx.tap
                .bind {
                    var shouldUpdate = false

                    switch button.titleLabel!.text! {
                    case "⊗":
                        textField.text = "#"
                        shouldUpdate = true
                    case "←" where textField.text!.count > 1:
                        textField.text = String(textField.text!.dropLast())
                        shouldUpdate = true
                    case "←":
                        break
                    case _ where textField.text!.count < 7:
                        textField.text!.append(button.titleLabel!.text!)
                        shouldUpdate = true
                    default:
                        break
                    }

                    if shouldUpdate {
                        textField.sendActions(for: .valueChanged)
                    }
                }
                .disposed(by: disposeBag)
        }

        viewModel.color
            .drive(onNext: { [unowned self] color in
                UIView.animate(withDuration: 0.2) {
                    self.view.backgroundColor = color
                }
            })
            .disposed(by: disposeBag)

        viewModel.rgb
            .map { "\($0.0), \($0.1), \($0.2)" }
            .drive(rgbTextField.rx.text)
            .disposed(by: disposeBag)

        viewModel.colorName
            .drive(colorNameTextField.rx.text)
            .disposed(by: disposeBag)
    }

    func configureUI() {
        textFields.forEach {
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowRadius = 0.0
            $0.layer.shadowColor = UIColor.lightGray.cgColor
            $0.layer.shadowOffset = CGSize(width: -1, height: -1)
        }
    }
}
