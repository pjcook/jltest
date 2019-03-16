//
//  ApiServiceTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class MockURLSessionDataTask: URLSessionDataTask {
    private let identifier = Int(Date().timeIntervalSinceReferenceDate)
    override var taskIdentifier: Int {
        return identifier
    }
    
    override init() {}
    override func cancel() {}
    override func suspend() {}
    override func resume() {}
    
    public override var state: URLSessionTask.State {
        return URLSessionTask.State.suspended
    }
}

class MockURLSession: URLSession {
    var responseError: Error?
    var responseData: Data?
    var httpResponse: URLResponse?
    var testExpectation: XCTestExpectation?
    
    private(set) var taskComplete = false
    private(set) var taskCompleteWithError = false
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        DispatchQueue.main.async {
            self.taskComplete = true
            self.taskCompleteWithError = self.responseError != nil
            self.testExpectation?.fulfill()
            completionHandler(self.responseData, self.httpResponse, self.responseError)
        }
        return MockURLSessionDataTask()
    }
}

class ApiServiceTests: XCTestCase {
    private var apiService: APIServiceProtocol!
    private var configuration: Configuration!
    private var session: URLSession!

    override func setUp() {
        configuration = Configuration()
        session = MockURLSession()
        apiService = APIService(configuration: configuration, session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_searchFeed_returns_task() {
        let parameters = SearchParameters(pageNumber: 1)
        let task = apiService.searchFeed(search: parameters) { _ in }
        XCTAssertNotNil(task)
    }

    func test_searchFeed_from_api_success() {
        XCTFail()
    }
    
    func test_searchFeed_with_server_error() {
        XCTFail()
    }
    
    func test_productDetails_returns_task() {
        XCTFail()
    }
    
    func test_productDetails_from_api_success() {
        XCTFail()
    }
    
    func test_productDetails_with_server_error() {
        XCTFail()
    }
}
