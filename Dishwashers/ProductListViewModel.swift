//
//  ProductListViewModel.swift
//  Dishwashers
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

struct ProductListViewData {
    let productItems: [FeedProductItem]
    let totalResults: Int
    let isLoading: Bool
    var showLoadingOverlay: Bool {
        return isLoading && productItems.isEmpty
    }
}

class ProductListViewModel {
    private let apiService: APIServiceProtocol
    private var maxPage: Int = 0
    private var searchParameters = SearchParameters.firstPage()
    private(set) var viewData: ProductListViewData {
        didSet {
            delegate?.reloadViewData()
        }
    }

    weak var delegate: ViewModelDelegate?

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        viewData = ProductListViewData(productItems: [], totalResults: 0, isLoading: false)
    }

    func loadPage() {
        guard hasNextPage(), !viewData.isLoading else { return }
        viewData = ProductListViewData(productItems: viewData.productItems, totalResults: viewData.totalResults, isLoading: true)
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

    func viewModelForCell(at index: Int) -> ProductListCellViewModel {
        let item = viewData.productItems[index]
        let itemViewData = ProductListCellViewData(item: item, image: nil, isLoadingImage: false)
        let viewModel = ProductListCellViewModel(viewData: itemViewData, apiService: apiService)
        return viewModel
    }

    func didSelectItem(_ index: Int, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "ProductDetail", bundle: Bundle(for: ProductListViewModel.self))
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else {
            assertionFailure("Could not load ProductDetailViewController")
            return
        }
        let item = viewData.productItems[index]
        let product = ProductItem(with: item)
        let detailViewData = ProductDetailViewData(isLoading: false, product: product)
        let maximumGalleryHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 768 : 375
        detailViewController.viewModel = ProductDetailViewModel(viewData: detailViewData, maximumGalleryHeight: maximumGalleryHeight, apiService: apiService)
        detailViewController.viewModel.delegate = detailViewController
        viewController.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ProductListViewModel {
    private func failedToLoadPage() {
        DispatchQueue.main.async {
            self.viewData = ProductListViewData(productItems: self.viewData.productItems, totalResults: self.viewData.totalResults, isLoading: false)
        }
    }

    private func processNewData(data: Data?) {
        if let results = FeedSearchResults.processNetworkData(data: data) {
            DispatchQueue.main.async {
                self.maxPage = results.pagesAvailable
                let products = self.viewData.productItems + results.products
                let totalResults = results.results
                self.viewData = ProductListViewData(productItems: products, totalResults: totalResults, isLoading: false)
            }
        }
    }

    private func hasNextPage() -> Bool {
        guard maxPage > 0 else { return true }
        return searchParameters.pageNumber <= maxPage
    }
}
