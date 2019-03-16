//
//  ImageService.swift
//  Dishwashers
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

protocol ImageServiceProtocol {
    func createDownloadImageTask(url: URL) -> URLSessionTask?
}

class ImageService: ImageServiceProtocol {
    func createDownloadImageTask(url: URL) -> URLSessionTask? {
        return nil
    }
}
