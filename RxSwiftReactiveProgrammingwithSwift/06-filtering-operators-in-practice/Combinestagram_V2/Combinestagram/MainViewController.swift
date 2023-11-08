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

    // 存储每张图片的长度（以字节为单位），模拟图片唯一性
    // 更好的解决方案：存储图像数据的哈希值或者资产URL
    private var imageCache = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 订阅 BehaviorRelay<[UIImage]> 发出的 next 事件，并更新 UI 创建拼贴画
        images
            // 需求：防止不必要的 UI 渲染
            // 代码逻辑：在 500 毫秒（0.5秒）内，如果有许多元素相继进入，只取最后一个
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak imagePreview] photos in
                guard let preview = imagePreview else { return }

                preview.image = photos.collage(size: preview.frame.size)
            })
            .disposed(by: bag)

        images.subscribe(onNext: { [weak self] photos in
            self?.updateUI(photos: photos)
        }).disposed(by: bag)
    }

    @IBAction func actionClear() {
        images.accept([])
        imageCache = []
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

        // share() 操作符：让多个订阅者共享同一个可观察序列生成的元素
        let newPhotos = photosViewController.selectedPhotos.share()

        newPhotos
            .take(while: { [weak self] image in
                // 需求：仅获取前 6 张照片
                // 代码逻辑：当条件评估为 false 时，takeWhile(_) 会丢弃所有的元素
                let count = self?.images.value.count ?? 0
                return count < 6
            })
            .filter { newImage in
                // 过滤纵向显示的照片，检查图片的宽度 > 图片的高度，满足条件则通过
                return newImage.size.width > newImage.size.height
            }
            .filter { [weak self] newImage in
                // 需求：防止用户多次添加同一张照片
                // 代码逻辑：缓存图片字节长度，模拟唯一性
                // FIXME: 基于演示目的，这里引入了状态（即 imageCache），后面会通过 scan 操作符优化。
                let length = newImage.pngData()?.count ?? 0
                guard self?.imageCache.contains(length) == false else {
                    return false
                }
                self?.imageCache.append(length)
                return true
            }
            .subscribe { [weak self] newImage in
                guard let images = self?.images else { return }
                images.accept(images.value + [newImage])
            } onDisposed: {
                print("Completed photo selection")
            }
            .disposed(by: bag)

        // 需求：当所有照片选择完成时，在导航栏左上角显示拼贴画的小预览
        // 代码逻辑：过滤所有元素，只对 .completed 事件采取行动
        newPhotos
            .ignoreElements()
            .subscribe(onCompleted: { [weak self] in
                self?.updateNavigationIcon()
            })
            .disposed(by: bag)

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

    private func updateNavigationIcon() {
        let icon = imagePreview.image?.scaled(CGSize(width: 22, height: 22)).withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: nil, action: nil)
    }
}
