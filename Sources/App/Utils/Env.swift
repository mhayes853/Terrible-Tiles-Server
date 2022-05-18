//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import Vapor

// MARK: - Env Struct

// We'll implicity unwrap these values. If something is nil, it means the .env file
// is not provided therefore we'll want to complain loudly...

/// Everything loaded from a .env file
struct Env {
    static var sqlitePath: String {
        return Environment.get("SQLITE_PATH")!
    }
    
    static var amountTopScores: Int {
        return Environment.getInteger("AMOUNT_TOP_SCORES")
    }
}

// MARK: - Helpers

private extension Environment {
    static func getInteger(_ key: String) -> Int {
        let strInt = Self.get(key)!
        return Int(strInt)!
    }
}
