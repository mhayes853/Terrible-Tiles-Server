//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation
import Vapor

/// The response of the current game state that the client recieves
struct GameStateResponse: Codable, Content {
    let gameId: UUID
    let filledTiles: [Position: TileType]
    let playerPosition: Position
    let nextActionKey: UUID
}
