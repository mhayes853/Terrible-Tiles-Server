//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import Vapor
import FluentKit

/// Wrapper for Database Operations
class ScoresService {
    private let db: Database
    
    init(_ db: Database) {
        self.db = db
    }
    
    /// Saves a score in the database
    func insertNew(score: Score) async throws {
        let scoreModel = score.scoreModel
        try await scoreModel.create(on: self.db)
    }
    
    /// Fetches the top scores in the database
    func topScores(amount: Int = AppConstants.amountTopScores) async throws -> [Score] {
        return try await ScoreModel.query(on: self.db)
            .sort(ScoreModel.Column.score.fieldKey, .descending)
            .limit(amount)
            .all()
            .map(\.plainScore)
    }
}
