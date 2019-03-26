//
//  ProductListCellTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

@testable import Dishwashers
import XCTest

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
    private var testsViewModel = TestsBasicViewModel()

    override func setUp() {
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
        let productItem = TestDataLoader.validFeedProductItem()
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        let viewModel = ProductListCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        cell.configure(viewModel: viewModel)
        XCTAssertEqual(cell.productTitle.text, productItem.title)
        XCTAssertEqual(cell.productPrice.text, viewData.item.price.nowFormatted)
        XCTAssertNil(cell.productImage.image)
    }

    func test_configure_cell_load_image() {
        let productItem = TestDataLoader.validFeedProductItem()
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.validImageData()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.session.testExpectation = expectation

        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        let viewModel = MockProductListCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        cell.configure(viewModel: viewModel)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        XCTAssertEqual(cell.productTitle.text, productItem.title)
        XCTAssertEqual(cell.productPrice.text, viewData.item.price.nowFormatted)
        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
        XCTAssertTrue(viewModel.loadImageCalled)
    }

    func test_prepareForReuse() {
        let productItem = FeedProductItem(productId: "abc", price: Price(was: "", now: "", currency: ""), title: "title", image: "")
        testsViewModel.session.responseData = TestData.validImageData()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()

        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        let viewModel = MockProductListCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        cell.configure(viewModel: viewModel)
        cell.prepareForReuse()

        XCTAssertNil(cell.productTitle.text)
        XCTAssertNil(cell.productPrice.text)
        XCTAssertNil(cell.productImage.image)
        XCTAssertFalse(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
        XCTAssertTrue(viewModel.prepareForReuseCalled)
    }

    func test_viewData_empty_price() {
        let productItem = FeedProductItem(productId: "abc", price: Price(was: "", now: "", currency: ""), title: "title", image: "")
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        XCTAssertTrue(viewData.item.price.nowFormatted.isEmpty)
    }

    func test_viewData_price_with_invalid_currency() {
        let productItem = FeedProductItem(productId: "abc", price: Price(was: "", now: "60", currency: ""), title: "title", image: "")
        let viewData = ProductListCellViewData(item: productItem, image: nil, isLoadingImage: false)
        XCTAssertEqual("60", viewData.item.price.nowFormatted)
    }
}
