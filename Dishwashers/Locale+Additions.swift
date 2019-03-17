//
//  Locale+Additions.swift
//  Dishwashers
//
//  Created by PJ COOK on 17/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

var localeLookup: [String: Locale] = [:]

extension Locale {
    static func locale(from currencyCode: String) -> Locale? {
        if let locale = localeLookup[currencyCode] {
            return locale
        }
        
        var locale: Locale? = nil
        for identifier in Locale.availableIdentifiers {
            let tempLocale = Locale(identifier: identifier)
            if tempLocale.currencyCode == currencyCode {
                locale = tempLocale
                localeLookup[currencyCode] = tempLocale
                break
            }
        }
        return locale
    }
}