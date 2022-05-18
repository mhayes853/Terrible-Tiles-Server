//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/17/22.
//

import Foundation

/// Initialize a game socket command from raw text
extension GameSocketCommand {
    init(rawText: String) throws {
        guard let encodedCommand = rawText.data(using: .utf8) else {
            throw GameSocketCommand.CommandError(errorCode: .malformedCommand)
        }
        
        let decodedCommand = try? JSONDecoder().decode(GameSocketCommand.self, from: encodedCommand)
        guard let decodedCommand = decodedCommand else {
            throw GameSocketCommand.CommandError(errorCode: .malformedCommand)
        }
        
        self = decodedCommand
    }
}
