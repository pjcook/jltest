//
//  FileLoader.swift
//  DishwashersTests
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

class FileLoader {
    static func loadTestData(filename: String, withExtension: String = "json") -> Data? {
        guard let url = Bundle(for: FileLoader.self).url(forResource: filename, withExtension: withExtension) else {
            fatalError("Missing file: \(filename).\(withExtension)")
        }
        do {
            let jsonData = try Data(contentsOf: url)
            return jsonData
        } catch {
            fatalError("Failed to load file: \(filename).\(withExtension)")
        }
        
        return nil
    }
}
