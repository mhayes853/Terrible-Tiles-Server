//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/19/22.
//

import Foundation

extension GameState {
    func calculateFinalScore(endingDate: Date = .now) -> Int {
        let dateOffset = Int(endingDate.timeIntervalSince1970 - self.startedAt.timeIntervalSince1970)
        return self.itemScore + Int(Double(dateOffset) * 0.2)
    }
}
