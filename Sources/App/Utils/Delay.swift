//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

private let nanoSecondsPerSecond = 1_000_000_000

/// A simple function to delay inside a task
func delay(_ seconds: Int) async throws {
    try await Task.sleep(nanoseconds: UInt64(seconds * nanoSecondsPerSecond))
}
