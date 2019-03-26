//  Copyright © 2019 Software101. All rights reserved.

@testable import Dishwashers
import XCTest

class MockProductDetailViewModel: ProductDetailViewModel {
    var loadDetailsCalled = false
    var loadDetailsCalledCount = 0

    override func loadDetails() {
        loadDetailsCalled = true
        let currentlyLoading = viewData.isLoading
        super.loadDetails()
        if !currentlyLoading, viewData.isLoading {
            loadDetailsCalledCount += 1
        }
    }
}

class ProductDetailViewControllerTests: XCTestCase {
    private var viewData: ProductDetailViewData!
    private var viewModel: MockProductDetailViewModel!
    private var viewController: ProductDetailViewController!
    private var testsViewModel = TestsBasicViewModel()

    override func setUp() {
        let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        viewController = vc

        viewData = ProductDetailViewData(isLoading: false, product: TestDataLoader.validProductItem())
        viewModel = MockProductDetailViewModel(viewData: viewData, maximumGalleryHeight: 375, apiService: testsViewModel.apiService)
        viewController.viewModel = viewModel
        viewController.viewModel.delegate = viewController
    }

    override func tearDown() {}

    func test_viewController_basic_load() {
        viewController.view.setNeedsLayout()
        viewController.view.layoutIfNeeded()
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.view)
        XCTAssertNotNil(viewController.viewModel.delegate)
        XCTAssertTrue(viewModel.loadDetailsCalled)
    }

    func test_viewModel_loading_details_success() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.productDetailValidUpdatedTitleResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        let initialTitle = viewModel.viewData.product.title

        XCTAssertFalse(viewModel.viewData.isLoading)
        viewModel.delegate = self
        viewModel.loadDetails()
        testsViewModel.pendingExpectation = expectation
        XCTAssertTrue(viewModel.viewData.isLoading)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        XCTAssertNotEqual(initialTitle, viewModel.viewData.product.title)
        XCTAssertTrue(viewModel.loadDetailsCalled)
    }

    func test_viewModel_loadDetails_doesnt_load_while_already_loading() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.productDetailValidUpdatedTitleResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()

        XCTAssertFalse(viewModel.viewData.isLoading)
        viewModel.delegate = self
        viewModel.loadDetails()
        testsViewModel.pendingExpectation = expectation
        viewModel.loadDetails()
        XCTAssertTrue(viewModel.viewData.isLoading)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        XCTAssertEqual(viewModel.loadDetailsCalledCount, 1)
        XCTAssertTrue(viewModel.loadDetailsCalled)
    }

    func test_viewModel_loading_details_failure() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchAuthError()
        testsViewModel.session.httpResponse = TestHTTPResponses.serverError()

        XCTAssertFalse(viewModel.viewData.isLoading)
        viewModel.delegate = self
        viewModel.loadDetails()
        testsViewModel.pendingExpectation = expectation
        XCTAssertTrue(viewModel.viewData.isLoading)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }

        XCTAssertTrue(viewModel.loadDetailsCalled)
    }
}

extension ProductDetailViewControllerTests: ViewModelDelegate {
    func reloadViewData() {
        testsViewModel.pendingExpectation?.fulfill()
        testsViewModel.pendingExpectation = nil
    }
}
