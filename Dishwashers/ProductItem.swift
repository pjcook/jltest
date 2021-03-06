//  Copyright © 2019 Software101. All rights reserved.

import Foundation

struct FeatureAttribute: Codable {
    let id: String
    let name: String
    let toolTip: String
    let uom: String
    let value: String
}

struct ProductFeature: Codable {
    let attributes: [FeatureAttribute]
}

struct ProductAdditionalServices: Codable {
    let includedServices: [String]
}

struct ProductDetails: Codable {
    let productInformation: String
    let features: [ProductFeature]
}

struct MediaImageDetails: Codable {
    let altText: String
    let urls: [String]
}

struct Media: Codable {
    let images: MediaImageDetails
}

struct ProductItem: Codable {
    let productId: String
    let title: String
    let media: Media
    let price: Price
    let details: ProductDetails
    let displaySpecialOffer: String
    let additionalServices: ProductAdditionalServices
    let code: String

    init(with item: FeedProductItem) {
        productId = item.productId
        title = item.title
        price = item.price
        media = Media(images: MediaImageDetails(altText: "", urls: [item.image]))
        details = ProductDetails(productInformation: "", features: [])
        displaySpecialOffer = ""
        additionalServices = ProductAdditionalServices(includedServices: [])
        code = ""
    }
}

extension ProductItem {
    static func processNetworkData(data: Data?) -> ProductItem? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        do {
            let results = try decoder.decode(ProductItem.self, from: data)
            return results
        } catch {
            return nil
        }
    }
}
