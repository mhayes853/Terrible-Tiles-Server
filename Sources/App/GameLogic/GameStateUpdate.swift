//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/14/22.
//

import Foundation

/// Represents changes between game loop iterations
struct GameStateUpdate {
    let playerPosition: Position
    let updatedTiles: [Position: TileType]
    let bossHP: Int
}
