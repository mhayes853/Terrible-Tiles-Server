//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/29/22.
//

import Foundation

/// The default json encoder for the server
extension JSONEncoder {
    static let defaultEncoder: JSONEncoder = {
        var encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
}
