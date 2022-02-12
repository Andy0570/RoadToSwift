# 与 `UICollectionView` 一起工作

本指南提供有关如何使用 [`UICollectionView`](https://developer.apple.com/reference/uikit/uicollectionview) 和 `IGListKit` 的详细信息。

## 背景

`IGListKit` 的早期版本（2.x 和更早版本）附带了一个名为 `IGListCollectionView` 的`UICollectionView` 子类。该类不包含特殊功能，仅用于实施编译时限制，以防止用户直接在 `UICollectionView` 上调用某些方法。从 3.0 开始，`IGListCollectionView`由于多种原因[被删除](https://github.com/Instagram/IGListKit/commit/2284ce389708f62d99f48ff2ec15644f1ec59537)。

更深入的讨论，参考 [#240](https://github.com/Instagram/IGListKit/issues/240) 和 [#409](https://github.com/Instagram/IGListKit/issues/409)。


## 避免使用的方法

`IGListKit` 的主要目的之一是执行 `UICollectionView` 的最佳批量更新。因此，客户端不应该在 `UICollectionView` 上调用任何涉及重新加载、插入、删除或以其他方式更新单元格和索引路径的 API。相反，请使用 `IGListAdapter` 提供的 API。您还应该避免设置集合视图的 [`delegate`](https://developer.apple.com/reference/uikit/uicollectionview/1618033-delegate) 和 [`dataSource`](https://developer.apple.com/reference/uikit/uicollectionview/1618091-datasource)，因为这也是 `IGListAdapter` 的责任。

避免调用以下方法：

```objc
- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL))completion;

- (void)reloadData;

- (void)reloadSections:(NSIndexSet *)sections;

- (void)insertSections:(NSIndexSet *)sections;

- (void)deleteSections:(NSIndexSet *)sections;

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate;

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource;

- (void)setBackgroundView:(UIView *)backgroundView;
```

## 性能

在 iOS 10 中，引入了新的 [cell prefetching API](https://developer.apple.com/reference/uikit/uicollectionviewdatasourceprefetching) API。在 Instagram 中，启用此功能会显著降低滚动性能。我们建议将`isPrefetchingEnabled` 设置为 `NO`(在 Swift 中为 `false`)。请注意，默认值为 `true`。

你可以通过 `UIAppearance` 进行全局设置:

```objc
if ([[UICollectionView class] instancesRespondToSelector:@selector(setPrefetchingEnabled:)]) {
    [[UICollectionView appearance] setPrefetchingEnabled:NO];
}
```

```swift
if #available(iOS 10, *) {
    UICollectionView.appearance().isPrefetchingEnabled = false
}
```
