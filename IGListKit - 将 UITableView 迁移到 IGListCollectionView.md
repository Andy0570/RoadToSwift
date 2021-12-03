> 原文：[IGListKit — Migrating an UITableView to IGListCollectionView](https://medium.com/cocoaacademymag/iglistkit-migrating-an-uitableview-to-iglistkitcollectionview-65a30cf9bac9)
>
> 通过 [DeepL](https://www.deepl.com/translator) 翻译并由本人校对。


[IGListKit](https://github.com/Instagram/IGListKit) 是 Instagram 开源的一个数据驱动框架，帮助我们创建快速和灵活的 UICollectionViews。实际上，它还提供了许多其他功能，如动画和线性复杂度差异计算，让我们的应用看起来更酷、更快。

今天我将展示如何将一个 `UITableView` 迁移到 `IGListKit`。首先，我们需要一个现有的基于 `UITableView` 实现的应用程序，所以我们要使用 [Thiago Lioy](https://medium.com/@tpLioy) 的 Marvel App。你可以在 [github](https://github.com/thiagolioy/marvelapp) 上查看他的代码，以及他是如何在 [medium](https://medium.com/cocoaacademymag/creating-a-ios-app-from-scratch-tools-pods-tricks-of-the-trade-and-more-part-1-a0a3f18fbd13#.fc7jia6q3) 中创建这个很棒的应用的。

在我们开始安装并使用 IGListKit 之前，先看一下 Lioy 的代码。在 `CharactersViewController` 中，我们可以看到一个 `TableView` 以及它的委托和数据源，它使用了一个叫做 `Character` 的数组。

