//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

// MARK: - Main Struct

/// The response of the current game state that the client recieves
struct GameStateResponse: Encodable {
    let filledTiles: [Tile]
    let playerPosition: Position
    let bossHP: Int
}

// MARK: - Inner Tile Type

/// An easier to decode type for the client
extension GameStateResponse {
    struct Tile: Encodable {
        let position: Position
        let type: TileType
    }
}
