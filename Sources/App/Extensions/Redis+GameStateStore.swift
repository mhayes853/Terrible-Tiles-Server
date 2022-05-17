//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import Foundation
import Vapor
import Redis

extension Application.Redis: GameStateStore {
    func set(id: UUID, _ gameStateInfo: GameStateInfo) async throws {
        try await self.set(id.redisKey, toJSON: gameStateInfo)
    }
    
    func get(id: UUID) async throws -> GameStateInfo? {
        return try await self.get(id.redisKey, asJSON: GameStateInfo.self)
    }
    
    func remove(id: UUID) throws {
        _ = try self.delete(id.redisKey).wait()
    }
}
