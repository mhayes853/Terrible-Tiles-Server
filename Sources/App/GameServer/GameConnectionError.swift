//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/13/22.
//

import Foundation

/// Standard error type for game connections
struct GameConnectionError: Error {
    let errorCode: GameConnectionErrorCode
}
