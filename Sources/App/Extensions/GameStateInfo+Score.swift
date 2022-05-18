//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/17/22.
//

import Foundation

/// Calculate a player's final score from game state info
extension GameStateInfo {
    func calculatefinalScore(endingTime: Date = .now) -> Score {
        let dateOffset = Int(endingTime.timeIntervalSince1970 - self.createdAt.timeIntervalSince1970)
        let finalScore = self.itemScore + Int(Double(dateOffset) * 0.2)
        return .init(id: self.id, score: finalScore, createdAt: endingTime)
    }
}
