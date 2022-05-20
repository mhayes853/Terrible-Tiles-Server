//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/19/22.
//

import Foundation
import WebSocketKit

// MARK: - Functionality

/// Namespace for executing Game Server Functionality
struct GameConnection {
    
    /// Procedurally starts a game on the server, returns the final score when done
    static func runGame(ws: WebSocket) async throws -> Score {
        let serverState = GameServerState()
        
        _ = ws.onClose.always { _ in
            print("Connection Closed")
        }
        
        ws.onText { ws, text in
            await Self.handleSocketText(ws: ws, text: text, state: serverState)
        }
        
        let response = GameStateResponse(
            filledTiles: serverState.gameState.filledTiles,
            playerPosition: serverState.gameState.playerPosition,
            isServerResponse: false
        )
        try await ws.sendEncodable(response)
        
        try await runServerGameLoop(ws: ws, state: serverState)
        let finalScore = serverState.gameState.calculateFinalScore()
        return .init(id: serverState.gameId, score: finalScore, createdAt: serverState.gameState.startedAt)
    }
    
    private static func handleSocketText(ws: WebSocket, text: String, state: GameServerState) async {
        do {
            let socketCommand = try GameSocketCommand(rawText: text)
            try await state.gameLock.withLockAsync {
                state.gameState.processInput(command: socketCommand.inputCommand)
                let response = GameStateResponse(
                    filledTiles: state.gameState.filledTiles,
                    playerPosition: state.gameState.playerPosition,
                    isServerResponse: false
                )
                try await ws.sendEncodable(response)
            }
        } catch is GameSocketCommand.CommandError {
            try? await ws.sendGameError(.malformedCommand)
        } catch {
            try? await ws.sendGameError(.internalError)
        }
    }
    
    private static func runServerGameLoop(ws: WebSocket, state: GameServerState) async throws {
        // TODO: - Implement
        while !state.isGameOver {
            try await delay(2)
            try await ws.send("Server Ping")
        }
    }
}

// MARK: - Helper Struct

extension GameConnection {
    fileprivate struct GameServerState {
        let gameId = UUID()
        let gameState = GameState()
        let gameLock = NSLock()
        
        var isGameOver: Bool {
            self.gameLock.lock()
            defer { self.gameLock.unlock() }
            return self.gameState.isDead
        }
    }
}
