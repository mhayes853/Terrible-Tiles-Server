//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/29/22.
//

import Foundation

#if os(Linux)

/// Allows for usage of Date.now in  production
extension Date {
    static var now: Date {
        .init()
    }
}

#endif
