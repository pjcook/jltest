//  Copyright © 2019 Software101. All rights reserved.

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet private(set) var collectionView: UICollectionView!
    @IBOutlet private(set) var loadingLabel: UILabel!

    var viewModel: ProductListViewModel!
    var cellSizing = CellSizing() {
        didSet {
            refreshCellSize()
        }
    }

    private var cellSize: CGSize = .zero {
        didSet {
            guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            flowLayout.invalidateLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshState()
        viewModel.loadPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCellSize()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshCellSize()
    }
    
    private func refreshCellSize() {
        guard let collectionView = collectionView else { return }
        cellSize = cellSizing.refreshCellSize(width: Float(collectionView.frame.width))
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

// MARK: - UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.didSelectItem(indexPath.row, viewController: self)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.viewData.productItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as! ProductListCell
        let cellViewModel = viewModel.viewModelForCell(at: indexPath.row)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return cellSizing.cellSpacing
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return cellSizing.cellSpacing
    }
}
