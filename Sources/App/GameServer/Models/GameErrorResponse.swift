//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

/// Error response for socket errors
struct GameErrorResponse: Encodable {
    let errorCode: GameConnectionErrorCode
    let message: String
}
