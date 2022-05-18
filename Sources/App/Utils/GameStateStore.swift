//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/18/22.
//

import Foundation

/// Simple Implementation of a Game State Store
actor GameStateStore: GameStateStoreProtocol {
    private var stateTable = [UUID: GameStateInfo]()
    
    func get(id: UUID) async throws -> GameStateInfo? {
        return self.stateTable[id]
    }
    
    func set(id: UUID, _ gameStateInfo: GameStateInfo) async throws {
        self.stateTable[id] = gameStateInfo
    }
    
    func remove(id: UUID) async throws {
        self.stateTable.removeValue(forKey: id)
    }
}
