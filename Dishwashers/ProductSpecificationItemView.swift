//
//  ProductSpecificationItemView.swift
//  Dishwashers
//
//  Created by PJ COOK on 19/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

struct ProductSpecificationItemViewData {
    let name: String
    let value: String
}

class ProductSpecificationItemView: UIView {
    @IBOutlet private var name: UILabel!
    @IBOutlet private var value: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }

    func configure(viewData: ProductSpecificationItemViewData) {
        name.text = viewData.name
        value.text = viewData.value
    }
}
