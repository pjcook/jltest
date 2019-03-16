//
//  ApiServiceTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ApiServiceTests: XCTestCase {
    private var apiService: APIServiceProtocol!
    private var configuration: Configuration!
    private var session: MockURLSession!

    override func setUp() {
        configuration = Configuration()
        session = MockURLSession()
        apiService = APIService(configuration: configuration, session: session)
    }

    override func tearDown() {}
}

// MARK:- searchFeed tests
extension ApiServiceTests {
    func test_searchFeed_returns_task() {
        let parameters = SearchParameters(pageNumber: 1)
        let task = apiService.searchFeed(search: parameters) { _ in }
        XCTAssertNotNil(task)
    }
    
    func test_searchFeed_from_api_success() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseData = FileLoader.loadTestData(filename: "search-valid-response")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let parameters = SearchParameters(pageNumber: 1)
        _ = apiService.searchFeed(search: parameters) { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTFail("\(error)")
            case let .success(data):
                XCTAssertNotNil(data)
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
    }
    
    func test_searchFeed_with_server_error_500() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseData = FileLoader.loadTestData(filename: "search-auth-error-response")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        let parameters = SearchParameters(pageNumber: 1)
        _ = apiService.searchFeed(search: parameters) { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .networkError)
            case .success:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
    }
    
    func test_searchFeed_with_invalid_response() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseData = FileLoader.loadTestData(filename: "search-valid-response")
        let parameters = SearchParameters(pageNumber: 1)
        _ = apiService.searchFeed(search: parameters) { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .invalidResponse)
            case .success:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
    }
    
    func test_searchFeed_with_server_error() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseError = APIServiceError.networkError
        let parameters = SearchParameters(pageNumber: 1)
        _ = apiService.searchFeed(search: parameters) { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .networkError)
            case .success:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertTrue(session.taskCompleteWithError)
    }
    
    func test_searchFeed_failed_to_build_url() {
        let configuration = Configuration(baseURL: "https://api.johnlewis.com/v1/search.html?q=Aïn+Béïda+Algeria", apiKey: "")
        let apiService = APIService(configuration: configuration, session: session)
        let parameters = SearchParameters(pageNumber: 1)
        _ = apiService.searchFeed(search: parameters) { response in
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .failedToBuildURL)
            case .success:
                XCTFail()
            }
        }
    }
}

// MARK:- productDetails tests
extension ApiServiceTests {
    func test_productDetails_returns_task() {
        let task = apiService.productDetails(productID: "abc") { _ in }
        XCTAssertNotNil(task)
    }
    
    func test_productDetails_from_api_success() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseData = FileLoader.loadTestData(filename: "product-search-response")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        _ = apiService.productDetails(productID: "abc") { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTFail("\(error)")
            case let .success(data):
                XCTAssertNotNil(data)
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
    }
    
    func test_productDetails_with_server_error_500() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseData = FileLoader.loadTestData(filename: "product-search-invalid-productid-response")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        _ = apiService.productDetails(productID: "abc") { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .networkError)
            case .success:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
    }
    
    func test_productDetails_with_invalid_response() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseData = FileLoader.loadTestData(filename: "product-search-response")
        _ = apiService.productDetails(productID: "abc") { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .invalidResponse)
            case .success:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
    }
    
    func test_productDetails_with_server_error() {
        let expectation = self.expectation(description: "Wait for response")
        session.responseError = APIServiceError.networkError
        _ = apiService.productDetails(productID: "abc") { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .networkError)
            case .success:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(session.taskComplete)
        XCTAssertTrue(session.taskCompleteWithError)
    }
    
    func test_productDetails_failed_to_build_url() {
        let configuration = Configuration(baseURL: "https://api.johnlewis.com/v1/search.html?q=Aïn+Béïda+Algeria", apiKey: "")
        let apiService = APIService(configuration: configuration, session: session)
        _ = apiService.productDetails(productID: "abc") { response in
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .failedToBuildURL)
            case .success:
                XCTFail()
            }
        }
    }
}

// MARK:- downloadImage tests
extension ApiServiceTests {
    func test_download_valid_image() {
        let expectation = self.expectation(description: "Wait for response")
        let url = FileLoader.url(forResource: "Product Grid", withExtension: "PNG")!
        session.responseData = FileLoader.loadTestData(filename: "Product Grid", withExtension: "PNG")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        _ = apiService.downloadImage(url: url) { response in
            expectation.fulfill()
            switch response {
            case .failure:
                XCTFail()
            case let .success(data):
                XCTAssertNotNil(data)
                if let data = data {
                    let image = UIImage(data: data)
                    XCTAssertNotNil(image)
                }
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
    }
    
    func test_download_image_no_image() {
        let expectation = self.expectation(description: "Wait for response")
        let url = FileLoader.url(forResource: "Product Grid", withExtension: "PNG")!
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        _ = apiService.downloadImage(url: url) { response in
            expectation.fulfill()
            switch response {
            case .failure:
                XCTFail()
            case let .success(data):
                XCTAssertNil(data)
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
    }
    
    func test_download_image_with_server_error() {
        let expectation = self.expectation(description: "Wait for response")
        let url = FileLoader.url(forResource: "Product Grid", withExtension: "PNG")!
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        _ = apiService.downloadImage(url: url) { response in
            expectation.fulfill()
            switch response {
            case let .failure(error):
                XCTAssertEqual(error as! APIServiceError, .networkError)
            case .success:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
    }
    
    func test_download_image_invalid_data() {
        let expectation = self.expectation(description: "Wait for response")
        let url = FileLoader.url(forResource: "search-auth-error-response", withExtension: "json")!
        session.responseData = FileLoader.loadTestData(filename: "search-auth-error-response")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        _ = apiService.downloadImage(url: url) { response in
            expectation.fulfill()
            switch response {
            case .failure:
                XCTFail()
            case let .success(data):
                XCTAssertNotNil(data)
                if let data = data {
                    let image = UIImage(data: data)
                    XCTAssertNil(image)
                }
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
    }
}
