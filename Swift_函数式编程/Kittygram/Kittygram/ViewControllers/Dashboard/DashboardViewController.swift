//
//  DashboardViewController.swift
//  Kittygram
//
//  Created by Lukasz Mroz on 19.10.2016.
//  Copyright © 2016 Sunshinejr. All rights reserved.
//

import Moya
import Moya_ModelMapper
import RxSwift
import RxCocoa

protocol DashboardViewControllerDelegate: AnyObject {
    func kittySelected(repo: Repository)
}

class DashboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var progressView = UIView()

    // 通过依赖注入的方式传入 viewModel
    private var viewModel: DashboardViewModelType!
    private let disposeBag = DisposeBag()

    convenience init(viewModel: DashboardViewModelType) {
        self.init()

        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "KittyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "kittyCell")

        // 选中绑定
        tableView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)

        // 将包含 Model 的可观察序列绑定到 View
        viewModel.reposeObservable
            .bind(to: tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "kittyCell", for: indexPath) as! KittyTableViewCell
                cell.viewModel = item
                return cell
            }
            .disposed(by: disposeBag)

        viewModel.errorObservable
            .subscribe(onNext: { [weak self] error in
                self?.showAlert("Error", message: error)
            })
            .disposed(by: disposeBag)
    }

    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}
