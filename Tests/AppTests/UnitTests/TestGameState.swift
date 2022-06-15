//
//  TestGameState.swift
//  
//
//  Created by Matthew Hayes on 5/15/22.
//

import XCTest
@testable import App

// MARK: - Test Case

class TestGameState: XCTestCase {
    
    func testLeaveGame() {
        let gameState = GameState()
        gameState.processInput(command: .leave)
        XCTAssertTrue(gameState.isDead)
    }

    func testSimpleMoveUp() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x, y: GameState.Defaults.playerPosition.y + 1)
        gameState.testSimpleMovement(command: .moveUp, expectedPosition: expectedPosition)
    }
    
    func testMoveUpMultipleTimes() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x, y: GameState.Defaults.playerPosition.y + 5)
        gameState.testSimpleMovement(amountTimes: 5, command: .moveUp, expectedPosition: expectedPosition)
    }
    
    func testMoveUpRespectsLimit() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x, y: GameState.Constants.maxRows - 1)
        gameState.testSimpleMovement(
            amountTimes: GameState.Constants.maxRows,
            command: .moveUp,
            expectedPosition: expectedPosition
        )
    }
    
    func testSimpleMoveLeft() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x - 1, y: GameState.Defaults.playerPosition.y)
        gameState.testSimpleMovement(command: .moveLeft, expectedPosition: expectedPosition)
    }
    
    func testMoveLeftMultipleTimes() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x - 10, y: GameState.Defaults.playerPosition.y)
        gameState.testSimpleMovement(amountTimes: 10, command: .moveLeft, expectedPosition: expectedPosition)
    }
    
    func testMoveLeftRespectsLimit() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: 0, y: GameState.Defaults.playerPosition.y)
        gameState.testSimpleMovement(
            amountTimes: GameState.Constants.maxCols,
            command: .moveLeft,
            expectedPosition: expectedPosition
        )
    }
    
    func testSimpleMoveDown() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x, y: GameState.Defaults.playerPosition.y - 1)
        gameState.testSimpleMovement(command: .moveDown, expectedPosition: expectedPosition)
    }
    
    func testMoveDownMultipleTimes() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x, y: GameState.Defaults.playerPosition.y - 5)
        gameState.testSimpleMovement(amountTimes: 5, command: .moveDown, expectedPosition: expectedPosition)
    }
    
    func testMoveDownRespectsLimit() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x, y: 0)
        gameState.testSimpleMovement(
            amountTimes: GameState.Constants.maxRows,
            command: .moveDown,
            expectedPosition: expectedPosition
        )
    }
    
    func testSimpleMoveRight() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x + 1, y: GameState.Defaults.playerPosition.y)
        gameState.testSimpleMovement(command: .moveRight, expectedPosition: expectedPosition)
    }
    
    func testMoveRightMultipleTimes() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Defaults.playerPosition.x + 10, y: GameState.Defaults.playerPosition.y)
        gameState.testSimpleMovement(amountTimes: 10, command: .moveRight, expectedPosition: expectedPosition)
    }
    
    func testMoveRightRespectsLimit() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: GameState.Constants.maxCols - 1, y: GameState.Defaults.playerPosition.y)
        gameState.testSimpleMovement(
            amountTimes: GameState.Constants.maxCols,
            command: .moveRight,
            expectedPosition: expectedPosition
        )
    }
    
    func testUpLeftDiagonalMovement() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: 4, y: 14)
        gameState.testDiagonalMovement(
            amountTimes: GameState.Constants.maxRows,
            c1: .moveLeft,
            c2: .moveUp,
            expected: expectedPosition
        )
    }
    
    func testUpRightDiagonalMovement() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: 20, y: 14)
        gameState.testDiagonalMovement(
            amountTimes: GameState.Constants.maxRows,
            c1: .moveRight,
            c2: .moveUp,
            expected: expectedPosition
        )
    }
    
    func testDownLeftDiagonalMovement() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: 4, y: 0)
        gameState.testDiagonalMovement(
            amountTimes: GameState.Constants.maxRows,
            c1: .moveLeft,
            c2: .moveDown,
            expected: expectedPosition
        )
    }
    
    func testDownRightDiagonalMovement() {
        let gameState = GameState()
        
        let expectedPosition = Position(x: 20, y: 0)
        gameState.testDiagonalMovement(
            amountTimes: GameState.Constants.maxRows,
            c1: .moveRight,
            c2: .moveDown,
            expected: expectedPosition
        )
    }
    
    func testTotalMovesUpdatesProperly() {
        let gameState = GameState()
        
        gameState.processInput(command: .moveUp)
        
        XCTAssertEqual(gameState.totalMoves, 1)
       
        for _ in 0..<3 {
            gameState.processInput(command: .moveLeft)
        }
        
        XCTAssertEqual(gameState.totalMoves, 4)
    }
    
    func testTotalMovesDoesNotUpdateWhenAtBoundry() {
        let gameState = GameState(playerPosition: .init(x: GameState.Constants.maxCols - 1, y: 0))
        gameState.processInput(command: .moveRight)
        XCTAssertEqual(gameState.totalMoves, 0)
    }
    
    func testSquareMovement() {
        let gameState = GameState()
        gameState.moveRepeatedly(amountTimes: 4, command: .moveLeft)
        gameState.moveRepeatedly(amountTimes: 4, command: .moveUp)
        gameState.moveRepeatedly(amountTimes: 4, command: .moveRight)
        gameState.moveRepeatedly(amountTimes: 4, command: .moveDown)
        XCTAssertEqual(gameState.playerPosition, GameState.Defaults.playerPosition)
    }
    
    private let basicItemPosition = Position(
        x: GameState.Defaults.playerPosition.x,
        y: GameState.Defaults.playerPosition.y + 1
    )
    
    func testCollectBlueItem() {
        let gameState = GameState(filledTiles: [basicItemPosition: .blueItem])
        gameState.testCollectItem(itemPosition: basicItemPosition, itemType: .blueItem)
    }
    
    func testCollectRedItem() {
        let gameState = GameState(filledTiles: [basicItemPosition: .redItem])
        gameState.testCollectItem(itemPosition: basicItemPosition, itemType: .redItem)
    }
    
    func testCollectPurpleItem() {
        let gameState = GameState(filledTiles: [basicItemPosition: .purpleItem])
        gameState.testCollectItem(itemPosition: basicItemPosition, itemType: .purpleItem)
    }
    
    func testCollectPinkItem() {
        let gameState = GameState(filledTiles: [basicItemPosition: .pinkItem])
        gameState.testCollectItem(itemPosition: basicItemPosition, itemType: .pinkItem)
    }
    
    func testCollectMultipleItems() {
        let itemTiles = [
            Position(x: 2, y: 5): TileType.pinkItem,
            Position(x: 12, y: 5): TileType.blueItem,
            Position(x: 3, y: 3): TileType.purpleItem,
            Position(x: 8, y: 6): TileType.redItem,
            Position(x: 14, y: 7): TileType.pinkItem,
            Position(x: 0, y: 0): TileType.blueItem
        ]
        let gameState = GameState(filledTiles: itemTiles)
        
        for tile in itemTiles {
            gameState.testCollectItem(itemPosition: tile.key, itemType: tile.value)
        }
        
        XCTAssertEqual(gameState.totalItemsCollected, itemTiles.count)
    }
    
    func testVoidTileKillsPlayer() {
        let gameState = GameState(filledTiles: [basicItemPosition: .void])
        gameState.moveTo(position: basicItemPosition)
        XCTAssertTrue(gameState.isDead)
    }
    
    func testGettingMaxItemScoreEndsGame() {
        var itemTiles = [Position: TileType]()
        for i in 0..<(GameState.Constants.bossHP / 10) {
            let pos = Position(x: i % GameState.Constants.maxCols, y: i % GameState.Constants.maxRows)
            itemTiles[pos] = .pinkItem
        }
        
        let gameState = GameState(filledTiles: itemTiles)
        
        for tile in itemTiles {
            gameState.moveTo(position: tile.key)
        }
        
        XCTAssertTrue(gameState.isGameOver)
    }
    
    func testItemScoreIsCappedAtMax() {
        let itemPos = Position(x: GameState.Constants.maxCols - 1, y: GameState.Constants.maxRows - 1)
        let gameState = GameState(
            filledTiles: [itemPos: .purpleItem],
            itemScore: GameState.Constants.bossHP - 1
        )
        
        gameState.moveTo(position: itemPos)
        XCTAssertEqual(gameState.bossDamageDealt, GameState.Constants.bossHP)
    }
    
    func testSimpleAdvanceGameState() {
        let gameState = GameState(playerInputs: [.moveLeft, .moveRight])
        gameState.processCurrentInputs()
        XCTAssertEqual(gameState.playerPosition, GameState.Defaults.playerPosition)
    }
    
    func testAllMovementsAdvance() {
        let gameState = GameState(playerInputs: [.moveLeft, .moveRight, .moveDown, .moveUp])
        gameState.processCurrentInputs()
        XCTAssertEqual(gameState.playerPosition, GameState.Defaults.playerPosition)
    }
    
    func testDiagonalMovementAdvance() {
        let gameState = GameState(playerInputs: [.moveLeft, .moveUp])
        gameState.processCurrentInputs()
        
        let expected = Position(x: GameState.Defaults.playerPosition.x - 1, y: GameState.Defaults.playerPosition.y + 1)
        XCTAssertEqual(gameState.playerPosition, expected)
    }
    
    func testSingleDirectionRepeatedAdvance() {
        let gameState = GameState(playerInputs: [.moveLeft])
        
        for _ in 0..<10 {
            gameState.processCurrentInputs()
        }
        
        let expected = Position(x: GameState.Defaults.playerPosition.x - 10, y: GameState.Defaults.playerPosition.y)
        XCTAssertEqual(gameState.playerPosition, expected)
    }
    
}

// MARK: - Helpers

private extension GameState {
    func moveRepeatedly(amountTimes: Int = 1, command: InputCommand) {
        for _ in 0..<amountTimes {
            self.processInput(command: command)
        }
    }
    
    func moveTo(position: Position) {
        if self.playerPosition.x < position.x {
            self.moveRepeatedly(amountTimes: position.x - self.playerPosition.x, command: .moveRight)
        } else {
            self.moveRepeatedly(amountTimes: self.playerPosition.x - position.x, command: .moveLeft)
        }
        
        if self.playerPosition.y < position.y {
            self.moveRepeatedly(amountTimes: position.y - self.playerPosition.y, command: .moveUp)
        } else {
            self.moveRepeatedly(amountTimes: self.playerPosition.y - position.y, command: .moveDown)
        }
    }
    
    func testCollectItem(itemPosition: Position, itemType: TileType) {
        let prevCollected = self.totalItemsCollected
        let tempScore = self.bossDamageDealt
        self.moveTo(position: itemPosition)
        XCTAssertEqual(self.bossDamageDealt, tempScore + itemType.bossDamageValue)
        XCTAssertEqual(prevCollected + 1, self.totalItemsCollected)
        XCTAssertNil(self.filledTiles[self.playerPosition])
    }
    
    func testSimpleMovement(amountTimes: Int = 1, command: InputCommand, expectedPosition: Position) {
        self.moveRepeatedly(amountTimes: amountTimes, command: command)
        XCTAssertEqual(self.playerPosition, expectedPosition)
    }
    
    func testDiagonalMovement(amountTimes: Int = 1, c1: InputCommand, c2: InputCommand, expected: Position) {
        for i in 0..<amountTimes {
            if i.isMultiple(of: 2) {
                self.processInput(command: c1)
            } else {
                self.processInput(command: c2)
            }
        }
        XCTAssertEqual(self.playerPosition, expected)
    }
}
