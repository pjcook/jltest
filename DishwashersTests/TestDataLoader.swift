//
//  TestDataLoader.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class TestHTTPResponses {
    static func valid() -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: Configuration().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    static func serverError() -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: Configuration().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    }
}

class TestData {
    static func validImageData() -> Data {
        guard let data = FileLoader.loadTestData(filename: "Product Grid", withExtension: "PNG") else {
            preconditionFailure("Failed to load test data")
        }
        
        return data
    }
    
    static func searchAuthError() -> Data {
        guard let data = FileLoader.loadTestData(filename: "search-auth-error-response") else {
            preconditionFailure("Failed to load test data")
        }
        
        return data
    }
    
    static func searchValidResponse() -> Data {
        guard let data = FileLoader.loadTestData(filename: "search-valid-response") else {
            preconditionFailure("Failed to load test data")
        }
        
        return data
    }
    
    static func productDetailValidResponse() -> Data {
        guard let data = FileLoader.loadTestData(filename: "product-search-response") else {
            preconditionFailure("Failed to load test data")
        }
        
        return data
    }
}

class TestDataLoader {
    static func feedSearchResults() -> FeedSearchResults {
        let data = TestData.searchValidResponse()
        
        guard let results = FeedSearchResults.processNetworkData(data: data) else {
            preconditionFailure("Failed to create FeedSearchResults")
        }
        
        return results
    }
    
    static func validFeedProductItem() -> FeedProductItem {
        let results = feedSearchResults()
        guard let productItem = results.products.first else {
            preconditionFailure("Failed to create FeedProductItem")
        }
        
        return productItem
    }
    
    static func validProductItem() -> ProductItem {
        let data = TestData.productDetailValidResponse()
        
        guard let productItem = ProductItem.processNetworkData(data: data) else {
            preconditionFailure("Failed to create ProductItem")
        }
        
        return productItem
    }
}
