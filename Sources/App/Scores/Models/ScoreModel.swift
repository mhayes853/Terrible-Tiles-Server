//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import FluentKit

// MARK: - Model

/// Main model for representing a persisted score
final class ScoreModel: Model {
    static var schema = "scores"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: Column.score.fieldKey) var score: Int
    @Field(key: Column.createdAt.fieldKey) var createdAt: Date
    
    init() {}
    
    init(id: UUID? = .init(), score: Int, createdAt: Date = .now) {
        self.id = id
        self.score = score
        self.createdAt = createdAt
    }
}

// MARK: - Column Names

extension ScoreModel {
    enum Column: String {
        case score = "score"
        case createdAt = "created_at"
        
        var fieldKey: FieldKey {
            .string(self.rawValue)
        }
    }
}

// MARK: - Map to Domain Model

extension ScoreModel {
    var plainScore: Score {
        .init(
            id: self.id ?? .init(),
            score: self.score,
            createdAt: self.createdAt
        )
    }
}
