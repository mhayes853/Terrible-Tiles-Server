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
    
    func testSetPersists() async throws {
        let created = try await gameStateService.createNew()
        let updateState = GameStateInfo(
            id: created.id,
            filledTiles: [
                .init(x: 10, y: 5): .blueItem,
                .init(x: 13, y: 10): .redItem
            ],
            playerPosition: .init(x: 10, y: 4),
            isDead: false,
            itemScore: 0,
            stateKey: created.stateKey,
            createdAt: created.createdAt
        )
        
        try await gameStateService.update(updateState)
        
        try await assertMatchingPersisted(updateState)
        try await assertMatchingNotPersisted(created)
    }
    
    func testRemovePersists() async throws {
        let created = try await gameStateService.createNew()
        try await gameStateService.remove(id: created.id)
        try await assertMatchingNotPersisted(created)
    }
    
    func testLoadingStateWithInvalidKeyThrows() async throws {
        do {
            let created = try await gameStateService.createNew()
            _ = try await gameStateService.load(id: created.id, stateKey: .init())
            XCTFail("Passed state key does not match persisted state key, therefore this should throw.")
        } catch {
            XCTAssertTrue(error is GameStateService.StateError)
        }
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

class MockGameStateStore: GameStateStore {
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
