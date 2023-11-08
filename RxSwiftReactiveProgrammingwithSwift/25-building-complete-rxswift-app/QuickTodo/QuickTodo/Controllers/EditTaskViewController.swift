import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class EditTaskViewController: UIViewController, BindableType {

    @IBOutlet var titleView: UITextView!
    @IBOutlet var okButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!

    var viewModel: EditTaskViewModel!

    func bindViewModel() {
        titleView.text = viewModel.itemTitle

        cancelButton.rx.action = viewModel.onCancel

        // 当用户点击 OK 按钮时，将 titleView 的内容传递给 onUpdate 动作
        okButton.rx.tap
            .withLatestFrom(titleView.rx.text.orEmpty)
            .bind(to: viewModel.onUpdate.inputs)
            .disposed(by: self.rx.disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleView.becomeFirstResponder()
    }
}
