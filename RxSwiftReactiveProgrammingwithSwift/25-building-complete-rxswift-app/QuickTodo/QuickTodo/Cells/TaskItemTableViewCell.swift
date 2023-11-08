import UIKit
import Action
import RxSwift

class TaskItemTableViewCell: UITableViewCell {

    // MARK: - Private
    private var disposeBag = DisposeBag()

    // MARK: - Controls
    @IBOutlet var title: UILabel!
    @IBOutlet var button: UIButton!

    override func prepareForReuse() {
        button.rx.action = nil
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }

    func configure(with item: TaskItem, action: CocoaAction) {
        button.rx.action = action

        // 当 Realm 数据库中的底层模型数据动态更新时，如何同步更新显示到 UI 上？
        // 由于存储在 Realm 数据库中的对象使用了动态属性，它们可以用 KVO 来观察。
        // 使用 RxSwift，你可以使用 object.rx.observe(class, propertyName) 来从属性的变化中创建一个可观察的序列
        // 单独观察这两个属性并相应地更新 cell 内容

        item.rx.observe(String.self, "title").subscribe(onNext: { [weak self] title in
            self?.title.text = title
        }).disposed(by: disposeBag)

        item.rx.observe(Date.self, "checked").subscribe(onNext: { [weak self] date in
            let image = UIImage(named: date == nil ? "ItemNotChecked" : "ItemChecked")
            self?.button.setImage(image, for: .normal)
        }).disposed(by: disposeBag)
    }
}
