//
//  ProductListCellTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ProductListCellTests: XCTestCase {
    var cell: ProductListCell!

    override func setUp() {
        cell = ProductListCell()
        cell.xibSetup(nibName: "ProductListCell", bundle: Bundle(for: ProductListCellTests.self))
    }

    override func tearDown() {}

    func test_check_cell_not_nil() {
        XCTAssertNotNil(cell)
    }
}
