//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import FluentKit

struct CreateScores: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(ScoreModel.schema)
            .id()
            .field(ScoreModel.Column.score.fieldKey, .uint64)
            .field(ScoreModel.Column.createdAt.fieldKey, .date)
            .create()
        
        // We save some dummy scores to make sure we always have enough for
        // displaying the leaderboard on the client
        try await self.saveDummyScores(database)
    }
    
    private func saveDummyScores(_ db: Database) async throws {
        for _ in 0..<Env.amountTopScores {
            try await ScoreModel(id: nil, score: 0, createdAt: .now)
                .save(on: db)
        }
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(ScoreModel.schema).delete()
    }
}
