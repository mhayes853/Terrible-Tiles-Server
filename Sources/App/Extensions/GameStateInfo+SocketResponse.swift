//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import Foundation

extension GameStateInfo {
    var socketResponse: GameStateResponse {
        .init(
            gameId: self.id,
            filledTiles: self.filledTiles,
            playerPosition: self.playerPosition,
            nextActionKey: self.stateKey
        )
    }
}
