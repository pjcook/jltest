//
//  ViewControllerTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ViewControllerTests: XCTestCase {
    private var viewController: ViewController!
    private var testsViewModel = TestsBasicViewModel()
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController = vc
        viewController.apiService = testsViewModel.apiService
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }

    override func tearDown() {}

    func test_load_viewController() {
        let expectation = self.expectation(description: "Wait for response")
        testsViewModel.session.responseData = TestData.searchValidResponse()
        testsViewModel.session.httpResponse = TestHTTPResponses.valid()
        testsViewModel.pendingExpectation = expectation
        
        let view = viewController.view
        viewController.viewDidAppear(false)
        XCTAssertNotNil(view)
        XCTAssertNotNil(viewController.presentedViewController)

        guard let nc = viewController.presentedViewController as? UINavigationController,
            let vc = nc.viewControllers.first as? ProductListViewController else {
                XCTFail()
                return
        }
        
        _ = vc.view
        vc.viewModel.delegate = self

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertFalse(vc.viewModel.viewData.productItems.isEmpty)
    }
}

extension ViewControllerTests: ViewModelDelegate {
    func reloadViewData() {
        testsViewModel.pendingExpectation?.fulfill()
        testsViewModel.pendingExpectation = nil
    }
}
