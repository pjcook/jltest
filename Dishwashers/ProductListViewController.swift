//
//  ProductListViewController.swift
//  Dishwashers
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var loadingLabel: UILabel!
    
    var viewModel: ProductListViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshState()
        viewModel.loadPage()
    }
    
    private func refreshState() {
        let pageTitle = NSLocalizedString("productList.page.title", comment: "")
        let totalResults = viewModel.viewData.totalResults
        let productCount = totalResults > 0 ? " (\(totalResults))" : ""
        title = "\(pageTitle)\(productCount)"
        loadingLabel.isHidden = !viewModel.viewData.showLoadingOverlay
        collectionView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = viewModel.viewData.isLoading
    }
}

extension ProductListViewController: ViewModelDelegate {
    func reloadViewData() {
        refreshState()
    }
}

// MARK:- UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.didSelectItem(indexPath.row, viewController: self)
    }
}

// MARK:- UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.viewData.productItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
        let cellViewModel = viewModel.viewModelForCell(at: indexPath.row)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
}
