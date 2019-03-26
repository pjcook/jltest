//  Copyright © 2019 Software101. All rights reserved.

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet private(set) var collectionView: UICollectionView!
    @IBOutlet private(set) var loadingLabel: UILabel!
    private var numberOfColumns = 2
    private let minimumCellWidth: Float = 150
    private let cellHeight: CGFloat = 350
    private let cellSpacing: CGFloat = 0.5

    var viewModel: ProductListViewModel!
    private var cellSize: CGSize = .zero

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

    private func calculateCellWidth(containerWidth: Float, cellPadding: Float, minCellWidth: Float) -> Float {
        let numberOfColumns = Float(floor(containerWidth / (minCellWidth + cellPadding)))
        let availableWidth = Float(containerWidth - ((numberOfColumns - 1) * cellPadding))
        let cellWidth = availableWidth / numberOfColumns
        self.numberOfColumns = Int(numberOfColumns)
        return cellWidth
    }

    private func refreshCellSize() {
        let maxWidth = Float(collectionView.frame.width)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = CGFloat(calculateCellWidth(containerWidth: maxWidth, cellPadding: Float(cellSpacing), minCellWidth: minimumCellWidth))
            if cellWidth != flowLayout.itemSize.width {
                cellSize = CGSize(width: cellWidth, height: cellHeight)
                flowLayout.invalidateLayout()
            }
        }
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
        let paddingSpace = cellSpacing * CGFloat(numberOfColumns - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        var widthPerItem = availableWidth / CGFloat(numberOfColumns)
        if widthPerItem < CGFloat(minimumCellWidth) {
            numberOfColumns -= 1
        }
        widthPerItem = availableWidth / CGFloat(numberOfColumns)

        return CGSize(width: widthPerItem, height: cellHeight)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return cellSpacing
    }
}
