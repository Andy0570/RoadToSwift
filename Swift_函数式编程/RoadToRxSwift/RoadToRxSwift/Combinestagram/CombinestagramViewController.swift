//
//  CombinestagramViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa

class CombinestagramViewController: UIViewController {
    // 使用 private 类型的 IBOutlet 以优化并减少 Xcode 编译时间
    @IBOutlet private weak var imagePreview: UIImageView!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    private var addItem: UIBarButtonItem!

    private let disposeBag: DisposeBag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAdd))
        self.navigationItem.rightBarButtonItem = addBarButton
        self.addItem = addBarButton

        images.subscribe(onNext: { [weak imagePreview] photos in
            guard let preview = imagePreview else { return }

            preview.image = photos.collage(size: preview.frame.size)
        }).disposed(by: disposeBag)

        images.subscribe(onNext: { [weak self] photos in
            self?.updateUI(photos: photos)
        }).disposed(by: disposeBag)
    }

    // MARK: - Actions

    @IBAction func actionClear(_ sender: Any) {
        images.accept([])
    }
    
    @IBAction func actionSave(_ sender: Any) {
        guard let image = imagePreview.image else {
            return
        }

        PhotoWriter.save(image).subscribe(
            onSuccess: { [weak self] identifier in
                self?.showMessage("Saved with id: \(identifier)")
                self?.actionClear(self as Any)
            },
            onFailure: { [weak self] error in
                self?.showMessage("Error", description: error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    @objc func actionAdd() {
        let photosViewController = PhotosViewController(collectionViewLayout: UICollectionViewFlowLayout())

        // 订阅 selectedPhotos 可观察序列，获得回调数据
        photosViewController.selectedPhotos.subscribe { [weak self] newImage in
            guard let images = self?.images else { return }
            images.accept(images.value + [newImage])
        } onDisposed: {
            print("Completed photo selection")
        }.disposed(by: disposeBag)

        navigationController?.pushViewController(photosViewController, animated: true)
    }

    // MARK: - Private

    private func updateUI(photos: [UIImage]) {
        saveButton.isEnabled = photos.count > 0 && photos.count % 2 == 0
        clearButton.isEnabled = photos.count > 0
        addItem.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }

    private func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, message: description).subscribe().disposed(by: disposeBag)
    }

}
