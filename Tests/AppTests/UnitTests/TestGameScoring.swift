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
        let gameState = GameStateInfo(itemScore: 0, createdAt: start)
        let finalScore = gameState.calculatefinalScore(endingTime: end)
        XCTAssertEqual(finalScore.score, 60)
    }
    
    func testFinalScoreIncludesItemScore() {
        let (start, end) = getDatesFromTimeOffsets(offset: fiveMinutes)
        let gameState = GameStateInfo(itemScore: 50, createdAt: start)
        let finalScore = gameState.calculatefinalScore(endingTime: end)
        XCTAssertEqual(finalScore.score, 110)
    }
    
    private func getDatesFromTimeOffsets(offset: TimeInterval) -> (Date, Date) {
        let refDate = Date.now
        return (refDate - offset, refDate)
    }
}
