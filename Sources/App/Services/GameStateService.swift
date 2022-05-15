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
    private var store: any GameStateStore
    
    init(_ store: any GameStateStore) {
        self.store = store
    }
    
    /// Initialize new state
    func createNew() async throws -> GameStateInfo {
        let newState = GameStateInfo(
            id: .init(),
            filledTiles: [:],
            playerPosition: .init(x: 0, y: 0),
            stateKey: .init(),
            createdAt: .now
        )
        
        try await self.store.set(id: newState.id, newState)
        return newState
    }
    
    /// Update existing state
    func update(_ newState: GameStateInfo) async throws {
        try await self.store.set(id: newState.id, newState)
    }
    
    /// Remove existing state
    func remove(id: UUID) async throws {
        try await self.store.remove(id: id)
    }
    
    /// Load existing state, throws if stateKey does not match persisted stateKey
    func load(id: UUID, stateKey: UUID) async throws -> GameStateInfo? {
        guard let loaded = try await self.store.get(id: id) else { return nil }
        guard loaded.stateKey == stateKey else { throw StateError(message: "Invalid State Key") }
        return loaded
    }
}

// MARK: - Error Type

extension GameStateService {
    struct StateError: Error {
        let message: String
    }
}
