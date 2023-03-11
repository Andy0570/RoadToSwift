import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!

    private let bag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        // 订阅 BehaviorRelay<[UIImage]> 发出的 next 事件，并更新 UI 创建拼贴画
        images.subscribe(onNext: { [weak imagePreview] photos in
            guard let preview = imagePreview else { return }

            preview.image = photos.collage(size: preview.frame.size)
        }).disposed(by: bag)

        images.subscribe(onNext: { [weak self] photos in
            self?.updateUI(photos: photos)
        }).disposed(by: bag)
    }

    @IBAction func actionClear() {
        images.accept([])
    }
    
    @IBAction func actionSave() {
        guard let image = imagePreview.image else { return }

        PhotoWriter.save(image).subscribe { [weak self] identifier in
            self?.showMessage("Saved with id: \(identifier)")
            self?.actionClear()
        } onFailure: { [weak self] error in
            self?.showMessage("Error", description: error.localizedDescription)
        }.disposed(by: bag)
    }
    
    @IBAction func actionAdd() {
        let photosViewController = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController

        // 订阅 selectedPhotos 可观察序列，获得回调数据
        photosViewController.selectedPhotos.subscribe { [weak self] newImage in
            guard let images = self?.images else { return }
            images.accept(images.value + [newImage])
        } onDisposed: {
            print("Completed photo selection")
        }.disposed(by: bag)

        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, message: description).subscribe().disposed(by: bag)
    }

    private func updateUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }
}
