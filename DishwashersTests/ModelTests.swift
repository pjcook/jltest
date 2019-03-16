//
//  ModelTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_parse_feedSearchResults_data() {
        guard let data = FileLoader.loadTestData(filename: "search-valid-response") else {
            XCTFail("Failed to load test data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let searchResults = try decoder.decode(FeedSearchResults.self, from: data)
            XCTAssertNotNil(searchResults)
            XCTAssertEqual(189, searchResults.results)
            XCTAssertEqual(10, searchResults.pagesAvailable)
            XCTAssertEqual(20, searchResults.products.count)
            
            let product = searchResults.products.first!
            XCTAssertEqual("3294410", product.productId)
            XCTAssertEqual("Neff S513M60X1G Integrated Dishwasher, Stainless Steel", product.title)
            XCTAssertEqual("//johnlewis.scene7.com/is/image/JohnLewis/237048107?", product.image)
            XCTAssertEqual("", product.price.was)
            XCTAssertEqual("660.00", product.price.now)
            XCTAssertEqual("GBP", product.price.currency)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_parse_productItem_data() {
        guard let data = FileLoader.loadTestData(filename: "product-search-response") else {
            XCTFail("Failed to load test data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(ProductItem.self, from: data)
            XCTAssertNotNil(product)
            XCTAssertEqual("3294410", product.productId)
            XCTAssertEqual("Neff S513M60X1G Integrated Dishwasher, Stainless Steel", product.title)
            XCTAssertEqual(8, product.media.images.urls.count)
            XCTAssertEqual("660.00", product.price.now)
            XCTAssertEqual("", product.price.was)
            XCTAssertEqual("GBP", product.price.currency)
            XCTAssertEqual("<p>Enjoy cooking and your meal even more with the knowledge that washing up wonâ€™t be an issue, thanks to the Neff S513M60X1GIntegrated Dishwasher. The dishwasher has an A++ Energy Rating, as well as housing loads of technology, so it can care for the environment as well as your crockery.</p>\n\n<p>The Neff S513K60X1Gâ€™s curved, alternating spray arms, large spray head, six programmes and five cleaning temperatures, along with its efficient SilentDrive motor will ensure, no matter your wash requirements, that your glasses and dishes will be washed efficiently and quietly to perfection.</p> \n\n<p>For your convenience, the S513K60X1G has a helpful red InfoLight, which beams onto your floor, letting you know that you the dishwasher is operating.<p>\n\n<p>Easy to use push button controls, as well as an informative digital display panel, are all neatly hidden on top of the door.</p>\n\n<p><strong>Key features:</strong><br>\n<ul>\n<li>Childproof Door lock</li>   \n<li>Three special options: VarioSpeedPlus, HygienePlus, Extra Dry</li>   \n<li>White interior EmotionLight</li>   \n<li>NeffSparkle - glass care system</li>   \n\n<li>Three stage, Rackmatic height-adjustable top basket</li>   \n<li>Delay timer (1 â€“ 24 hours)</li>   \n<li>Water fault indicator</li>\n<li>Acoustic end of cycle indicator</li>\n<li>Self-cleaning filter system </li>\n</ul>\n", product.details.productInformation)
            XCTAssertEqual(1, product.details.features.count)
            XCTAssertEqual("Claim Â£50 cashback (via redemption)", product.displaySpecialOffer)
            XCTAssertEqual(1, product.additionalServices.includedServices.count)
            XCTAssertEqual("88701324", product.code)
        } catch {
            XCTFail("\(error)")
        }
    }

}
