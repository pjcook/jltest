//
//  FeedProductItem.swift
//  Dishwashers
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct Price: Codable {
    let was: String
    let now: String
    let currency: String
}

struct FeedProductItem: Codable {
    let productId: String
    let price: Price
    let title: String
    let image: String
}
