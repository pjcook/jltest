//
//  ImageGalleryCellTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 19/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

@testable import Dishwashers
import XCTest

class ImageGalleryCellTests: XCTestCase {
    private var testsViewModel = TestsBasicViewModel()
    private var cell: ImageGalleryCell!
    private var reloadViewDataCalled = false

    override func setUp() {
        cell = ImageGalleryCell()
        cell.xibSetup(nibName: "ImageGalleryCell", bundle: Bundle(for: ImageGalleryCellTests.self))
    }

    override func tearDown() {}

    func test_cell_loaded() {
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.productImage)
    }

    func test_configure() {
        let viewData = ImageGalleryCellViewData(url: "https://apple.com", image: nil, isLoadingImage: false)
        let viewModel = ImageGalleryCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        viewModel.delegate = cell
        cell.configure(viewModel)

        XCTAssertNil(cell.productImage.image)
    }

    func test_viewModel_calls_delegate_reloadViewData_during_loadImage() {
        let viewData = ImageGalleryCellViewData(url: "https://apple.com", image: nil, isLoadingImage: false)
        let viewModel = ImageGalleryCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        viewModel.delegate = cell
        cell.configure(viewModel)

        XCTAssertNil(cell.productImage.image)
    }

    func test_url_without_http() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.pendingExpectation = expectation
        let viewData = ImageGalleryCellViewData(url: "//apple.com", image: nil, isLoadingImage: false)
        let viewModel = ImageGalleryCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        viewModel.delegate = cell
        cell.configure(viewModel)
        viewModel.delegate = self

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
        XCTAssertNil(viewModel.viewData.image)
    }

    func test_loading_image_success() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.validImageData()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.pendingExpectation = expectation
        let viewData = ImageGalleryCellViewData(url: "//apple.com", image: nil, isLoadingImage: false)
        let viewModel = ImageGalleryCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        viewModel.delegate = cell
        cell.configure(viewModel)
        viewModel.delegate = self

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
        XCTAssertNotNil(viewModel.viewData.image)
    }

    func test_loading_image_failed_response() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.validImageData()
        testsViewModel.session.httpResponse = TestHTTPResponses.serverError()
        testsViewModel.session.responseError = APIServiceError.networkError
        testsViewModel.pendingExpectation = expectation
        let viewData = ImageGalleryCellViewData(url: "//apple.com", image: nil, isLoadingImage: false)
        let viewModel = ImageGalleryCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        viewModel.delegate = cell
        cell.configure(viewModel)
        viewModel.delegate = self

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertTrue(testsViewModel.session.taskCompleteWithError)
        XCTAssertNil(viewModel.viewData.image)
    }

    func test_calling_prepareForReuse() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.validImageData()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.pendingExpectation = expectation
        let viewData = ImageGalleryCellViewData(url: "//apple.com", image: nil, isLoadingImage: false)
        let viewModel = ImageGalleryCellViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        viewModel.delegate = cell
        cell.configure(viewModel)
        viewModel.delegate = self

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        cell.prepareForReuse()

        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
        XCTAssertNotNil(viewModel.viewData.image)
        XCTAssertNil(cell.productImage.image)
    }
}

extension ImageGalleryCellTests: ViewModelDelegate {
    func reloadViewData() {
        reloadViewDataCalled = true
        testsViewModel.pendingExpectation?.fulfill()
        testsViewModel.pendingExpectation = nil
    }
}
