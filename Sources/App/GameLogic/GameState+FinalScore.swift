//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/19/22.
//

import Foundation

/// Calculating the final score
///
/// Less is more when it comes to getting a higher score (ie. we award an efficient playstyle)
///
/// Efficiency can be judged by multiple factors in relation to the total damage dealt to the boss:
///     - The amount of tiles dropped
///     - The amount of movements made by the player
///     - The amount of items collected
///
/// Additionally, we subtract 40% of the player's score if they die and add an additional 40% if they defeat the boss
extension GameState {
    var finalScoreNumber: Int {
        let tileScore = self.damageRelationScore(factor: self.droppedTileCount)
        let collectionScore = self.damageRelationScore(factor: self.totalItemsCollected)
        let movementScore = self.damageRelationScore(factor: self.totalMoves)
        
        let scoreMultiplier = self.isDead ? 0.6 : 1.4
        let addedScore = self.bossDamageDealt + collectionScore + tileScore + movementScore
        let unmultipliedScore = max(addedScore, 0)
        return Int(Double(unmultipliedScore) * scoreMultiplier)
    }
    
    private var droppedTileCount: Int {
        self.filledTiles.filter { (_, type) in type == .void }.count
    }
    
    private func damageRelationScore(factor: Int) -> Int {
        let divisionFactor = max(Double(factor / 100), 1.0) // Prevent division by 0
        return Int(Double(self.bossDamageDealt) / divisionFactor)
    }
}
