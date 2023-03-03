import UIKit
import Action
import RxSwift

class TaskItemTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var button: UIButton!
    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        button.rx.action = nil
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }

    func configure(with item: TaskItem, action: CocoaAction) {
        button.rx.action = action

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
