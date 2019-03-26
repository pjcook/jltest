//
//  ProductListCell.swift
//  Dishwashers
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class ProductListCell: UICollectionViewCell {
    static let identifier = "ProductListCell"

    @IBOutlet private(set) var productImage: UIImageView!
    @IBOutlet private(set) var productTitle: UILabel!
    @IBOutlet private(set) var productPrice: UILabel!

    private var viewModel: ProductListCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }

    override func prepareForReuse() {
        viewModel?.prepareForReuse()
        productImage.image = nil
        productTitle.text = nil
        productPrice.text = nil
    }

    func configure(viewModel: ProductListCellViewModel) {
        self.viewModel = viewModel
        viewModel.delegate = self
        refreshState()
        viewModel.loadImage()
    }

    private func refreshState() {
        productTitle.text = viewModel?.viewData.item.title
        productPrice.text = viewModel?.viewData.item.price.nowFormatted

        UIView.transition(with: self, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.productImage.image = self.viewModel?.viewData.image
        }, completion: nil)
    }
}

extension ProductListCell: ViewModelDelegate {
    func reloadViewData() {
        refreshState()
    }
}
