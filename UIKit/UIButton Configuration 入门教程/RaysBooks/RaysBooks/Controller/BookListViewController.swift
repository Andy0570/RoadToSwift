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

class BookListViewController: UIViewController {
    // MARK: - Views

    private lazy var collectionView: UICollectionView = {
        let tempLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tempLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - DataSource

    typealias CollectionDataSource = UICollectionViewDiffableDataSource<Section, Book>
    typealias CollectionSnapshot = NSDiffableDataSourceSnapshot<Section, Book>

    enum Section {
        case main
    }

    private lazy var dataSource = makeDataSource()

    // MARK: - Variables & Initializers

    private var books: [Book]
    private var config: Configuration

    /// A list of identifiers for the books in the cart
    private var booksInCart: [UUID] = []

    struct Configuration {
        let showAddButtons: Bool

        static let `default` = Configuration(showAddButtons: true)
    }

    init(books: [Book], config: Configuration = .default) {
        self.books = books
        self.config = config

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Books"

        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true

        let cartButton = UIBarButtonItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            primaryAction: UIAction { _ in
                self.present(
                    UINavigationController(
                        rootViewController: CartViewController(
                            books: self.books.filter { book in
                                return self.isInCart(book: book)
                            }
                        )
                    ),
                    animated: true
                )
            },
            menu: nil
        )

        let accountButton = UIBarButtonItem(
            title: "Sign-in",
            image: UIImage(systemName: "person.crop.circle"),
            primaryAction: UIAction { _ in
                self.present(
                    UINavigationController(rootViewController: SignInViewController()),
                    animated: true
                )
            },
            menu: nil
        )
        navigationItem.rightBarButtonItems = [accountButton, cartButton]

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.collectionViewLayout = makeLayout()
        applySnapshot(animatingDifferences: false)
    }

    func toggleCartStatus(for book: Book) -> Bool {
        if let index = booksInCart.firstIndex(of: book.id) {
            booksInCart.remove(at: index)
        } else {
            booksInCart.append(book.id)
        }

        return isInCart(book: book)
    }

    func isInCart(book: Book) -> Bool {
        return booksInCart.contains(book.id)
    }
}

// MARK: - DataSource Implementation

extension BookListViewController {
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = CollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func makeDataSource() -> CollectionDataSource {
        collectionView.register(
            BookCollectionCell.self,
            forCellWithReuseIdentifier: BookCollectionCell.reuseIdentifier
        )

        return CollectionDataSource(collectionView: collectionView) { collectionView, indexPath, book in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? BookCollectionCell

            cell?.book = book
            cell?.showAddButton = self.config.showAddButtons
            cell?.isBookInCart = self.isInCart(book: book)

            cell?.didTapCartButton = {
                return self.toggleCartStatus(for: book)
            }

            return cell
        }
    }
}

// MARK: - Layout Implementation

extension BookListViewController {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(160)
            )

            let item = NSCollectionLayoutItem(layoutSize: size)

            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)

            return section
        }

        return layout
    }
}
