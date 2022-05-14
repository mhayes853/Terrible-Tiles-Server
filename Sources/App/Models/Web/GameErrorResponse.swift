//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation
import Vapor

/// Error response for socket errors
struct GameErrorResponse: Codable, Content {
    let errorCode: GameSocketErrorCode
    let message: String
}
