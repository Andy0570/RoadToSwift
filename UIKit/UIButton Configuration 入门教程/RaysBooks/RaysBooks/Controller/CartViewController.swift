/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CartViewController: UIViewController {
  private var bookListController: BookListViewController?

  private lazy var panelView: CartPanelView = {
    let view = CartPanelView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    view.layer.cornerCurve = .continuous
    view.layer.cornerRadius = 10
    return view
  }()

  private var books: [Book]

  init(books: [Book]) {
    self.books = books

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Cart"
    isModalInPresentation = true

    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.backgroundColor = .systemBackground

    navigationItem.largeTitleDisplayMode = .never

    navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
      self.dismiss(animated: true)
    })

    view.backgroundColor = .systemBackground

    view.addSubview(panelView)
    NSLayoutConstraint.activate([
      panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      panelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      panelView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1 / 3)
    ])

    bookListController = BookListViewController(
      books: books,
      config: BookListViewController.Configuration(showAddButtons: false)
    )
    if let bookListController = bookListController {
      addChildController(bookListController, bottomAnchor: panelView.topAnchor)
    }
  }
}
