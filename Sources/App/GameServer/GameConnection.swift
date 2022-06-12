//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/19/22.
//

import Foundation
import WebSocketKit

// MARK: - Functionality

/// Game Connection State
struct GameConnection {
    private let game: GameActor
    
    init(gameActor: GameActor) {
        self.game = gameActor
    }
    
    /// Plays the game with the client
    ///
    /// Returns the final score once the game ends
    func playGame() async throws -> Score {
        // Initial state for the client
        try await self.game.sendCurrentStateResponse()
        try await self.runGameLoop()
        return await self.game.score
    }
}

// MARK: - Server Game Events (eg. Dropping tiles, Spawning items, etc.)

extension GameConnection {
    fileprivate func runGameLoop() async throws {
        // The player would expect some items to be nicely generated for them to start the game...
        try await self.game.spawnNewItems()
        
        while await !self.game.isGameOver {
            // This inner loop makes sure we only wait at most 0.1 seconds before
            // sending back the final score response to the player on their death.
            for i in 1...100 {
                try await delay(seconds: 0.1)
                guard await !self.game.isGameOver else { break }
                
                if i.isMultiple(of: 100) {
                    try await self.game.spawnNewItems()
                } else if i.isMultiple(of: 50) {
                    try await self.game.attackPlayer()
                } else if i.isMultiple(of: 10) {
                    try await self.game.dropRandomTile()
                }
            }
        }
        
        // Make sure the client and server agree with each other on the final position
        try await self.game.sendCurrentStateResponse()
    }
}
