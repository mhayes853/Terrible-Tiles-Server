//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import Vapor

// MARK: - Struct

struct Score: Codable, Content {
    let id: UUID
    let playerName: String
    let score: Int
    let createdAt: Date
}

// MARK: - Mapping

extension Score {
    var scoreModel: ScoreModel {
        .init(
            id: self.id,
            playerName: self.playerName,
            score: self.score,
            createdAt: self.createdAt
        )
    }
}
