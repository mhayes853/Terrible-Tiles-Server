//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/15/22.
//

import Foundation

extension GameStateInfo {
    var plainGameState: GameState {
        .init(
            filledTiles: self.filledTiles,
            playerPosition: self.playerPosition,
            isDead: self.isDead,
            itemScore: self.itemScore,
            startedAt: self.createdAt
        )
    }
}
