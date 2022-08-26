/**
 参考：
 4 Observables & Subjects in Practice
 <https://www.raywenderlich.com/books/rxswift-reactive-programming-with-swift/v4.0/chapters/4-observables-subjects-in-practice>
 */
import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {

    private let bag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 在 viewDidLoad() 中订阅您的 observable
        images.subscribe { [weak imagePreview] event in
            guard let preview = imagePreview, let photos = event.element else { return }

            preview.image = photos.collage(size: preview.frame.size)

        }.disposed(by: bag)

        // 每次 images 变化时更新 UI
        images.subscribe { [weak self] photos in
            self?.updateUI(photos: photos)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completion")
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: bag)
    }

    @IBAction func actionClear() {
        images.accept([])
    }

    @IBAction func actionSave() {
        guard let image = imagePreview.image else {
            return
        }

        PhotoWriter.save(image).asSingle().subscribe { [weak self] id in
            self?.showMessage("Saved with id: \(id)")
            self?.actionClear()
        } onError: { [weak self] error in
            self?.showMessage("Error", description: error.localizedDescription)
        }.disposed(by: bag)

    }

    @IBAction func actionAdd() {
        let photosViewController = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController

        photosViewController.selectedPhotos.subscribe(onNext: { [weak self] newImage in

            guard let images = self?.images else { return }
            images.accept(images.value + [newImage])

        }, onError: nil, onCompleted: nil) {
            print("Completed photo selection")
        }.disposed(by: bag)

        navigationController?.pushViewController(photosViewController, animated: true)
    }

    func showMessage(_ title: String, description: String? = nil) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in self?.dismiss(animated: true, completion: nil)}))
        present(alert, animated: true, completion: nil)
    }

    private func updateUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }

}
