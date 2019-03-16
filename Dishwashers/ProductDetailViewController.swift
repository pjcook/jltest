//
//  ProductDetailViewController.swift
//  Dishwashers
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet private var loadingLabel: UILabel!
    
    private var loadingData = false {
        didSet {
            loadingLabel.isHidden = !loadingData
        }
    }
    
    var apiService: APIServiceProtocol!
    
    var productId: String?
    var product: ProductItem? {
        didSet {
            refreshProductDetails()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingData = false
        loadDetails()
    }
    
    private func refreshProductDetails() {
        title = product?.title
    }
}

// MARK:- data loading
extension ProductDetailViewController {
    private func failedToLoadPage() {
        DispatchQueue.main.async {
            self.loadingData = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func processNewData(data: Data?) {
        if let product = ProductItem.processNetworkData(data: data) {
            DispatchQueue.main.async {
                self.loadingData = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.product = product
            }
        }
    }
    
    private func loadDetails() {
        guard let productId = productId, !loadingData else { return }
        loadingData = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = apiService.productDetails(productID: productId) { [weak self] response in
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
