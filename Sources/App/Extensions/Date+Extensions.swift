//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/14/22.
//

import Foundation

extension Date {
    #if os(Linux)
    static var now: Date {
        .init()
    }
    #endif
}
