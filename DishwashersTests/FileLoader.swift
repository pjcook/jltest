//
//  FileLoader.swift
//  DishwashersTests
//
//  Created by PJ COOK on 16/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest

class FileLoader {
    static func url(forResource filename: String, withExtension: String) -> URL? {
        return Bundle(for: FileLoader.self).url(forResource: filename, withExtension: withExtension)
    }

    static func loadTestData(filename: String, withExtension: String = "json") -> Data? {
        guard let url = url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Missing file: \(filename).\(withExtension)")
            return nil
        }

        do {
            let jsonData = try Data(contentsOf: url)
            return jsonData
        } catch {
            XCTFail("Failed to load file: \(filename).\(withExtension)")
            return nil
        }
    }
}
