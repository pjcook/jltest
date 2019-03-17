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
    func test_searchParameters() {
        let page1 = SearchParameters.firstPage()
        let page2 = page1.nextPage()
        XCTAssertEqual(page1.pageNumber + 1, page2.pageNumber)
    }
    
    func test_feedSearchResults_processNetworkData_nil_data() {
        let results = FeedSearchResults.processNetworkData(data: nil)
        XCTAssertNil(results)
    }
    
    func test_feedSearchResults_processNetworkData_invalidData() {
        guard let data = FileLoader.loadTestData(filename: "search-auth-error-response") else {
            XCTFail("Failed to load test data")
            return
        }
        
        let results = FeedSearchResults.processNetworkData(data: data)
        XCTAssertNil(results)
    }

    func test_parse_feedSearchResults_data() {
        guard let data = FileLoader.loadTestData(filename: "search-valid-response") else {
            XCTFail("Failed to load test data")
            return
        }
        
        let results = FeedSearchResults.processNetworkData(data: data)
        XCTAssertNotNil(results)
        
        guard let searchResults = results else { return }
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
    }
    
    func test_parse_productItem_processNetworkData_nil_data() {
        let result = ProductItem.processNetworkData(data: nil)
        XCTAssertNil(result)
    }
    
    func test_locale_extension() {
        let currencyCode = "GBP"
        let locale = Locale.locale(from: currencyCode)
        XCTAssertNotNil(locale)
        XCTAssertEqual("£", locale?.currencySymbol)
    }
    
    func test_locale_extension_cache() {
        let currencyCode = "GBP"
        let locale1 = Locale.locale(from: currencyCode)
        let locale2 = Locale.locale(from: currencyCode)
        XCTAssertNotNil(locale1)
        XCTAssertEqual("£", locale1?.currencySymbol)
        XCTAssertEqual(locale1, locale2)
    }
    
    func test_locale_extension_with_invalid_currencyCode() {
        let currencyCode = "XXX"
        let locale = Locale.locale(from: currencyCode)
        XCTAssertNil(locale)
    }
    
    func test_parse_productItem_processNetworkData_invalidData() {
        guard let data = FileLoader.loadTestData(filename: "search-auth-error-response") else {
            XCTFail("Failed to load test data")
            return
        }
        
        let result = ProductItem.processNetworkData(data: data)
        XCTAssertNil(result)
    }
    
    func test_parse_productItem_data() {
        guard let data = FileLoader.loadTestData(filename: "product-search-response") else {
            XCTFail("Failed to load test data")
            return
        }
        
        let result = ProductItem.processNetworkData(data: data)
        XCTAssertNotNil(result)
        
        guard let product = result else { return }
        
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
        XCTAssertEqual("88701324", product.code)    }

}
