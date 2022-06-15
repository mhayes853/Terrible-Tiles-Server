//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/19/22.
//

import Foundation
import WebSocketKit

struct GameServerRoom {
    private let gameLoop: GameLoop
    private let connection: any GameConnection
    
    private let id = UUID()
    private let startedAt = Date()
    
    init(connection: GameConnection) {
        self.connection = connection
        self.gameLoop = GameLoop()
    }
    
    /// Plays the game with the client
    ///
    /// Returns the final score once the game ends
    func playGame() async throws -> Score {
        self.connection.observePlayerInput { inputs in
            await self.gameLoop.setPlayerInputs(inputs)
        }
        
        let finalScoreNumber = try await self.gameLoop.run { stateUpdate in
            Task { try await self.connection.sendGameStateResponse(stateUpdate.response) }
        }
        
        return Score(id: self.id, score: finalScoreNumber, createdAt: self.startedAt)
    }
}
