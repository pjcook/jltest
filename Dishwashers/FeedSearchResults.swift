//
//  FeedSearchResults.swift
//  Dishwashers
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct FeedSearchResults: Codable {
    let products: [FeedProductItem]
    let results: Int
    let pagesAvailable: Int
}
