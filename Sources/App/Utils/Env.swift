//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import Vapor

// We'll implicity unwrap these values. If something is nil, it means the .env file
// is not provided therefore we'll want to complain loudly...

struct Env {
    static var dbHost: String {
        return Environment.get("DB_HOST")!
    }
    
    static var dbPort: Int {
        let portStr = Environment.get("DB_PORT")!
        return Int(portStr)!
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
    
    static var connectionPoolThreads: Int {
        let threadsStr = Environment.get("NUM_THREADS")!
        return Int(threadsStr)!
    }
}
