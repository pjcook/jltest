//  Copyright © 2019 Software101. All rights reserved.

import UIKit

struct ProductDetailViewData {
    let isLoading: Bool
    let product: ProductItem
}

class ProductDetailViewModel {
    private let apiService: APIServiceProtocol
    let maximumGalleryHeight: CGFloat
    private(set) var viewData: ProductDetailViewData {
        didSet {
            delegate?.reloadViewData()
        }
    }

    var imageGalleryViewModel: ImageGalleryViewModel {
        return ImageGalleryViewModel(apiService: apiService, urls: viewData.product.media.images.urls)
    }

    var priceViewData: ProductDetailsPriceViewData {
        return ProductDetailsPriceViewData(
            price: viewData.product.price.nowFormatted,
            specialOffer: viewData.product.displaySpecialOffer,
            additionalServices: viewData.product.additionalServices.includedServices
        )
    }

    var productInformationViewData: ProductDetailsProductInfoViewData {
        return ProductDetailsProductInfoViewData(
            productCode: viewData.product.code,
            productDescription: viewData.product.details.productInformation
        )
    }

    var productSpecificationViewData: ProductDetailsProductSpecificationViewData {
        return ProductDetailsProductSpecificationViewData(productDetails: viewData.product.details)
    }

    weak var delegate: ViewModelDelegate?

    init(viewData: ProductDetailViewData, maximumGalleryHeight: CGFloat, apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.maximumGalleryHeight = maximumGalleryHeight
        self.viewData = viewData
    }

    func loadDetails() {
        guard !viewData.isLoading else { return }
        viewData = ProductDetailViewData(isLoading: true, product: viewData.product)
        _ = apiService.productDetails(productID: viewData.product.productId) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .failure:
                self.failedToLoadPage()
            case let .success(data):
                self.processNewData(data: data)
            }
        }
    }
}

extension ProductDetailViewModel {
    private func failedToLoadPage() {
        DispatchQueue.main.async {
            self.viewData = ProductDetailViewData(isLoading: false, product: self.viewData.product)
        }
    }

    private func processNewData(data: Data?) {
        var product = viewData.product
        if let newProduct = ProductItem.processNetworkData(data: data) {
            product = newProduct
        }
        DispatchQueue.main.async {
            self.viewData = ProductDetailViewData(isLoading: false, product: product)
        }
    }
}
