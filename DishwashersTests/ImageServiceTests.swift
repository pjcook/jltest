//
//  ImageServiceTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ImageServiceTests: XCTestCase {
    private var imageService: ImageServiceProtocol!

    override func setUp() {
        imageService = ImageService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_download_image_success() {
        XCTFail()
    }
    
    func test_download_image_missing() {
        XCTFail()
    }
    
    func test_download_image_invalidDat() {
        XCTFail()
    }

}
