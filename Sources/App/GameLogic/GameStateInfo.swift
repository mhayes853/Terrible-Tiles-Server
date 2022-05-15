//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import Foundation

struct GameStateInfo: Codable, Equatable {
    let id: UUID
    let filledTiles: [Position: TileType]
    let playerPosition: Position
    let stateKey: UUID
    let createdAt: Date
}
