//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import Foundation

// MARK: - Service

/// Service for accessing persisted game states
class GameStateService {
    private var store: any GameStateStoreProtocol
    
    init(_ store: any GameStateStoreProtocol) {
        self.store = store
    }
    
    /// Initialize new state
    func createNew() async throws -> GameStateInfo {
        let newState = GameStateInfo()
        try await self.store.set(id: newState.id, newState)
        return newState
    }
    
    /// Runs game command and saves updated state
    func runCommand(gameId: UUID, input: InputCommand, stateKey: UUID) async throws -> GameStateInfo {
        guard let loadedInfo = try await self.load(id: gameId, stateKey: stateKey) else {
            throw StateError.notFound
        }
        let gameState = loadedInfo.plainGameState
        gameState.processInput(command: input)
        
        let updatedInfo = GameStateInfo(
            id: loadedInfo.id,
            filledTiles: gameState.filledTiles,
            playerPosition: gameState.playerPosition,
            isDead: gameState.isDead,
            itemScore: gameState.itemScore,
            createdAt: loadedInfo.createdAt
        )
        try await self.store.set(id: updatedInfo.id, updatedInfo)
        return updatedInfo
    }
    
    /// Remove existing state
    func remove(id: UUID) async throws {
        try await self.store.remove(id: id)
    }
    
    /// Load existing state, throws if stateKey does not match persisted stateKey
    func load(id: UUID, stateKey: UUID) async throws -> GameStateInfo? {
        guard let loaded = try await self.store.get(id: id) else { return nil }
        guard loaded.stateKey == stateKey else { throw StateError.badStateKey }
        return loaded
    }
}

// MARK: - Error Type

extension GameStateService {
    enum StateError: Error {
        case notFound
        case badStateKey
    }
}
