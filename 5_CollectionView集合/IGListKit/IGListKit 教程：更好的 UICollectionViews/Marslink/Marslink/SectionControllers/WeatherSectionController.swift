import IGListKit

class WeatherSectionController: ListSectionController {
    // 1
    var weather: Weather!
    // 存储变量，描述当前 section 是否展开，默认折叠
    var expanded = false
    
    override init() {
        super.init()
        // 3
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

// MARK: Data provider
extension WeatherSectionController {
    // 1
    override func didUpdate(to object: Any) {
        weather = object as? Weather
    }
    
    // 2
    override func numberOfItems() -> Int {
        return expanded ? 5 : 1
    }
    
    // 3
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let width = context.containerSize.width
        if index == 0 {
            // 第一个 cell 永远展示 Header
            return CGSize(width: width, height: 70)
        } else {
            return CGSize(width: width, height: 40)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass = (index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self)
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        
        if let cell = cell as? WeatherSummaryCell {
            cell.setExpanded(expanded)
        } else if let cell = cell as? WeatherDetailCell {
            let title: String, detail: String
            switch index {
            case 1:
              title = "SUNRISE"
              detail = weather.sunrise
            case 2:
              title = "SUNSET"
              detail = weather.sunset
            case 3:
              title = "HIGH"
              detail = "\(weather.high) C"
            case 4:
              title = "LOW"
              detail = "\(weather.low) C"
            default:
              title = "n/a"
              detail = "n/a"
            }
            cell.titleLabel.text = title
            cell.detailLabel.text = detail
        }
        return cell
    }

    // 当 cell 被点击时，切换 section 的展开状态并刷新 cell
    override func didSelectItem(at index: Int) {
        collectionContext?.performBatch(animated: true, updates: { IGListBatchContext in
            self.expanded.toggle()
            IGListBatchContext.reload(self)
        }, completion: nil)
    }
}
