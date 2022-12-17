import UIKit
import RxSwift

// 让视图控制器遵守该协议，将视图控制器与 ViewModel 进行绑定。
protocol BindableType: AnyObject {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model;
        loadViewIfNeeded()
        bindViewModel()
    }
}
