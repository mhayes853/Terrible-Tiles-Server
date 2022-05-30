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
    private let serverState = ConnectionState()
    private let ws: WebSocket
    
    init(ws: WebSocket) {
        self.ws = ws
    }
    
    /// Plays the game with the client
    ///
    /// Returns the final score once the game ends
    func playGame() async throws -> Score {
        // Initial state for the client
        try await self.sendStateResponse()
    
        self.ws.onText { _, text in
            await self.handleSocketText(text: text)
        }
        
        try await self.runGameLoop()
        return self.serverState.score
    }
}

// MARK: - Player Handled Events (Movement, Leaving)

extension GameConnection {
    fileprivate func handleSocketText(text: String) async {
        do {
            let socketCommand = try GameSocketCommand(rawText: text)
            try await self.handleInputCommand(socketCommand.inputCommand)
        } catch is GameSocketCommand.CommandError {
            try? await ws.sendGameError(.malformedCommand)
        } catch {
            try? await ws.sendGameError(.internalError)
        }
    }
    
    private func handleInputCommand(_ command: InputCommand) async throws {
        try await self.serverState.lock.lockedAsync {
            self.serverState.gameState.processInput(command: command)
            try await self.sendStateResponse()
        }
    }
}

// MARK: - Server Game Events (eg. Dropping tiles, Spawning items, etc.)

extension GameConnection {
    fileprivate func runGameLoop() async throws {
        while !self.serverState.isGameOverWithLock {
            // This inner loop makes sure we only wait at most 0.1 seconds before
            // sending back the final score response to the player on their death.
            for i in 1...100 {
                try await delay(seconds: 0.1)
                guard !self.serverState.isGameOverWithLock else { break }
                
                if i.isMultiple(of: 100) {
                    try await self.spawnItems()
                } else if i.isMultiple(of: 50) {
                    try await self.pushBackPlayer()
                } else if i.isMultiple(of: 10) {
                    try await self.dropRandomTile()
                }
            }
        }
        
        // Make sure the client and server agree with each other on the final position
        try await self.sendStateResponse()
    }
    
    private func dropRandomTile() async throws {
        try await self.serverState.lock.lockedAsync {
            self.serverState.gameState.dropTile()
            try await self.sendStateResponse()
        }
    }
    
    private func spawnItems() async throws {
        try await self.serverState.lock.lockedAsync {
            try await self.sendStateResponse()
        }
    }
    
    private func pushBackPlayer() async throws {
        try await self.serverState.lock.lockedAsync {
            try await self.sendStateResponse()
        }
    }
}

// MARK: - Helper Struct

extension GameConnection {
    fileprivate struct ConnectionState {
        let id = UUID()
        let gameState = GameState()
        let lock = NSLock()
        
        var isGameOverWithLock: Bool {
            self.lock.locked { self.gameState.isDead }
        }
        
        var score: Score {
            let scoreValue = gameState.calculateFinalScore()
            return .init(id: self.id, score: scoreValue, createdAt: self.gameState.startedAt)
        }
        
        func makeStateResponse(isServerAction: Bool = false) -> GameStateResponse {
            let filledTiles = self.gameState.filledTiles.map { (pos, tile) in
                GameStateResponse.Tile(position: pos, type: tile)
            }
            
            return .init(
                filledTiles: filledTiles,
                playerPosition: self.gameState.playerPosition,
                isServerResponse: isServerAction
            )
        }
    }
}

// MARK: - Helpers

extension GameConnection {
    fileprivate func sendStateResponse(isServerAction: Bool = false) async throws {
        let response = self.serverState.makeStateResponse(isServerAction: isServerAction)
        try await self.ws.sendEncodable(response)
    }
}
