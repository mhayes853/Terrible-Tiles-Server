//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation
import Vapor

/// Expected form of command data from a socket connection
struct GameSocketCommand: Codable, Content {
    let gameId: UUID
    let command: String
    let stateKey: UUID
}
