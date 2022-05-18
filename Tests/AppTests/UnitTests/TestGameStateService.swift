//
//  TestGameStateService.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import XCTest
@testable import App

// MARK: - Test Case

class TestGameStateService: XCTestCase {
    private var gameStateService: GameStateService!

    override func setUp() {
        super.setUp()
        self.gameStateService = .init(MockGameStateStore())
    }
    
    func testCreatePersists() async throws {
        let result = try await gameStateService.createNew()
        try await assertMatchingPersisted(result)
    }
    
    func testUpdateRespondsToActionsCorrectly() async throws {
        let gameInfo = try await gameStateService.createNew()
        let updatedGameInfo = try await gameStateService.runCommand(gameId: gameInfo.id, input: .leave, stateKey: gameInfo.stateKey)
        
        XCTAssertTrue(updatedGameInfo.isDead)
        try await assertMatchingPersisted(updatedGameInfo)
    }
    
    func testUpdateThrowsStateErrorOnInvalidStateKey() async throws {
        do {
            let created = try await gameStateService.createNew()
            _ = try await gameStateService.runCommand(gameId: created.id, input: .leave, stateKey: .init())
            XCTFail("Passed state key does not match persisted state key, therefore this should throw.")
        } catch {
            XCTAssertTrue(error is GameStateService.StateError)
        }
    }
    
    func testRemovePersists() async throws {
        let created = try await gameStateService.createNew()
        try await gameStateService.remove(id: created.id)
        try await assertMatchingNotPersisted(created)
    }
    
    private func assertMatchingPersisted(_ info: GameStateInfo) async throws {
        let persisted = try await gameStateService.load(id: info.id, stateKey: info.stateKey)
        XCTAssertEqual(info, persisted)
    }
    
    private func assertMatchingNotPersisted(_ info: GameStateInfo) async throws {
        guard let persisted = try await gameStateService.load(id: info.id, stateKey: info.stateKey) else {
            return
        }
        XCTAssertNotEqual(info, persisted)
    }

}

// MARK: - Mock GameStateStore

class MockGameStateStore: GameStateStoreProtocol {
    private var map = [UUID: GameStateInfo]()
    
    public func set(id: UUID, _ gameStateInfo: GameStateInfo) async throws {
        self.map[id] = gameStateInfo
    }
    
    public func get(id: UUID) async throws -> GameStateInfo? {
        return self.map[id]
    }
    
    public func remove(id: UUID) async throws {
        self.map.removeValue(forKey: id)
    }
}
