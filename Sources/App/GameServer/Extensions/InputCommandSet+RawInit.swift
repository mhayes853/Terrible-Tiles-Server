//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/13/22.
//

import Foundation

extension Set where Element == InputCommand {
    init(rawText: String) throws {
        guard let encodedCommands = rawText.data(using: .utf8) else {
            throw GameServerError.socketInputError
        }
        
        let decodedCommands = try? JSONDecoder().decode(Self<InputCommand>.self, from: encodedCommands)
        guard let decodedCommands = decodedCommands else {
            throw GameServerError.socketInputError
        }
        
        self = decodedCommands
    }
}
