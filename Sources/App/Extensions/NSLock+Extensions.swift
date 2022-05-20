//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/18/22.
//

import Foundation

/// Convienience functions to not forget unlocking
extension NSLock {
    func lockedAsync<T>(_ fn: () async throws -> T) async rethrows -> T {
        self.lock()
        defer { self.unlock() }
        return try await fn()
    }
    
    func locked<T>(_ fn: () throws -> T) rethrows -> T {
        self.lock()
        defer { self.unlock() }
        return try fn()
    }
}
