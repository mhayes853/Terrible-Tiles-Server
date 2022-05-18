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
    static var dbHost: String {
        return Environment.get("DB_HOST")!
    }
    
    static var dbPort: Int {
        return Environment.getInteger("DB_PORT")
    }
    
    static var dbUser: String {
        return Environment.get("DB_USER")!
    }
    
    static var dbPassword: String {
        return Environment.get("DB_PASSWORD")!
    }
    
    static var dbName: String {
        return Environment.get("DB_NAME")!
    }
    
    static var redisHost: String {
        return Environment.get("REDIS_HOST")!
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
