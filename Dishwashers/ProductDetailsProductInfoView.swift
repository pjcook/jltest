//  Copyright © 2019 Software101. All rights reserved.

import UIKit

struct ProductDetailsProductInfoViewData {
    let productCode: String
    let productDescription: String
}

protocol ProductDetailsProductInfoViewDelegate: class {
    func readMoreClicked()
}

class ProductDetailsProductInfoView: UIView {
    @IBOutlet private var productCode: UILabel!
    @IBOutlet private var productDescription: UILabel!
    weak var delegate: ProductDetailsProductInfoViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }

    func configure(viewData: ProductDetailsProductInfoViewData) {
        productCode.text = viewData.productCode
        productDescription.text = viewData.productDescription.htmlToString
    }

    @IBAction private func readMoreClicked() {
        delegate?.readMoreClicked()
    }
}
