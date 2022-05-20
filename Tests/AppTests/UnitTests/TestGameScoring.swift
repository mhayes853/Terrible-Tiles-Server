//
//  TestGameScoring.swift
//  
//
//  Created by Matthew Hayes on 5/17/22.
//

import XCTest
@testable import App

private let fiveMinutes = TimeInterval(300)

class TestGameScoring: XCTestCase {
    
    func testEmptyScoreOnlyUsesTimeFactor() {
        let (start, end) = getDatesFromTimeOffsets(offset: fiveMinutes)
        let gameState = GameState(itemScore: 0, startedAt: start)
        let finalScore = gameState.calculateFinalScore(endingDate: end)
        XCTAssertEqual(finalScore, 60)
    }
    
    func testFinalScoreIncludesItemScore() {
        let (start, end) = getDatesFromTimeOffsets(offset: fiveMinutes)
        let gameState = GameState(itemScore: 50, startedAt: start)
        let finalScore = gameState.calculateFinalScore(endingDate: end)
        XCTAssertEqual(finalScore, 110)
    }
    
    private func getDatesFromTimeOffsets(offset: TimeInterval) -> (Date, Date) {
        let refDate = Date.now
        return (refDate - offset, refDate)
    }
}
