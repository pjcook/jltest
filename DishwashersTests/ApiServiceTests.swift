//  Copyright © 2019 Software101. All rights reserved.

@testable import Dishwashers
import XCTest

class ApiServiceTests: XCTestCase {
    private var testsViewModel = TestsBasicViewModel()

    override func setUp() {}
    override func tearDown() {}
}

// MARK: - searchFeed tests

extension ApiServiceTests {
    func test_searchFeed_returns_task() {
        let parameters = SearchParameters(pageNumber: 1)
        let task = testsViewModel.apiService.searchFeed(search: parameters) { _ in }
        XCTAssertNotNil(task)
    }

    func test_searchFeed_from_api_success() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchValidResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        let parameters = SearchParameters(pageNumber: 1)
        _ = testsViewModel.apiService.searchFeed(search: parameters) { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
    }

    func test_searchFeed_with_server_error_500() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchAuthError()
        testsViewModel.session.httpResponse = TestHTTPResponses.serverError()
        let parameters = SearchParameters(pageNumber: 1)
        _ = testsViewModel.apiService.searchFeed(search: parameters) { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
    }

    func test_searchFeed_with_invalid_response() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchValidResponse()
        let parameters = SearchParameters(pageNumber: 1)
        _ = testsViewModel.apiService.searchFeed(search: parameters) { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
    }

    func test_searchFeed_with_server_error() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseError = APIServiceError.networkError
        let parameters = SearchParameters(pageNumber: 1)
        _ = testsViewModel.apiService.searchFeed(search: parameters) { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertTrue(testsViewModel.session.taskCompleteWithError)
    }

    func test_searchFeed_failed_to_build_url() {
        let configuration = Configuration(baseURL: "https://api.johnlewis.com/v1/search.html?q=Aïn+Béïda+Algeria", apiKey: "")
        let apiService = APIService(configuration: configuration, session: testsViewModel.session)
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

// MARK: - productDetails tests

extension ApiServiceTests {
    func test_productDetails_returns_task() {
        let task = testsViewModel.apiService.productDetails(productID: "abc") { _ in }
        XCTAssertNotNil(task)
    }

    func test_productDetails_from_api_success() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.productDetailValidResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        _ = testsViewModel.apiService.productDetails(productID: "abc") { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
    }

    func test_productDetails_with_server_error_500() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = FileLoader.loadTestData(filename: "product-search-invalid-productid-response")
        testsViewModel.session.httpResponse = TestHTTPResponses.serverError()
        _ = testsViewModel.apiService.productDetails(productID: "abc") { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
    }

    func test_productDetails_with_invalid_response() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.productDetailValidResponse()
        _ = testsViewModel.apiService.productDetails(productID: "abc") { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
    }

    func test_productDetails_with_server_error() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseError = APIServiceError.networkError
        _ = testsViewModel.apiService.productDetails(productID: "abc") { response in
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

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertTrue(testsViewModel.session.taskCompleteWithError)
    }

    func test_productDetails_failed_to_build_url() {
        let configuration = Configuration(baseURL: "https://api.johnlewis.com/v1/search.html?q=Aïn+Béïda+Algeria", apiKey: "")
        let apiService = APIService(configuration: configuration, session: testsViewModel.session)
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

// MARK: - downloadImage tests

extension ApiServiceTests {
    func test_download_valid_image() {
        let expectation = self.expectation(description: "Wait for response")
        let url = FileLoader.url(forResource: "Product Grid", withExtension: "PNG")!
        testsViewModel.session.responseData = TestData.validImageData()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        _ = testsViewModel.apiService.downloadImage(url: url) { response in
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
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        _ = testsViewModel.apiService.downloadImage(url: url) { response in
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
        testsViewModel.session.httpResponse = TestHTTPResponses.serverError()
        _ = testsViewModel.apiService.downloadImage(url: url) { response in
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
        testsViewModel.session.responseData = TestData.searchAuthError()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        _ = testsViewModel.apiService.downloadImage(url: url) { response in
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
