//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/12/22.
//

import Foundation
import WebSocketKit

/// Allows for synchronised actions on the game state
actor GameConnectionActor {
    let id = UUID()
    let gameState = GameState()
    let ws: WebSocket
    
    private let startedAt = Date()
    
    init(ws: WebSocket) async {
        self.ws = ws
        self.ws.onText { [weak self] _, text in
            await self?.handleSocketText(text)
        }
    }
    
    var isGameOver: Bool {
        self.gameState.isGameOver
    }
    
    var score: Score {
        .init(id: self.id, score: self.gameState.finalScoreNumber, createdAt: self.startedAt)
    }
}

// MARK: - Server Events

extension GameConnectionActor {
    func processPlayerInputs() async throws {
        try await self.runRespondAction(self.gameState.advance)
    }
    
    func dropRandomTile() async throws {
        try await self.runRespondAction(self.gameState.runDropTileEvent)
    }
    
    func spawnNewItems() async throws {
        try await self.runRespondAction(self.gameState.runGenerateItemsEvent)
    }
    
    func attackPlayer() async throws {
        try await self.runRespondAction(self.gameState.runPushBackPlayerEvent)
    }
}

// MARK: - Send State Response

extension GameConnectionActor {
    fileprivate func runRespondAction(_ action: () -> Void) async throws {
        action()
        try await sendCurrentStateResponse()
    }
    
    func sendCurrentStateResponse() async throws {
        let response = self.makeStateResponse()
        try await self.ws.sendEncodable(response)
    }
    
    private func makeStateResponse() -> GameStateResponse {
        let filledTiles = self.gameState.filledTiles.map { (pos, tile) in
            GameStateResponse.Tile(position: pos, type: tile)
        }
        
        return .init(
            filledTiles: filledTiles,
            playerPosition: self.gameState.playerPosition,
            bossHP: self.gameState.bossRemainingHP
        )
    }
}

// MARK: - Handle player input

private extension GameConnectionActor {
    func handleSocketText(_ text: String) async {
        do {
            let socketCommands = try Set<InputCommand>(rawText: text)
            self.gameState.currentInputs = socketCommands
        } catch is GameServerError {
            try? await self.ws.sendGameError(.malformedCommand)
        } catch {
            try? await self.ws.sendGameError(.internalError)
        }
    }
}
