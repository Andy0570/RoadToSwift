> 原文：[Configure collection view cells with UICollectionView.CellRegistration](https://www.donnywals.com/configure-collection-view-cells-with-uicollectionview-cellregistration/)

在 iOS14 中，你可以使用新的 `UICollectionView.CellRegistration` 类来注册和配置你的`UICollectionViewCell` 实例。因此，不再需要 `cellIdentifier = "MyCell"`，不再需要`collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)`，最重要的是，你不再需要将 `dequeueReusableCell(withReuseIdentifier:for:)` 返回的 cell 映射到你的自定义单元格类。

在你的项目中采用 `UICollectionView.CellRegistration` 是出乎意料的简单。为了演示的目的，我创建了以下 `UICollectionViewCell` 子类。

```swift
class MyCollectionViewCell: UICollectionViewCell {
    let label = UILabel()

    required init?(coder: NSCoder) {
        fatalError("nope!")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            label.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -8)
        ])
    }
}
```

使用 `UICollectionView.CellRegistration` 在集合视图中注册这个单元格，你只需要一个为你的单元格类和数据模型而专门设计的 `UICollectionView.CellRegistration` 实例。我的情况是使用一个 `String` 作为我的数据模型，因为这个单元格只有一个标签。你可以为你的单元格使用任何你想要的对象。通常情况下，它将是你在 cellForItemAt 委托方法中获取的模型。

```swift
let simpleConfig = UICollectionView.CellRegistration<MyCollectionViewCell, String> { (cell, indexPath, model) in
    cell.label.text = model
}
```

注意 `UICollectionView.CellRegistration` 在两种类型上是通用的。我想使用的`UICollectionViewCell`，以及模型类型，在我的例子中是一个 `String`。`UICollectionView.CellRegistration` 的初始化器需要一个用于设置单元格的闭包。这个闭包接收一个 cell、一个 indexPath 和用于配置单元格的 model。

在我的实现中，我只是将我的字符串模型分配给 `cell.label.text`。

你不需要在你的 `UICollectionView` 上注册 `UICollectionView.CellRegistration`。相反，你可以在要求你的集合视图在 `cellForItemAt` 中取消一个可重用的单元格时使用它，如下所示：

```swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let model = "Cell \(indexPath.row)"
    return collectionView.dequeueConfiguredReusableCell(using: simpleConfig, for: indexPath, item: model)
}
```

当你在`UICollectionView`上调用`dequeueConfiguredReusableCell(using:for:item:)`时，它就会取消一个具有正确类的单元格，并调用你传递给`UICollectionView.CellRegistration`初始化器的闭包，这样你就可以配置你的单元格了。

你需要做的就是确保你从数据源中抓取正确的模型，把它传递给`dequeueConfiguredReusableCell(using:for:item:)`，然后返回刚刚获得的单元格。这就是它的全部内容! 很好用吧？没有涉及其他特殊的设置。没有秘密的技巧。什么都没有。只是用一种更好的方式来获取和配置集合视图单元。
