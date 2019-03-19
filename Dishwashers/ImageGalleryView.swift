//
//  ImageGalleryView.swift
//  Dishwashers
//
//  Created by PJ COOK on 18/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

struct ImageGalleryViewModel {
    let apiService: APIServiceProtocol
    let urls: [String]
    var numberOfItems: Int {
        return urls.count
    }
    
    func viewModel(for index: Int) -> ImageGalleryCellViewModel {
        let viewData = ImageGalleryCellViewData.init(url: urls[index], image: nil, isLoadingImage: false)
        return ImageGalleryCellViewModel(viewData: viewData, apiService: apiService)
    }
}

class ImageGalleryView: UIView {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var pageControl: UIPageControl!
    
    private var viewModel: ImageGalleryViewModel?
    private var numberOfItems: Int {
        return viewModel?.numberOfItems ?? 0
    }
    private var maximumGalleryHeight: CGFloat {
        return collectionView?.frame.height ?? 375
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    func configure(viewModel: ImageGalleryViewModel) {
        self.viewModel = viewModel
        refreshState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: min(collectionView.frame.width, maximumGalleryHeight))
        }
        collectionView.reloadData()
    }
    
    private func setUp() {
        xibSetup()
        let nib = UINib(nibName: "ImageGalleryCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageGalleryCell")
        collectionView.isPagingEnabled = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: min(collectionView.frame.width, maximumGalleryHeight))
        }
        collectionView.contentOffset = .zero
        collectionView.contentInset = .zero
    }
    
    private func refreshState() {
        collectionView.scrollRectToVisible(.zero, animated: false)
        pageControl.numberOfPages = numberOfItems
        pageControl.currentPage = 0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: min(collectionView.frame.width, maximumGalleryHeight))
        }
        collectionView.reloadData()
    }
    
    private func animateToCurrentPage() {
        let currentPage = pageControl.currentPage
        let offsetX = CGFloat(currentPage) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    @IBAction private func pageControlValueChanged() {
        animateToCurrentPage()
    }
}

extension ImageGalleryView: UIScrollViewDelegate {
    private func refreshPageFromContentOffset(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = page
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            refreshPageFromContentOffset(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshPageFromContentOffset(scrollView)
    }
}

extension ImageGalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath) as! ImageGalleryCell
        if let cellViewModel = viewModel?.viewModel(for: indexPath.row) {
            cellViewModel.delegate = cell
            cell.configure(cellViewModel)
        }
        return cell
    }
}
