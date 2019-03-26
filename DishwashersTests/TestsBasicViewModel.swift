//
//  TestsBasicViewModel.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

@testable import Dishwashers
import XCTest

class TestsBasicViewModel {
    private(set) var apiService: APIServiceProtocol
    private(set) var configuration: Configuration
    private(set) var session: MockURLSession
    var pendingExpectation: XCTestExpectation?

    init() {
        configuration = Configuration()
        session = MockURLSession()
        apiService = APIService(configuration: configuration, session: session)
    }
}
