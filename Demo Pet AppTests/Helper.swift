//
//  Helper.swift
//  Demo Pet AppTests
//
//  Created by Danut Pralea on 24.11.2022.
//

import Foundation

enum TestError: Error {
    case noTestFile
}

class Helper {
    
    /// getFile. Opens a file in the current bundle and return as data
    /// - Parameters:
    ///   - name: fileName
    ///   - withExtension: extension name, i.e. "json"
    /// - Returns: Data of the contents of the file on nil if not found
    static func getFile(_ name: String, withExtension: String = "json") -> Data? {
        guard let url = Bundle(for: Self.self)
                .url(forResource: name, withExtension: withExtension) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
    
}
