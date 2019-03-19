//
//  ImageGalleryCell.swift
//  Dishwashers
//
//  Created by PJ COOK on 18/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class ImageGalleryCell: UICollectionViewCell {
    @IBOutlet private var productImage: UIImageView!
    
    private var viewModel: ImageGalleryCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.prepareForReuse()
        productImage.image = nil
    }
    
    func configure(_ viewModel: ImageGalleryCellViewModel) {
        self.viewModel = viewModel
        refreshState()
        viewModel.loadImage()
    }
    
    private func refreshState() {
        UIView.transition(with: self, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.productImage.image = self.viewModel?.viewData.image
        }, completion: nil)
    }
}

extension ImageGalleryCell: ViewModelDelegate {
    func reloadViewData() {
        refreshState()
    }
}
