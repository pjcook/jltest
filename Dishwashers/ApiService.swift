//
//  ApiService.swift
//  Dishwashers
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

typealias APIServiceCompletionHandler = ((APIServiceResponse) -> Void)

enum APIServiceError: Error {
    case failedToBuildURL
}

enum APIServiceResponse {
    case failure(Error)
    case success(Data)
}

protocol APIServiceProtocol {
    func searchFeed(search: SearchParameters, completionHandler: APIServiceCompletionHandler) -> URLSessionTask?
    func productDetails(productID: String, completionHandler: APIServiceCompletionHandler) -> URLSessionTask?
}

class APIService: APIServiceProtocol {
    private let configuration: Configuration
    private let session: URLSession
    
    init(configuration: Configuration, session: URLSession) {
        self.configuration = configuration
        self.session = session
    }
    
    func searchFeed(search: SearchParameters, completionHandler: APIServiceCompletionHandler) -> URLSessionTask? {
        guard let url = buildSearchFeedURL(search: search) else {
            completionHandler(.failure(APIServiceError.failedToBuildURL))
            return nil
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
        return task
    }
    
    // https://api.johnlewis.com/v1/products/{productId}?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb
    func productDetails(productID: String, completionHandler: APIServiceCompletionHandler) -> URLSessionTask? {
        return nil
    }
}

extension APIService {
    private func buildSearchFeedURL(search: SearchParameters) -> URL? {
        let url = "\(configuration.baseURL)products/search?q=\(search.query)&key=\(configuration.apiKey)&pageSize=\(search.pageSize)&pageNumber=\(search.pageNumber)"
        return URL(string: url)
    }
}
