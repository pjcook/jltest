//
//  ImageGalleryViewTests.swift
//  DishwashersTests
//
//  Created by PJ COOK on 19/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ImageGalleryViewTests: XCTestCase {
    private var testsViewModel = TestsBasicViewModel()
    private var galleryView: ImageGalleryView!
    
    override func setUp() {
        galleryView = ImageGalleryView()
        galleryView.awakeFromNib()
    }

    override func tearDown() {}

    func test_view_loads() {
        XCTAssertNotNil(galleryView)
        XCTAssertNotNil(galleryView.subviews.first)
        XCTAssertTrue(galleryView.frame.width > 0)
        XCTAssertTrue(galleryView.frame.height > 0)
    }
    
    func test_load_viewModel() {
        let viewModel = ImageGalleryViewModel(apiService: testsViewModel.apiService, urls: ["abc", "def"])
        galleryView.configure(viewModel: viewModel)
        
        XCTAssertEqual(viewModel.numberOfItems, 2)
    }
    
    func test_viewModel_create_imageCellViewModel() {
        let viewModel = ImageGalleryViewModel(apiService: testsViewModel.apiService, urls: ["abc", "def"])
        galleryView.configure(viewModel: viewModel)
        
        let cellViewModel = viewModel.viewModel(for: 0)
        XCTAssertEqual("abc", cellViewModel.viewData.url)
        XCTAssertNil(cellViewModel.viewData.image)
        XCTAssertFalse(cellViewModel.viewData.isLoadingImage)
    }
    
    func test_load_viewModel_no_images() {
        let viewModel = ImageGalleryViewModel(apiService: testsViewModel.apiService, urls: [])
        galleryView.configure(viewModel: viewModel)
        
        XCTAssertEqual(viewModel.numberOfItems, 0)
    }
}
