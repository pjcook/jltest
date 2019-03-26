//
//  StylesTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 19/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

@testable import Dishwashers
import XCTest

class StylesTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func test_check_colors() {
        XCTAssertNotNil(UIColor.textDefault)
        XCTAssertNotNil(UIColor.textHighlight)
        XCTAssertNotNil(UIColor.uiTint)
    }
}
