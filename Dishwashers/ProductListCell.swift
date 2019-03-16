//
//  ProductListCell.swift
//  Dishwashers
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class ProductListCell: UICollectionViewCell {
    @IBOutlet private var productImage: UIImageView!
    @IBOutlet private var productTitle: UILabel!
    @IBOutlet private var productPrice: UILabel!
    
    private var loadImageTask: URLSessionTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        loadImageTask?.cancel()
        productImage.image = nil
        productTitle.text = nil
        productPrice.text = nil
    }
    
    func configure(item: FeedProductItem, service: APIServiceProtocol) {
        productTitle.text = item.title
        loadImage(item: item, service: service)
        configurePrice(item: item)
    }
    
    private func configurePrice(item: FeedProductItem) {
        // TODO: Optimise and move this processing to when the data is downloaded
        guard let price = Double(item.price.now) else { return }
        let locale = Locale(identifier: item.price.currency)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .currency
        productPrice.text = numberFormatter.string(from: NSNumber(value: price))
    }
    
    private func loadImage(item: FeedProductItem, service: APIServiceProtocol) {
        loadImageTask?.cancel()
        var imageURL = item.image
        if imageURL.hasPrefix("//") {
            imageURL = "https:" + imageURL
        }
        if let url = URL(string: imageURL) {
            loadImageTask = service.downloadImage(url: url, completionHandler: { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure:
                    break
                case let .success(data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            UIView.transition(with: self, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                                self.productImage.image = image
                            }, completion: nil)
                        }
                    }
                }
            })
        }
    }
}
