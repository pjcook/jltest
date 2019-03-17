//
//  ProductDetailViewModel.swift
//  Dishwashers
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct ProductDetailViewData {
    let isLoading: Bool
    let product: ProductItem
    var price: String {
        guard !product.price.now.isEmpty, let price = Double(product.price.now) else { return "" }
        let locale = Locale.locale(from: product.price.currency)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: NSNumber(value: price)) ?? ""
    }
}

class ProductDetailViewModel {
    private let apiService: APIServiceProtocol
    private(set) var viewData: ProductDetailViewData {
        didSet {
            delegate?.reloadViewData()
        }
    }
    
    weak var delegate: ViewModelDelegate?
    
    init(viewData: ProductDetailViewData, apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.viewData = viewData
    }
    
    func loadDetails() {
        guard !viewData.isLoading else { return }
        self.viewData = ProductDetailViewData(isLoading: true, product: self.viewData.product)
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
