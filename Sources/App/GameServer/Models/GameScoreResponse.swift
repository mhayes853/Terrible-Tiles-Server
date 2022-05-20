//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/17/22.
//

import Foundation

/// Socket response for telling the player their final score
struct GameScoreResponse: Encodable {
    let gameId: UUID
    let playerScore: Score
    let topScores: [Score]
}
