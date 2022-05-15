//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

// MARK: - Model

/// Expected form of command data from a socket connection
struct GameSocketCommand: Decodable {
    let gameId: UUID
    let command: String
    let nextActionKey: UUID
}

// MARK: - Error

extension GameSocketCommand {
    struct CommandError: Error {
        let errorCode: GameSocketErrorCode
    }
}
