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
    @IBOutlet private var imageGalleryView: ImageGalleryView!
    @IBOutlet private var priceView: ProductDetailsPriceView!
    @IBOutlet private var productInformationView: ProductDetailsProductInfoView!
    @IBOutlet private var productSpecificationView: ProductDetailsProductSpecificationView!
    @IBOutlet private var imageGalleryHeightContraint: NSLayoutConstraint!
    
    // Portrait contraints
    @IBOutlet private var imageGalleryTrailingContraintPortrait: NSLayoutConstraint!
    @IBOutlet private var imageGalleryBottomContraintPortrait: NSLayoutConstraint!
    @IBOutlet private var productInformationTopContraintPortrait: NSLayoutConstraint!
    @IBOutlet private var productInformationTrailingContraintPortrait: NSLayoutConstraint!
    @IBOutlet private var productSpecificationTrailingContraintPortrait: NSLayoutConstraint!
    @IBOutlet private var priceLeadingContraintPortrait: NSLayoutConstraint!
    
    // Landscape contraints
    @IBOutlet private var imageGalleryTrailingContraintLandscape: NSLayoutConstraint!
    @IBOutlet private var productInformationTopContraintLandscape: NSLayoutConstraint!
    @IBOutlet private var productInformationTrailingContraintLandscape: NSLayoutConstraint!
    @IBOutlet private var productSpecificationTrailingContraintLandscape: NSLayoutConstraint!
    @IBOutlet private var priceTopContraintLandscape: NSLayoutConstraint!
    @IBOutlet private var priceBottomContraintLandscape: NSLayoutConstraint!
    @IBOutlet private var priceWidthContraintLandscape: NSLayoutConstraint!
    
    var viewModel: ProductDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshContraintsBasedOnDeviceLayout()
        refreshState()
        viewModel.loadDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageGalleryHeightContraint.constant = viewModel.maximumGalleryHeight
        refreshContraintsBasedOnDeviceLayout()
        imageGalleryView.layoutSubviews()
        priceView.layoutSubviews()
        productInformationView.layoutSubviews()
        productSpecificationView.layoutSubviews()
    }
    
    private func refreshContraintsBasedOnDeviceLayout() {
        imageGalleryTrailingContraintPortrait.isActive = !isIpadLandscape()
        imageGalleryBottomContraintPortrait.isActive = !isIpadLandscape()
        productInformationTopContraintPortrait.isActive = !isIpadLandscape()
        productInformationTrailingContraintPortrait.isActive = !isIpadLandscape()
        productSpecificationTrailingContraintPortrait.isActive = !isIpadLandscape()
        priceLeadingContraintPortrait.isActive = !isIpadLandscape()
        
        imageGalleryTrailingContraintLandscape.isActive = isIpadLandscape()
        productInformationTopContraintLandscape.isActive = isIpadLandscape()
        productInformationTrailingContraintLandscape.isActive = isIpadLandscape()
        productSpecificationTrailingContraintLandscape.isActive = isIpadLandscape()
        priceTopContraintLandscape.isActive = isIpadLandscape()
        priceBottomContraintLandscape.isActive = isIpadLandscape()
        priceWidthContraintLandscape.isActive = isIpadLandscape()
    }
    
    private func isIpadLandscape() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad && view.traitCollection.horizontalSizeClass == .regular && UIDevice.current.orientation.isLandscape
    }
    
    private func refreshState() {
        title = viewModel.viewData.product.title
        loadingLabel.isHidden = !viewModel.viewData.isLoading
        UIApplication.shared.isNetworkActivityIndicatorVisible = viewModel.viewData.isLoading
        imageGalleryView.configure(viewModel: viewModel.imageGalleryViewModel)
        priceView.configure(viewData: viewModel.priceViewData)
        productInformationView.configure(viewData: viewModel.productInformationViewData)
        productSpecificationView.configure(viewData: viewModel.productSpecificationViewData)
    }
}

extension ProductDetailViewController: ProductDetailsProductInfoViewDelegate {
    func readMoreClicked() {
        // TODO: handle this action
        print("read mode button clicked")
    }
}

extension ProductDetailViewController: ViewModelDelegate {
    func reloadViewData() {
        refreshState()
    }
}
