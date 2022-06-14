//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/19/22.
//

import Foundation
import WebSocketKit

struct GameRoom {
    fileprivate let connectionActor: GameRoomActor
    
    init(gameActor: GameRoomActor) {
        self.connectionActor = gameActor
    }
    
    /// Plays the game with the client
    ///
    /// Returns the final score once the game ends
    func playGame() async throws -> Score {
        try await self.runGameLoop()
        return await self.connectionActor.score
    }
}

// MARK: - Server Game Events (eg. Dropping tiles, Spawning items, etc.)

extension GameRoom {
    fileprivate func runGameLoop() async throws {
        // The player would expect some items to be nicely generated for them to start the game...
        try await self.connectionActor.spawnNewItems()
        
        let spawnItemsLoop = Task { try await self.runGameActionLoop(interval: 10, perform: self.connectionActor.spawnNewItems) }
        let dropTileLoop = Task { try await self.runGameActionLoop(interval: 1, perform: self.connectionActor.dropRandomTile) }
        let attackPlayerLoop = Task { try await self.runGameActionLoop(interval: 5, perform: self.connectionActor.attackPlayer) }
        
        try await self.runGameActionLoop(interval: 0.3, perform: self.connectionActor.processPlayerInputs)
        spawnItemsLoop.cancel()
        dropTileLoop.cancel()
        attackPlayerLoop.cancel()
        
        // Make sure the client and server agree with each other on the final position
        try await self.connectionActor.sendCurrentStateResponse()
    }
    
    private func runGameActionLoop(interval: TimeInterval, perform: () async throws -> Void) async throws {
        while await !self.connectionActor.isGameOver {
            try await delay(seconds: interval)
            try await perform()
        }
    }
}
