//  Copyright © 2019 Software101. All rights reserved.

import Foundation

struct Price: Codable {
    let was: String
    let now: String
    let currency: String

    var nowFormatted: String {
        guard !now.isEmpty, let price = Double(now) else { return "" }
        guard let locale = Locale.locale(from: currency) else {
            return now
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: NSNumber(value: price)) ?? ""
    }
}

struct FeedProductItem: Codable {
    let productId: String
    let price: Price
    let title: String
    let image: String
}
