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
    
    var viewModel: ProductDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshState()
        viewModel.loadDetails()
    }
    
    private func refreshState() {
        title = viewModel.viewData.product.title
        loadingLabel.isHidden = !viewModel.viewData.isLoading
        UIApplication.shared.isNetworkActivityIndicatorVisible = viewModel.viewData.isLoading
    }
}

extension ProductDetailViewController: ViewModelDelegate {
    func reloadViewData() {
        refreshState()
    }
}
