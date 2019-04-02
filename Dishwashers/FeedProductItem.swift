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
    
    // If the API returned the data correctly and consistently then the next following would not be required: enum, init(from decoder), processStringValue
    enum CodingKeys: CodingKey {
        case was, now, currency
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        was = Price.processStringValue(values: values, forKey: .was)
        now = Price.processStringValue(values: values, forKey: .now)
        currency = Price.processStringValue(values: values, forKey: .currency)
    }
    
    static private func processStringValue(values: KeyedDecodingContainer<Price.CodingKeys>, forKey: KeyedDecodingContainer<Price.CodingKeys>.Key) -> String {
        if let value = try? values.decode(String.self, forKey: forKey) {
            return value
        } else if let value = try? values.decode(Double.self, forKey: forKey) {
            return String(value)
        } else if let value = try? values.decode(Float.self, forKey: forKey) {
            return String(value)
        } else if let value = try? values.decode(Int.self, forKey: forKey) {
            return String(value)
        }
        return ""
    }
}

struct FeedProductItem: Codable {
    let productId: String
    let price: Price
    let title: String
    let image: String
}
