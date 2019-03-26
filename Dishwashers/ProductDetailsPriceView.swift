//
//  ProductDetailsPriceView.swift
//  Dishwashers
//
//  Created by PJ COOK on 19/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

struct ProductDetailsPriceViewData {
    let price: String
    let specialOffer: String
    let additionalServices: [String]
}

class ProductDetailsPriceView: UIView {
    @IBOutlet private var price: UILabel!
    @IBOutlet private var specialOffer: UILabel!
    @IBOutlet private var additionalServices: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }

    func configure(viewData: ProductDetailsPriceViewData) {
        price.text = viewData.price
        specialOffer.text = viewData.specialOffer

        for arrangedView in additionalServices.arrangedSubviews {
            additionalServices.removeArrangedSubview(arrangedView)
        }

        for service in viewData.additionalServices {
            let label = UILabel(frame: .zero)
            label.numberOfLines = 0
            label.text = service
            label.textColor = UIColor.textDefault
            label.font = UIFont.preferredFont(forTextStyle: .title3)

            additionalServices.addArrangedSubview(label)
        }
    }
}
