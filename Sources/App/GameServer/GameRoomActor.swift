//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/12/22.
//

import Foundation
import WebSocketKit

/// Allows for synchronised actions on the game state
actor GameRoomActor {
    let id = UUID()
    let gameState = GameState()
    let connection: any GameConnection
    
    private let startedAt = Date()
    
    init(connection: any GameConnection) async {
        self.connection = connection
        self.connection.observePlayerInput { [weak self] commands in
            self?.gameState.currentInputs = commands
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

extension GameRoomActor {
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
    
    private func runRespondAction(_ action: () -> Void) async throws {
        action()
        try await sendCurrentStateResponse()
    }
}

// MARK: - Send State Response

extension GameRoomActor {
    func sendCurrentStateResponse() async throws {
        let response = self.makeStateResponse()
        try await self.connection.sendGameStateResponse(response)
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
