//
//  PhotoListViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

/**
 参考：<https://juejin.cn/post/6844903560073707528>
 
 MVVM 是一种专注于将用户界面开发与业务逻辑开发实现分离的 iOS 架构趋势；
 MVVM 的主要目的是将数据状态从 View 移动到 ViewModel
 */

import UIKit

class PhotoListViewController: UIViewController {

    // 使用 lazy 修饰该变量，只有实例初始化完成之后，才能检索该变量
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.backgroundColor = UIColor.systemBackground
        return tableView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .medium
        return indicatorView
    }()

    lazy var viewModel: PhotoListViewModel = {
        return PhotoListViewModel()
    }()

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()

        // 初始化 ViewModel
        initViewModel()
    }

    private func initView() {
        self.navigationItem.title = "Popular"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PhotoListTableViewCell.nib, forCellReuseIdentifier: PhotoListTableViewCell.identifier)
    }

    private func initViewModel() {

        // !!!: 使用闭包实现数据绑定
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }

        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.25) {
                        self?.tableView.alpha = 0.0
                    }
                } else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.25) {
                        self?.tableView.alpha = 1.0
                    }
                }
            }
        }

        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.initFetch()
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PhotoListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.identifier, for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }

        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.photoListCellViewModel = cellViewModel

        return cell
    }

}

extension PhotoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.userPressed(at: indexPath)
        if viewModel.isAllowSegue {
            let photoDetailVC = PhotoDetailViewController()
            photoDetailVC.imageUrl = self.viewModel.selectedPhoto?.image_url
            navigationController?.pushViewController(photoDetailVC, animated: true)
        }
    }

}
