//
//  ProductListCellTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class MockProductListCellViewModel: ProductListCellViewModel {
    var prepareForReuseCalled = false
    var loadImageCalled = false
    
    override func prepareForReuse() {
        prepareForReuseCalled = true
        super.prepareForReuse()
    }
    
    override func loadImage() {
        loadImageCalled = true
        super.loadImage()
    }
}

class ProductListCellTests: XCTestCase {
    private var cell: ProductListCell!
    private var apiService: APIServiceProtocol!
    private var configuration: Configuration!
    private var session: MockURLSession!
    
    override func setUp() {
        configuration = Configuration()
        session = MockURLSession()
        apiService = APIService(configuration: configuration, session: session)

        cell = ProductListCell()
        cell.xibSetup(nibName: "ProductListCell", bundle: Bundle(for: ProductListCellTests.self))
    }

    override func tearDown() {}

    func test_check_cell_not_nil() {
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.productImage)
        XCTAssertNotNil(cell.productTitle)
        XCTAssertNotNil(cell.productPrice)
    }
    
    func test_configure_cell() {
        guard let data = FileLoader.loadTestData(filename: "search-valid-response"),
            let productItem = FeedSearchResults.processNetworkData(data: data)?.products.first
        else {
            XCTFail("Failed to load test data")
            return
        }
        
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        let viewModel = ProductListCellViewModel(viewData: viewData, apiService: apiService)
        cell.configure(viewModel: viewModel)
        XCTAssertEqual(cell.productTitle.text, productItem.title)
        XCTAssertEqual(cell.productPrice.text, viewData.price)
        XCTAssertNil(cell.productImage.image)
    }
    
    func test_configure_cell_load_image() {
        guard let data = FileLoader.loadTestData(filename: "search-valid-response"),
            let productItem = FeedSearchResults.processNetworkData(data: data)?.products.first
            else {
                XCTFail("Failed to load test data")
                return
        }
        let expectation = self.expectation(description: "Wait for response")
        session.responseData = FileLoader.loadTestData(filename: "Product Grid", withExtension: "PNG")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.testExpectation = expectation
        
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        let viewModel = MockProductListCellViewModel(viewData: viewData, apiService: apiService)
        cell.configure(viewModel: viewModel)
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertEqual(cell.productTitle.text, productItem.title)
        XCTAssertEqual(cell.productPrice.text, viewData.price)
        XCTAssertTrue(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
        XCTAssertTrue(viewModel.loadImageCalled)
    }
    
    func test_prepareForReuse() {
        let productItem = FeedProductItem(productId: "abc", price: Price(was: "", now: "", currency: ""), title: "title", image: "")
        session.responseData = FileLoader.loadTestData(filename: "Product Grid", withExtension: "PNG")
        session.httpResponse = HTTPURLResponse(url: URL(string: configuration.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        let viewModel = MockProductListCellViewModel(viewData: viewData, apiService: apiService)
        cell.configure(viewModel: viewModel)
        cell.prepareForReuse()
        
        XCTAssertNil(cell.productTitle.text)
        XCTAssertNil(cell.productPrice.text)
        XCTAssertNil(cell.productImage.image)
        XCTAssertFalse(session.taskComplete)
        XCTAssertFalse(session.taskCompleteWithError)
        XCTAssertTrue(viewModel.prepareForReuseCalled)
    }
    
    func test_viewData_empty_price() {
        let productItem = FeedProductItem(productId: "abc", price: Price(was: "", now: "", currency: ""), title: "title", image: "")
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        XCTAssertTrue(viewData.price.isEmpty)
    }
    
    func test_viewData_price_with_invalid_currency() {
        let productItem = FeedProductItem(productId: "abc", price: Price(was: "", now: "60", currency: ""), title: "title", image: "")
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        XCTAssertEqual("60", viewData.price)
    }
}
