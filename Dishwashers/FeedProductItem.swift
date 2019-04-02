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
    
    enum CodingKeys: CodingKey {
        case was, now, currency
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        was = Price.processStringValue(values: values, forKey: .was)
        now = Price.processStringValue(values: values, forKey: .now)
        currency = Price.processStringValue(values: values, forKey: .currency)
    }

    init(was: String, now: String, currency: String) {
        self.was = was
        self.now = now
        self.currency = currency
    }

    static private func processStringValue(values: KeyedDecodingContainer<Price.CodingKeys>, forKey: KeyedDecodingContainer<Price.CodingKeys>.Key) -> String {
        if let value = try? values.decode([String:String].self, forKey: forKey) {
            return value["to"] ?? ""
        } else if let value = try? values.decode(String.self, forKey: forKey) {
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
