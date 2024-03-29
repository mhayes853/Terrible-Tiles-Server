//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import Vapor

// MARK: - Struct

/// Outer world struct without any attachment to the database for a persisted score
struct Score: Codable, Content {
    let id: UUID
    let score: Int
    let createdAt: Date
}

// MARK: - Mapping

extension Score {
    var scoreModel: ScoreModel {
        .init(
            id: self.id,
            score: self.score,
            createdAt: self.createdAt
        )
    }
}
