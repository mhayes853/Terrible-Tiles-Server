//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/14/22.
//

import Foundation

extension GameStateUpdate {
    var response: GameStateResponse {
        .init(
            filledTiles: self.updatedTiles.map { (pos, tile) in .init(position: pos, type: tile) },
            playerPosition: self.playerPosition,
            bossHP: self.bossHP
        )
    }
}
