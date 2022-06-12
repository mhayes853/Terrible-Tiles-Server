//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/12/22.
//

import Foundation
import WebSocketKit

/// Allows for synchronised actions on the game state
actor GameActor {
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

extension GameActor {
    func dropRandomTile() async throws {
        try await self.runRespondAction(isServerAction: true, self.gameState.runDropTileEvent)
    }
    
    func spawnNewItems() async throws {
        try await self.runRespondAction(isServerAction: true, self.gameState.runGenerateItemsEvent)
    }
    
    func attackPlayer() async throws {
        try await self.runRespondAction(isServerAction: true, self.gameState.runPushBackPlayerEvent)
    }
}

// MARK: - Send State Response

extension GameActor {
    fileprivate func runRespondAction(isServerAction: Bool = false, _ action: () -> Void) async throws {
        action()
        try await sendCurrentStateResponse(isServerAction: isServerAction)
    }
    
    func sendCurrentStateResponse(isServerAction: Bool = false) async throws {
        let response = self.makeStateResponse(isServerAction: isServerAction)
        try await self.ws.sendEncodable(response)
    }
    
    private func makeStateResponse(isServerAction: Bool = false) -> GameStateResponse {
        let filledTiles = self.gameState.filledTiles.map { (pos, tile) in
            GameStateResponse.Tile(position: pos, type: tile)
        }
        
        return .init(
            filledTiles: filledTiles,
            playerPosition: self.gameState.playerPosition,
            bossHP: self.gameState.bossRemainingHP,
            isServerAction: isServerAction
        )
    }
}

// MARK: - Handle player input

private extension GameActor {
    func handleSocketText(_ text: String) async {
        do {
            let socketCommand = try GameSocketCommand(rawText: text)
            try await self.handleInputCommand(socketCommand.inputCommand)
        } catch is GameSocketCommand.CommandError {
            try? await self.ws.sendGameError(.malformedCommand)
        } catch {
            try? await self.ws.sendGameError(.internalError)
        }
    }
    
    private func handleInputCommand(_ command: InputCommand) async throws {
        try await self.runRespondAction { self.gameState.processInput(command: command) }
    }
}
