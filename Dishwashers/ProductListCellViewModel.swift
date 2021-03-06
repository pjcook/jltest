//  Copyright © 2019 Software101. All rights reserved.

import UIKit

struct ProductListCellViewData {
    let item: FeedProductItem
    let image: UIImage?
    let isLoadingImage: Bool
}

class ProductListCellViewModel {
    private let apiService: APIServiceProtocol
    private(set) var viewData: ProductListCellViewData {
        didSet {
            delegate?.reloadViewData()
        }
    }

    private var loadImageTask: URLSessionTask?

    weak var delegate: ViewModelDelegate?

    init(viewData: ProductListCellViewData, apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.viewData = viewData
    }

    func prepareForReuse() {
        loadImageTask?.cancel()
    }

    func loadImage() {
        loadImageTask?.cancel()
        var imageURL = viewData.item.image
        if imageURL.hasPrefix("//") {
            imageURL = "https:" + imageURL
        }
        if let url = URL(string: imageURL) {
            viewData = ProductListCellViewData(item: viewData.item, image: viewData.image, isLoadingImage: true)
            loadImageTask = apiService.downloadImage(url: url, completionHandler: { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure:
                    self.failedToLoadImage()
                case let .success(data):
                    self.processImageData(data: data)
                }
            })
        }
    }

    private func failedToLoadImage() {
        DispatchQueue.main.async {
            self.viewData = ProductListCellViewData(item: self.viewData.item, image: self.viewData.image, isLoadingImage: false)
        }
    }

    private func processImageData(data: Data?) {
        var image: UIImage? = viewData.image
        if let data = data {
            image = UIImage(data: data)
        }
        DispatchQueue.main.async {
            self.viewData = ProductListCellViewData(item: self.viewData.item, image: image, isLoadingImage: false)
        }
    }
}
