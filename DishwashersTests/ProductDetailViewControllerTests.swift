//
//  ProductDetailViewControllerTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class MockProductDetailViewModel: ProductDetailViewModel {
    
}

class ProductDetailViewControllerTests: XCTestCase {
    private var viewData: ProductDetailViewData!
    private var viewModel: MockProductDetailViewModel!
    private var viewController: ProductDetailViewController!
    private var testsViewModel = TestsBasicViewModel()
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        viewController = vc
        
        viewData = ProductDetailViewData(isLoading: false, product: TestDataLoader.validProductItem())
        viewModel = MockProductDetailViewModel(viewData: viewData, apiService: testsViewModel.apiService)
        viewController.viewModel = viewModel
        viewController.viewModel.delegate = viewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
