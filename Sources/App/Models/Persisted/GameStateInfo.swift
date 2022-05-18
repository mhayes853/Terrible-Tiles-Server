//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import Foundation

/// Main Server Object for persisting and representing Game State
struct GameStateInfo: Codable, Equatable {
    let id: UUID
    let filledTiles: [Position: TileType]
    let playerPosition: Position
    let isDead: Bool
    let itemScore: Int
    let stateKey: UUID
    let createdAt: Date
    
    init(
        id: UUID = .init(),
        filledTiles: [Position: TileType] = GameState.Defaults.filledTiles,
        playerPosition: Position = GameState.Defaults.playerPosition,
        isDead: Bool = GameState.Defaults.isDead,
        itemScore: Int = GameState.Defaults.itemScore,
        stateKey: UUID = .init(),
        createdAt: Date = GameState.Defaults.startedAt
    ) {
        self.id = id
        self.filledTiles = filledTiles
        self.playerPosition = playerPosition
        self.isDead = isDead
        self.itemScore = itemScore
        self.stateKey = stateKey
        self.createdAt = createdAt
    }
}
