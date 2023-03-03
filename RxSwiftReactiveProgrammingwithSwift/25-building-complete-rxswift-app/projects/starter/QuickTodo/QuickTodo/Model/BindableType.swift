import UIKit
import RxSwift

// 每个遵守 BindableType 协议的视图控制器将声明一个 viewModel 属性，并提供一个 bindViewModel() 方法，一旦 viewModel 属性被分配，就会被调用。
protocol BindableType: AnyObject {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
