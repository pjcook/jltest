//
//  ProductListViewControllerTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class MockProductListViewModel: ProductListViewModel {
    var loadPageCalled = false
    var loadPageCalledCount = 0
    var viewModelForCellCalled = false
    var didSelectItemCalled = false
    
    override func loadPage() {
        loadPageCalled = true
        let currentlyLoading = viewData.isLoading
        super.loadPage()
        if !currentlyLoading && viewData.isLoading {
            loadPageCalledCount += 1
        }
    }
    
    override func viewModelForCell(at index: Int) -> ProductListCellViewModel {
        viewModelForCellCalled = true
        return super.viewModelForCell(at: index)
    }
    
    override func didSelectItem(_ index: Int, viewController: UIViewController) {
        didSelectItemCalled = true
        super.didSelectItem(index, viewController: viewController)
    }
}

class ProductListViewControllerTests: XCTestCase {
    private var viewModel: MockProductListViewModel!
    private var viewController: ProductListViewController!
    private var testsViewModel = TestsBasicViewModel()
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
        viewController = vc
        viewModel = MockProductListViewModel(apiService: testsViewModel.apiService)
        viewController.viewModel = viewModel
        viewController.viewModel.delegate = viewController
    }
    
    override func tearDown() {}

    func test_viewController_not_nil() {
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.view)
        XCTAssertNotNil(viewController.viewModel.delegate)
        XCTAssertTrue(viewModel.loadPageCalled)
    }
    
    func test_viewController_loading_page_data() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchValidResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.pendingExpectation = expectation
        
        // cause viewDidLoad to be called
        _ = viewController.view
        viewModel.delegate = self

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        viewController.reloadViewData()
        XCTAssertTrue(testsViewModel.session.taskComplete)
        XCTAssertFalse(testsViewModel.session.taskCompleteWithError)
        XCTAssertTrue(viewModel.loadPageCalled)
        
        let collectionViewItemCount = viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(collectionViewItemCount, 20)
    }
    
    func test_viewController_loading_cell_with_data() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchValidResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.pendingExpectation = expectation
        
        // cause viewDidLoad to be called
        _ = viewController.view
        viewModel.delegate = self
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        viewController.reloadViewData()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: indexPath) as! ProductListCell
        XCTAssertNotNil(cell)
        XCTAssertTrue(viewModel.viewModelForCellCalled)
        
        let productItem = viewModel.viewData.productItems[indexPath.row]
        XCTAssertEqual(cell.productTitle.text, productItem.title)
    }
    
    func test_viewController_select_cell_with_data() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchValidResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.pendingExpectation = expectation
        
        // cause viewDidLoad to be called
        _ = viewController.view
        viewModel.delegate = self
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        viewController.reloadViewData()
        let indexPath = IndexPath(row: 0, section: 0)
        viewController.collectionView(viewController.collectionView, didSelectItemAt: indexPath)
        XCTAssertTrue(viewModel.didSelectItemCalled)
    }
    
    func test_viewModel_loadPage_doesnt_load_while_already_loading() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchValidResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.pendingExpectation = expectation
        
        _ = viewController.view
        viewModel.delegate = self
        viewModel.loadPage()
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertEqual(1, viewModel.loadPageCalledCount)
    }
}

extension ProductListViewControllerTests: ViewModelDelegate {
    func reloadViewData() {
        testsViewModel.pendingExpectation?.fulfill()
        testsViewModel.pendingExpectation = nil
    }
}
