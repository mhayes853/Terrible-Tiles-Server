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
            .field(ScoreModel.Column.playerName.fieldKey, .string)
            .field(ScoreModel.Column.score.fieldKey, .uint64)
            .field(ScoreModel.Column.createdAt.fieldKey, .date)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(ScoreModel.schema).delete()
    }
}
