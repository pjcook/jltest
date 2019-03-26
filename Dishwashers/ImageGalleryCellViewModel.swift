//
//  File.swift
//  Dishwashers
//
//  Created by PJ COOK on 18/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

struct ImageGalleryCellViewData {
    let url: String
    let image: UIImage?
    let isLoadingImage: Bool
}

class ImageGalleryCellViewModel {
    private let apiService: APIServiceProtocol
    private var loadImageTask: URLSessionTask?
    private(set) var viewData: ImageGalleryCellViewData {
        didSet {
            delegate?.reloadViewData()
        }
    }

    weak var delegate: ViewModelDelegate?

    init(viewData: ImageGalleryCellViewData, apiService: APIServiceProtocol) {
        self.viewData = viewData
        self.apiService = apiService
    }

    func loadImage() {
        loadImageTask?.cancel()
        var imageURL = viewData.url
        if imageURL.hasPrefix("//") {
            imageURL = "https:" + imageURL
        }
        if let url = URL(string: imageURL) {
            viewData = ImageGalleryCellViewData(url: viewData.url, image: viewData.image, isLoadingImage: true)
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

    func prepareForReuse() {
        loadImageTask?.cancel()
    }

    private func failedToLoadImage() {
        DispatchQueue.main.async {
            self.viewData = ImageGalleryCellViewData(url: self.viewData.url, image: self.viewData.image, isLoadingImage: false)
        }
    }

    private func processImageData(data: Data?) {
        var image: UIImage? = viewData.image
        if let data = data {
            image = UIImage(data: data)
        }
        DispatchQueue.main.async {
            self.viewData = ImageGalleryCellViewData(url: self.viewData.url, image: image, isLoadingImage: false)
        }
    }
}
