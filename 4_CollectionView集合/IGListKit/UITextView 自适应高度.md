If you need dynamic height for cells with `UITextView` embedded, Here is my solution:

![](https://static01.imgkr.com/temp/e718ad26bfa243c79d394797f4b809ff.gif)



### PublishViewController.swift

```swift
import IGListKit

class PublishViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()

    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        return ListAdapter(updater: updater, viewController: self, workingRangeSize: 1)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(navigationLeftBarButtonTapped))

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: - Actions

    @objc func navigationLeftBarButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension PublishViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [PublishTitleViewModel(title: "Title", iconImage: nil, placeholder: "placeholder", lengthLimit: 100)]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
      return TitleSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
```

### TitleSectionController.swift

```swift
import IGListKit

class TitleSectionController: ListSectionController {
    var publishTitleViewModel: PublishTitleViewModel?

    override func didUpdate(to object: Any) {
        guard let currentViewModel = object as? PublishTitleViewModel else {
            return
        }
        publishTitleViewModel = currentViewModel
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext,
            let cell = ctx.dequeueReusableCell(of: PublishTitleCell.self, withReuseIdentifier: PublishTitleCell.identifier, for: self, at: index) as? PublishTitleCell else {
            return UICollectionViewCell()
        }
				
      	// Configure cell delegate to receive textViewDidChange Notification
        cell.cellDelegate = self
        return cell
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: 50)
    }
}

// MARK: - PublishTitleCellProtocol

extension TitleSectionController: PublishTitleCellProtocol {
    func updateHeightOfRow(_ cell: PublishTitleCell, _ textView: UITextView) {
        collectionContext?.invalidateLayout(for: self)
    }
}
```

### PublishTitleCell.swift

```swift
import UIKit

protocol PublishTitleCellProtocol: AnyObject {
    func updateHeightOfRow(_ cell: PublishTitleCell, _ textView: UITextView)
}

class PublishTitleCell: UICollectionViewCell {
    weak var cellDelegate: PublishTitleCellProtocol?

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        let config = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .body))
        imageView.image = UIImage(systemName: "highlighter", withConfiguration: config)
        imageView.tintColor = UIColor(red: 83/255.0, green: 202/255.0, blue: 195/255.0, alpha: 1.0)

        return imageView
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false        
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    public static var identifier: String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(textView)
        contentView.addSubview(separatorView)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),

            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            textView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            separatorView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

// MARK: - UITextViewDelegate

extension PublishTitleCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = cellDelegate {
            delegate.updateHeightOfRow(self, textView)
        }
    }
}
```

