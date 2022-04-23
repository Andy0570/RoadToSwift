//
//  SuperHeroSectionController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

enum Index: Int {
    case realName
    case superHeroName
}

class SuperHeroSectionController: ListSectionController {
    var currentHero: SuperHero?
    var collapsed = true // 是否折叠

    // 当 sectionController 获取到数据时调用该方法。我们只是使用这个函数来存储我们当前的模型。
    override func didUpdate(to object: Any) {
        guard let superHero = object as? SuperHero else {
            return
        }
        currentHero = superHero
    }

    override func numberOfItems() -> Int {
        return collapsed ? 1: 2
    }

    // 使用数据模型对 cell 进行配置
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let currentHero = currentHero else {
            return cell
        }

        switch index {
        case Index.realName.rawValue:
            if let realNameCell = getRealnameCell(at: index) {
                cell = realNameCell
            }
        case Index.superHeroName.rawValue:
            if let superHeroNameCell = getSuperHeroNameCell(at: index) {
                cell = superHeroNameCell
            }
        default:
            cell = UICollectionViewCell()
        }

        guard let superHeroCell = cell as? SuperHeroModelUpdatable else {
            return cell
        }
        superHeroCell.updateWith(superHero: currentHero)

        return cell
    }

    // 返回给定索引处 cell 的大小
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: 50)
    }
}

extension SuperHeroSectionController {
    private func getRealnameCell(at index: Int) -> UICollectionViewCell? {
        guard let ctx = collectionContext else {
            return UICollectionViewCell()
        }

        let nibName = String(describing: RealnameCell.self)
        let cell = ctx.dequeueReusableCell(withNibName: nibName, bundle: nil, for: self, at: index)
        return cell
    }

    private func getSuperHeroNameCell(at index: Int) -> UICollectionViewCell? {
        guard let ctx = collectionContext else {
            return UICollectionViewCell()
        }

        let nibName = String(describing: SuperHeroNameCell.self)
        let cell = ctx.dequeueReusableCell(withNibName: nibName, bundle: nil, for: self, at: index)
        return cell
    }
}

extension SuperHeroSectionController {
    override func didSelectItem(at index: Int) {
        collectionContext?.performBatch(animated: true, updates: { batchContext in
            self.collapsed.toggle()
            batchContext.reload(self)
        })
    }
}
