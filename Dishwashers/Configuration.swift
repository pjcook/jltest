//
//  Configuration.swift
//  Dishwashers
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

class Configuration {
    let baseURL: String
    let apiKey: String

    init(
        baseURL: String = "https://api.johnlewis.com/v1",
        apiKey: String = "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
}
