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
    case invalidResponse
    case networkError
}

enum APIServiceResponse {
    case failure(Error)
    case success(Data?)
}

protocol APIServiceProtocol {
    func searchFeed(search: SearchParameters, completionHandler: @escaping APIServiceCompletionHandler) -> URLSessionTask?
    func productDetails(productID: String, completionHandler: @escaping APIServiceCompletionHandler) -> URLSessionTask?
    func downloadImage(url: URL, completionHandler: @escaping APIServiceCompletionHandler) -> URLSessionTask?
}

class APIService: APIServiceProtocol {
    private let configuration: Configuration
    private let session: URLSession

    init(configuration: Configuration, session: URLSession) {
        self.configuration = configuration
        self.session = session
    }

    func searchFeed(search: SearchParameters, completionHandler: @escaping APIServiceCompletionHandler) -> URLSessionTask? {
        guard let url = buildSearchFeedURL(search: search) else {
            completionHandler(.failure(APIServiceError.failedToBuildURL))
            return nil
        }
        let task = executeTask(url: url, completionHandler: completionHandler)
        return task
    }

    func productDetails(productID: String, completionHandler: @escaping APIServiceCompletionHandler) -> URLSessionTask? {
        guard let url = buildProductDetailsURL(productID: productID) else {
            completionHandler(.failure(APIServiceError.failedToBuildURL))
            return nil
        }
        let task = executeTask(url: url, completionHandler: completionHandler)
        return task
    }

    func downloadImage(url: URL, completionHandler: @escaping APIServiceCompletionHandler) -> URLSessionTask? {
        let task = executeTask(url: url, completionHandler: completionHandler)
        return task
    }

    private func executeTask(url: URL, completionHandler: @escaping APIServiceCompletionHandler) -> URLSessionTask? {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let error = self.isValidResponse(response) {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(data))
            }
        }
        task.resume()
        return task
    }
}

extension APIService {
    private func isValidResponse(_ response: URLResponse?) -> Error? {
        guard let response = response as? HTTPURLResponse else { return APIServiceError.invalidResponse }
        if (200 ..< 300).contains(response.statusCode) {
            return nil
        } else {
            return APIServiceError.networkError
        }
    }
}

extension APIService {
    private func buildSearchFeedURL(search: SearchParameters) -> URL? {
        let url = "\(configuration.baseURL)/products/search?q=\(search.query)&key=\(configuration.apiKey)&pageSize=\(search.pageSize)&page=\(search.pageNumber)"
        return URL(string: url)
    }

    private func buildProductDetailsURL(productID: String) -> URL? {
        let url = "\(configuration.baseURL)/products/\(productID)?key=\(configuration.apiKey)"
        return URL(string: url)
    }
}
