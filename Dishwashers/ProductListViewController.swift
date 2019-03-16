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
    
    private var productItems: [FeedProductItem] = [] {
        didSet {
            // TODO: crude, could use collectionView.insertItems to be more graceful
            collectionView.reloadData()
        }
    }
    
    private var searchParameters = SearchParameters.firstPage()
    private var maxPage: Int = 0
    
    private var totalResults: Int = 0 {
        didSet {
            refreshTitle()
        }
    }
    
    private var loadingData = false {
        didSet {
            loadingLabel.isHidden = !loadingData || !productItems.isEmpty
        }
    }

    var apiService: APIServiceProtocol!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let item = sender as? FeedProductItem,
            let destination = segue.destination as? ProductDetailViewController
            else { return }
        destination.productId = item.productId
        destination.apiService = apiService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTitle()
        loadingData = false
        loadPage()
    }
    
    private func refreshTitle() {
        let pageTitle = NSLocalizedString("productList.page.title", comment: "")
        let productCount = totalResults > 0 ? " (\(totalResults))" : ""
        title = "\(pageTitle)\(productCount)"
    }
}

// MARK:- data loading
extension ProductListViewController {
    private func failedToLoadPage() {
        DispatchQueue.main.async {
            self.loadingData = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func processNewData(data: Data?) {
        if let results = FeedSearchResults.processNetworkData(data: data) {
            DispatchQueue.main.async {
                self.loadingData = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.maxPage = results.pagesAvailable
                self.totalResults = results.results
                self.productItems += results.products
            }
        }
    }
    
    private func loadPage() {
        guard hasNextPage(), !loadingData else { return }
        loadingData = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = apiService.searchFeed(search: searchParameters) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .failure:
                self.failedToLoadPage()
            case let .success(data):
                self.processNewData(data: data)
            }
        }
    }
    
    private func hasNextPage() -> Bool {
        guard maxPage > 0 else { return true }
        return searchParameters.pageNumber <= maxPage
    }
}

// MARK:- UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = productItems[indexPath.row]
        performSegue(withIdentifier: "loadProductDetailsPage", sender: item)
    }
}

// MARK:- UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = productItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
        cell.configure(item: item, service: apiService)
        return cell
    }
}
