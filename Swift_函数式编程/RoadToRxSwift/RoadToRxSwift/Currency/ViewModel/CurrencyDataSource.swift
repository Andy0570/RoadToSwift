//
//  CurrencyDataSource.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import UIKit

/**
 泛型数据源，将 ViewModel 层与数据层分离，无论我们要更新什么数据，都可以重用该数据源。

 提醒一下，我将 CurrencyViewModel 与 CurrencyDataSource 分离的主要原因是：**你的 ViewModel 永远不应该知道它所绑定的 View**。通过实现 UITableViewDataSource，我觉得它太接近了，所以我分离在另一个类中：CurrencyDataSource。

 如果明天你想更改 UICollectionView 的 UI，则不需要更新 ViewModel，我们将有很大的关注点分离。
 */
class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class CurrencyDataSource : GenericDataSource<CurrencyRate>, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell

        let currencyRate = self.data.value[indexPath.row]
        cell.currencyRate = currencyRate

        return cell
    }
}
