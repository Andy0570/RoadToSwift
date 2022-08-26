//
//  HomeVC.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {

    @IBOutlet weak var albumsVCView: UIView!
    @IBOutlet weak var tracksVCView: UIView!

    private lazy var albumsViewController: AlbumsCollectionViewVC = {
        // 加载 Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // 实例化 View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AlbumsCollectionViewVC") as! AlbumsCollectionViewVC

        // 把 View Controller 作为子视图控制器添加
        self.add(asChildViewController: viewController, to: albumsVCView)

        return viewController
    }()

    private lazy var tracksViewController: TracksTableViewVC = {
        // 加载 Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // 实例化 View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "TracksTableViewVC") as! TracksTableViewVC

        // 把 View Controller 作为子视图控制器添加
        self.add(asChildViewController: viewController, to: tracksVCView)

        return viewController
    }()

    var homeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - View's Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addBlurArea(area: self.view.frame, style: .dark)
        setupBinding()
        homeViewModel.requestData()
    }
    
    // MARK: - Bindings

    private func setupBinding() {

        // 让 HomeVC 监听 ViewModel 并在其改变时更新 view。
        // 将 loading 绑定到 isAnimating，这意味着每当 ViewModel 改变 loading 的值时，ViewController 的 isAnimating 值也会改变。
        homeViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)

        // 监听显示 error
        // .observe(on: MainScheduler.instance) 表示将发出的信号带到主线程
        homeViewModel.error.observe(on: MainScheduler.instance).subscribe(onNext: { (error) in
            switch error {
            case .internetError(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .error)
            case .serverMessage(let message):
                MessageView.sharedInstance.showOnView(message: message, theme: .warning)
            }
        }).disposed(by: disposeBag)

        // 把专辑绑定到 album 容器
        homeViewModel.albums.observe(on: MainScheduler.instance).bind(to: albumsViewController.albums).disposed(by: disposeBag)

        // 把曲目绑定到 track 容器
        homeViewModel.tracks.observe(on: MainScheduler.instance).bind(to: tracksViewController.tracks).disposed(by: disposeBag)
    }
}
