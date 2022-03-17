//
//  PhotoListViewModel.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

import Foundation

// PhotoListCellViewModel 提供了绑定到 View 中的 UI 组件接口的属性
struct PhotoListCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}

class PhotoListViewModel {
    let apiService: APIServiceProtocol

    private var photos: [Photo] = []

    private var cellViewModels: [PhotoListCellViewModel] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var isLoading = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }

    var isAllowSegue = false
    var selectedPhoto: Photo?

    var reloadTableViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?

    // !!!: 依赖注入，通过 APIService 获取数据
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func getCellViewModel(at indexPath: IndexPath) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }

    func initFetch() {
        self.isLoading = true
        apiService.fetchPopularPhoto { [weak self] _, photos, error in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedPhoto(photos: photos)
            }
        }
    }

    // [Photo] -> [PhotoListCellViewModel]
    private func processFetchedPhoto(photos: [Photo]) {
        self.photos = photos // Catch
        var vms: [PhotoListCellViewModel] = []
        for photo in photos {
            vms.append(createCellViewModel(photo: photo))
        }
        self.cellViewModels = vms
    }

    // Photo -> PhotoListCellViewModel
    func createCellViewModel(photo: Photo) -> PhotoListCellViewModel {
        // 包装描述信息 "[item1] - [item2]"
        var descTextContainer: [String] = []
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }
        if let description = photo.description {
            descTextContainer.append(description)
        }
        let desc = descTextContainer.joined(separator: " - ")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return PhotoListCellViewModel(titleText: photo.name, descText: desc, imageUrl: photo.image_url, dateText: dateFormatter.string(from: photo.created_at))
    }
}

extension PhotoListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            self.isAllowSegue = true
            self.selectedPhoto = photo
        } else {
            self.isAllowSegue = false
            self.selectedPhoto = nil
            self.alertMessage = "This item is not for sale"
        }
    }
}
