//  Copyright © 2019 Software101. All rights reserved.

import UIKit

struct ProductDetailsProductSpecificationViewData {
    let productDetails: ProductDetails

    func productSpecificationItemViewData(from attribute: FeatureAttribute) -> ProductSpecificationItemViewData {
        return ProductSpecificationItemViewData(name: attribute.name, value: attribute.value)
    }
}

class ProductDetailsProductSpecificationView: UIView {
    @IBOutlet private var sectionTitle: UILabel!
    @IBOutlet private var stackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }

    func configure(viewData: ProductDetailsProductSpecificationViewData) {
        for arrangedView in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(arrangedView)
        }

        for feature in viewData.productDetails.features {
            for attribute in feature.attributes {
                let itemView = ProductSpecificationItemView()
                itemView.xibSetup()
                itemView.configure(viewData: viewData.productSpecificationItemViewData(from: attribute))
                stackView.addArrangedSubview(itemView)
            }
        }
    }
}
