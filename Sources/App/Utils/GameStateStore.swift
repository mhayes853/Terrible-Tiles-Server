//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import Foundation

/// Key Value Store for Persisting Game State Info
protocol GameStateStore {
    func set(id: UUID, _ gameStateInfo: GameStateInfo) async throws
    
    func get(id: UUID) async throws -> GameStateInfo?
    
    func remove(id: UUID) async throws
}
