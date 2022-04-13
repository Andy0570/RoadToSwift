//
//  ViewController.swift
//  ViewSample
//
//  Created by Benoit PASQUIER on 18/08/2021.
//

import UIKit

class ViewController: UIViewController {
    lazy var viewModel: ViewModelProtocol = ViewModel()
    lazy var dataSource = ViewDataSource(viewModel: self.viewModel)
    
    init(viewModel: ViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        return tableView
    }()

    // 这个 checkoutView 使用 UIView + UITapGestureRecognizer 的组合来模拟 UIButton 的行为。
    // 纯粹是为了测试 UITapGestureRecognizer 手势
    lazy var checkoutView: UIView = {
        let label = UILabel()
        label.text = "Checkout"
        label.textColor = .white
        label.textAlignment = .center
        
        let view = UIView()
        view.backgroundColor = .blue
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addGestureRecognizer(checkoutTapGesture)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }()
    
    private lazy var checkoutTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCheckout))

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cart"
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(checkoutView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            checkoutView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            checkoutView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            checkoutView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            checkoutView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // 当用户点击 checkoutView 时，它将执行 viewModel.checkout
    @objc private func tapCheckout() {
        viewModel.checkout()
    }
}
