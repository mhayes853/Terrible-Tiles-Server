//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

/// The response of the current game state that the client recieves
struct GameStateResponse: Encodable {
    let filledTiles: [Tile]
    let playerPosition: Position
    let isServerResponse: Bool
}

extension GameStateResponse {
    struct Tile: Encodable {
        let position: Position
        let type: TileType
    }
}
