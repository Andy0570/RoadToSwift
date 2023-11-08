import UIKit

class ClassicFeedViewController: UIViewController {

  let loader = JournalEntryLoader()
  let solFormatter = SolFormatter()
  
  // 集合视图
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.backgroundColor = .black
    view.alwaysBounceVertical = true
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.register(JournalEntryCell.self, forCellWithReuseIdentifier: "JournalEntryCell")
    collectionView.register(JournalEntryDateCell.self, forCellWithReuseIdentifier: "JournalEntryDateCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    view.addSubview(collectionView)
    
    loader.loadLatest()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    collectionView.frame = view.bounds
  }
}

// 通过 extension 扩展实现 UICollectionViewDataSource 协议
// MARK: - UICollectionViewDataSource
extension ClassicFeedViewController: UICollectionViewDataSource {
  
  // 一共有多少 section
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return loader.entries.count
  }
  
  // 每个 section 显示多少 cell
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  // 分别配置每个 cell
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = indexPath.item == 0 ? "JournalEntryDateCell" : "JournalEntryCell"
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    let entry = loader.entries[indexPath.section]
    if let cell = cell as? JournalEntryDateCell {
      // 显示日期
      cell.label.text = "SOL \(solFormatter.sols(fromDate: entry.date))"
    } else if let cell = cell as? JournalEntryCell {
      // 显示文本
      cell.label.text = entry.text
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ClassicFeedViewController: UICollectionViewDelegateFlowLayout {
    
  // 返回 cell item 的尺寸
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    if indexPath.item == 0 {
      // 日期 cell 返回固定尺寸
      return CGSize(width: width, height: 30)
    } else {
      // 文本 cell 计算并返回字符串实际尺寸
      let entry = loader.entries[indexPath.section]
      return JournalEntryCell.cellSize(width: width, text: entry.text)
    }
  }
}
