//
//  SearchParameters.swift
//  Dishwashers
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

struct SearchParameters {
    let pageSize = 20
    let query = "dishwasher"
    let pageNumber: Int

    func nextPage() -> SearchParameters {
        return SearchParameters(pageNumber: pageNumber + 1)
    }

    static func firstPage() -> SearchParameters {
        return SearchParameters(pageNumber: 1)
    }
}
