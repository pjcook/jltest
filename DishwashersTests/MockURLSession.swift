//
//  MockURLSession.swift
//  DishwashersTests
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest

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

    override func dataTask(with _: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        DispatchQueue.main.async {
            self.taskComplete = true
            self.taskCompleteWithError = self.responseError != nil
            completionHandler(self.responseData, self.httpResponse, self.responseError)
            self.testExpectation?.fulfill()
        }
        return MockURLSessionDataTask()
    }
}
